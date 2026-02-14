#!/usr/bin/env python3
"""Generate app icon for Jesus Words app - Jesus with lamb, cross, dove, golden rays."""

from PIL import Image, ImageDraw, ImageFilter, ImageFont
import math

SIZE = 1024
CENTER = SIZE // 2


def lerp_color(c1, c2, t):
    """Linear interpolation between two RGB colors."""
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def draw_rounded_cross(draw, cx, cy, v_top, v_bottom, h_left, h_right, arm_w, color, radius=10):
    """Draw a cross with rounded rectangles."""
    half_w = arm_w // 2
    draw.rounded_rectangle(
        [cx - half_w, v_top, cx + half_w, v_bottom],
        radius=radius, fill=color
    )
    draw.rounded_rectangle(
        [h_left, cy - half_w, h_right, cy + half_w],
        radius=radius, fill=color
    )


def create_icon():
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # === 1. RADIAL GRADIENT BACKGROUND ===
    # Warm purple center -> golden amber edges (matching the attached image)
    color_center = (55, 15, 85)        # Deep purple
    color_mid1 = (100, 25, 95)         # Rich purple
    color_mid2 = (170, 55, 70)         # Warm rose
    color_outer = (225, 160, 45)       # Golden amber

    for y in range(SIZE):
        for x in range(SIZE):
            dx = x - CENTER
            dy = y - (CENTER - 40)
            dist = math.sqrt(dx * dx + dy * dy) / (SIZE * 0.68)
            dist = min(dist, 1.0)

            if dist < 0.25:
                t = dist / 0.25
                color = lerp_color(color_center, color_mid1, t)
            elif dist < 0.55:
                t = (dist - 0.25) / 0.3
                color = lerp_color(color_mid1, color_mid2, t)
            else:
                t = (dist - 0.55) / 0.45
                color = lerp_color(color_mid2, color_outer, t)

            img.putpixel((x, y), (*color, 255))

    # === 2. DIVINE LIGHT RAYS from behind cross ===
    rays_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    rays_draw = ImageDraw.Draw(rays_layer)

    ray_cx = CENTER
    ray_cy = CENTER - 80
    num_rays = 28
    ray_length = SIZE * 0.95

    for i in range(num_rays):
        angle = (i * 360 / num_rays) * math.pi / 180
        half_width = 3.8 * math.pi / 180

        x1, y1 = ray_cx, ray_cy
        x2 = ray_cx + math.cos(angle - half_width) * ray_length
        y2 = ray_cy + math.sin(angle - half_width) * ray_length
        x3 = ray_cx + math.cos(angle + half_width) * ray_length
        y3 = ray_cy + math.sin(angle + half_width) * ray_length

        rays_draw.polygon([(x1, y1), (x2, y2), (x3, y3)],
                          fill=(255, 235, 170, 35))

    rays_layer = rays_layer.filter(ImageFilter.GaussianBlur(radius=14))
    img = Image.alpha_composite(img, rays_layer)

    # === 3. CENTER GLOW behind cross ===
    glow_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)

    for r in range(350, 0, -2):
        alpha = int(30 * (1 - r / 350))
        glow_draw.ellipse(
            [CENTER - r, CENTER - 100 - r, CENTER + r, CENTER - 100 + r],
            fill=(255, 230, 150, alpha)
        )

    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=35))
    img = Image.alpha_composite(img, glow_layer)

    # === 4. THE CROSS (large, behind Jesus) ===
    cross_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    cross_draw = ImageDraw.Draw(cross_layer)

    cross_cx = CENTER
    cross_cy = CENTER - 40
    arm_w = 60

    v_top = cross_cy - 280
    v_bottom = cross_cy + 340
    h_left = cross_cx - 210
    h_right = cross_cx + 210

    # Cross shadow
    shadow_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_layer)
    draw_rounded_cross(shadow_draw, cross_cx + 8, cross_cy + 8,
                       v_top + 8, v_bottom + 8, h_left + 8, h_right + 8,
                       arm_w, (0, 0, 0, 55), 12)
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(radius=18))
    img = Image.alpha_composite(img, shadow_layer)

    # Base gold cross
    draw_rounded_cross(cross_draw, cross_cx, cross_cy,
                       v_top, v_bottom, h_left, h_right,
                       arm_w, (210, 170, 65, 255), 12)

    # Light highlight (left/top edge)
    hl = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    hl_draw = ImageDraw.Draw(hl)
    half_w = arm_w // 2
    hl_draw.rounded_rectangle(
        [cross_cx - half_w, v_top, cross_cx - half_w + 20, v_bottom],
        radius=8, fill=(255, 235, 150, 110)
    )
    hl_draw.rounded_rectangle(
        [h_left, cross_cy - half_w, h_right, cross_cy - half_w + 20],
        radius=8, fill=(255, 235, 150, 110)
    )
    hl = hl.filter(ImageFilter.GaussianBlur(radius=6))
    cross_layer = Image.alpha_composite(cross_layer, hl)

    # Dark edge (right/bottom)
    dk = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    dk_draw = ImageDraw.Draw(dk)
    dk_draw.rounded_rectangle(
        [cross_cx + half_w - 16, v_top, cross_cx + half_w, v_bottom],
        radius=6, fill=(160, 120, 30, 80)
    )
    dk_draw.rounded_rectangle(
        [h_left, cross_cy + half_w - 16, h_right, cross_cy + half_w],
        radius=6, fill=(160, 120, 30, 80)
    )
    dk = dk.filter(ImageFilter.GaussianBlur(radius=5))
    cross_layer = Image.alpha_composite(cross_layer, dk)

    img = Image.alpha_composite(img, cross_layer)

    # Cross intersection glow
    cg = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    cg_draw = ImageDraw.Draw(cg)
    for r in range(120, 0, -1):
        alpha = int(50 * (1 - r / 120))
        cg_draw.ellipse(
            [cross_cx - r, cross_cy - r, cross_cx + r, cross_cy + r],
            fill=(255, 255, 210, alpha)
        )
    cg = cg.filter(ImageFilter.GaussianBlur(radius=22))
    img = Image.alpha_composite(img, cg)

    # === 5. JESUS FIGURE (silhouette holding lamb) ===
    jesus_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    j_draw = ImageDraw.Draw(jesus_layer)

    jx = CENTER  # Jesus center x
    jy = CENTER + 40  # Jesus center y (lower body center)

    # Jesus silhouette color (dark warm brown, slightly transparent)
    j_color = (60, 35, 25, 210)
    j_highlight = (90, 55, 35, 160)

    # Head
    head_cx = jx + 5
    head_cy = jy - 205
    head_r = 42
    j_draw.ellipse(
        [head_cx - head_r, head_cy - head_r - 5,
         head_cx + head_r, head_cy + head_r - 5],
        fill=j_color
    )

    # Hair flowing down (slightly wider at bottom)
    hair_points = [
        (head_cx - 38, head_cy - 10),
        (head_cx - 48, head_cy + 30),
        (head_cx - 40, head_cy + 65),
        (head_cx - 25, head_cy + 80),
        (head_cx + 25, head_cy + 80),
        (head_cx + 40, head_cy + 65),
        (head_cx + 42, head_cy + 30),
        (head_cx + 38, head_cy - 10),
    ]
    j_draw.polygon(hair_points, fill=(50, 28, 18, 190))

    # Neck
    j_draw.rectangle(
        [jx - 14, jy - 170, jx + 20, jy - 145],
        fill=j_color
    )

    # Body/Robe (flowing triangular shape)
    robe_points = [
        (jx - 18, jy - 155),   # Left shoulder
        (jx - 100, jy + 210),  # Left robe bottom
        (jx - 60, jy + 250),   # Left foot area
        (jx + 5, jy + 250),    # Center bottom
        (jx + 70, jy + 250),   # Right foot area
        (jx + 110, jy + 210),  # Right robe bottom
        (jx + 35, jy - 155),   # Right shoulder
    ]
    j_draw.polygon(robe_points, fill=j_color)

    # Robe fold highlight (center)
    fold_points = [
        (jx + 5, jy - 140),
        (jx - 10, jy + 250),
        (jx + 20, jy + 250),
        (jx + 15, jy - 140),
    ]
    j_draw.polygon(fold_points, fill=j_highlight)

    # Left arm (extended slightly, cradling lamb)
    left_arm = [
        (jx - 18, jy - 145),  # shoulder
        (jx - 85, jy - 70),   # elbow area
        (jx - 110, jy - 30),  # forearm
        (jx - 100, jy - 15),  # hand area
        (jx - 80, jy - 25),
        (jx - 60, jy - 55),
        (jx - 15, jy - 120),
    ]
    j_draw.polygon(left_arm, fill=j_color)

    # Right arm (supporting lamb from below)
    right_arm = [
        (jx + 35, jy - 145),   # shoulder
        (jx + 75, jy - 90),    # upper arm
        (jx + 95, jy - 50),    # elbow
        (jx + 85, jy - 25),    # forearm
        (jx + 65, jy - 15),    # hand
        (jx + 50, jy - 25),
        (jx + 45, jy - 65),
        (jx + 30, jy - 120),
    ]
    j_draw.polygon(right_arm, fill=j_color)

    # === LAMB (in Jesus's arms) ===
    lamb_color = (235, 225, 210, 220)
    lamb_highlight = (255, 248, 235, 200)

    # Lamb body (oval)
    lamb_cx = jx - 10
    lamb_cy = jy - 45
    j_draw.ellipse(
        [lamb_cx - 55, lamb_cy - 28, lamb_cx + 40, lamb_cy + 28],
        fill=lamb_color
    )
    # Lamb body highlight
    j_draw.ellipse(
        [lamb_cx - 40, lamb_cy - 20, lamb_cx + 25, lamb_cy + 10],
        fill=lamb_highlight
    )

    # Lamb head
    lh_cx = lamb_cx + 45
    lh_cy = lamb_cy - 15
    j_draw.ellipse(
        [lh_cx - 22, lh_cy - 18, lh_cx + 18, lh_cy + 16],
        fill=lamb_color
    )

    # Lamb ear
    j_draw.ellipse(
        [lh_cx + 8, lh_cy - 22, lh_cx + 24, lh_cy - 8],
        fill=(215, 200, 185, 200)
    )

    # Lamb eye
    j_draw.ellipse(
        [lh_cx + 2, lh_cy - 6, lh_cx + 8, lh_cy],
        fill=(40, 25, 15, 200)
    )

    # Lamb legs (hanging down)
    for lx_off in [-30, -10, 15, 30]:
        j_draw.rounded_rectangle(
            [lamb_cx + lx_off - 5, lamb_cy + 20,
             lamb_cx + lx_off + 5, lamb_cy + 50],
            radius=3, fill=(215, 200, 185, 200)
        )

    jesus_layer = jesus_layer.filter(ImageFilter.GaussianBlur(radius=1.5))
    img = Image.alpha_composite(img, jesus_layer)

    # === 6. DOVE (Holy Spirit) above cross ===
    dove_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    dv_draw = ImageDraw.Draw(dove_layer)

    dove_cx = CENTER
    dove_cy = CENTER - 360

    # Dove body
    dv_draw.ellipse(
        [dove_cx - 28, dove_cy - 14, dove_cx + 28, dove_cy + 14],
        fill=(255, 255, 255, 210)
    )

    # Left wing (spread wide)
    lwing = [
        (dove_cx - 15, dove_cy - 2),
        (dove_cx - 50, dove_cy - 30),
        (dove_cx - 95, dove_cy - 65),
        (dove_cx - 80, dove_cy - 20),
        (dove_cx - 50, dove_cy + 5),
        (dove_cx - 25, dove_cy + 8),
    ]
    dv_draw.polygon(lwing, fill=(255, 255, 255, 190))

    # Right wing (spread wide)
    rwing = [
        (dove_cx + 15, dove_cy - 2),
        (dove_cx + 50, dove_cy - 30),
        (dove_cx + 95, dove_cy - 65),
        (dove_cx + 80, dove_cy - 20),
        (dove_cx + 50, dove_cy + 5),
        (dove_cx + 25, dove_cy + 8),
    ]
    dv_draw.polygon(rwing, fill=(255, 255, 255, 190))

    # Dove head
    dv_draw.ellipse(
        [dove_cx + 18, dove_cy - 14, dove_cx + 38, dove_cy + 4],
        fill=(255, 255, 255, 220)
    )

    # Tail feathers
    tail = [
        (dove_cx - 25, dove_cy),
        (dove_cx - 55, dove_cy + 15),
        (dove_cx - 45, dove_cy + 5),
        (dove_cx - 30, dove_cy + 8),
    ]
    dv_draw.polygon(tail, fill=(255, 255, 255, 170))

    # Dove glow
    dove_glow = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    dg_draw = ImageDraw.Draw(dove_glow)
    for r in range(60, 0, -1):
        alpha = int(35 * (1 - r / 60))
        dg_draw.ellipse(
            [dove_cx - r, dove_cy - r, dove_cx + r, dove_cy + r],
            fill=(255, 255, 230, alpha)
        )
    dove_glow = dove_glow.filter(ImageFilter.GaussianBlur(radius=15))
    img = Image.alpha_composite(img, dove_glow)

    dove_layer = dove_layer.filter(ImageFilter.GaussianBlur(radius=1.8))
    img = Image.alpha_composite(img, dove_layer)

    # === 7. SPARKLE STARS ===
    sparkle_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(sparkle_layer)

    star_positions = [
        (170, 140, 16), (840, 180, 13), (130, 720, 11),
        (870, 680, 15), (280, 90, 9), (740, 100, 10),
        (90, 430, 8), (930, 480, 9), (460, 110, 7),
        (580, 880, 8), (190, 870, 10), (840, 860, 7),
        (370, 930, 6), (670, 930, 8), (750, 360, 6),
        (260, 380, 5), (520, 70, 7), (910, 330, 6),
        (150, 560, 7), (890, 560, 8),
    ]

    for sx, sy, sr in star_positions:
        for angle in [0, 90]:
            rad = angle * math.pi / 180
            x1 = sx + math.cos(rad) * sr * 2.5
            y1 = sy + math.sin(rad) * sr * 2.5
            x2 = sx - math.cos(rad) * sr * 2.5
            y2 = sy - math.sin(rad) * sr * 2.5
            s_draw.line([(x1, y1), (x2, y2)], fill=(255, 255, 230, 130), width=2)
        s_draw.ellipse([sx - 3, sy - 3, sx + 3, sy + 3], fill=(255, 255, 240, 190))

    sparkle_layer = sparkle_layer.filter(ImageFilter.GaussianBlur(radius=1.5))
    img = Image.alpha_composite(img, sparkle_layer)

    # === 8. TEXT "Jesus words" at bottom ===
    text_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    t_draw = ImageDraw.Draw(text_layer)

    font_size = 62
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf", font_size)
    except (IOError, OSError):
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf", font_size)
        except (IOError, OSError):
            font = ImageFont.load_default()

    text = "Jesus words"
    bbox = t_draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    tx = CENTER - tw // 2
    ty = SIZE - 160

    # Shadow
    t_draw.text((tx + 3, ty + 3), text, fill=(0, 0, 0, 70), font=font)
    # Gold text
    t_draw.text((tx, ty), text, fill=(255, 225, 140, 230), font=font)

    img = Image.alpha_composite(img, text_layer)

    # === 9. SUBTLE BORDER ===
    border_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(border_layer)
    b_draw.rounded_rectangle(
        [2, 2, SIZE - 2, SIZE - 2],
        radius=220, outline=(255, 220, 140, 45), width=4
    )
    img = Image.alpha_composite(img, border_layer)

    # === 10. Convert to RGB and save ===
    final = Image.new('RGB', (SIZE, SIZE), (0, 0, 0))
    final.paste(img, mask=img.split()[3])

    icon_path = "/home/user/Claude_Code/JesusWords/JesusWords/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
    final.save(icon_path, "PNG", quality=100)
    print(f"Icon saved to {icon_path}")
    print(f"Size: {final.size}")

    return icon_path


if __name__ == "__main__":
    create_icon()
