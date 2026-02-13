#!/usr/bin/env python3
"""Generate a beautiful app icon for Jesus Words app."""

from PIL import Image, ImageDraw, ImageFilter, ImageFont
import math

SIZE = 1024
CENTER = SIZE // 2

def lerp_color(c1, c2, t):
    """Linear interpolation between two RGB colors."""
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))

def create_icon():
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # === 1. RADIAL GRADIENT BACKGROUND ===
    # Deep spiritual gradient: deep purple center -> warm gold edges
    color_center = (45, 20, 80)       # Deep royal purple
    color_mid1 = (90, 30, 100)        # Rich purple
    color_mid2 = (160, 60, 80)        # Warm rose
    color_outer = (220, 150, 50)      # Golden amber

    for y in range(SIZE):
        for x in range(SIZE):
            dx = x - CENTER
            dy = y - CENTER
            dist = math.sqrt(dx * dx + dy * dy) / (SIZE * 0.7)
            dist = min(dist, 1.0)

            if dist < 0.3:
                t = dist / 0.3
                color = lerp_color(color_center, color_mid1, t)
            elif dist < 0.6:
                t = (dist - 0.3) / 0.3
                color = lerp_color(color_mid1, color_mid2, t)
            else:
                t = (dist - 0.6) / 0.4
                color = lerp_color(color_mid2, color_outer, t)

            img.putpixel((x, y), (*color, 255))

    # === 2. DIVINE LIGHT RAYS from behind the cross ===
    rays_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    rays_draw = ImageDraw.Draw(rays_layer)

    ray_center_x = CENTER
    ray_center_y = CENTER - 60  # Slightly above center (behind cross intersection)
    num_rays = 24
    ray_length = SIZE * 0.85

    for i in range(num_rays):
        angle = (i * 360 / num_rays) * math.pi / 180
        half_width = 4.5 * math.pi / 180  # Ray width in radians

        x1 = ray_center_x
        y1 = ray_center_y

        x2 = ray_center_x + math.cos(angle - half_width) * ray_length
        y2 = ray_center_y + math.sin(angle - half_width) * ray_length

        x3 = ray_center_x + math.cos(angle + half_width) * ray_length
        y3 = ray_center_y + math.sin(angle + half_width) * ray_length

        rays_draw.polygon([(x1, y1), (x2, y2), (x3, y3)],
                         fill=(255, 235, 180, 30))

    # Blur the rays for softness
    rays_layer = rays_layer.filter(ImageFilter.GaussianBlur(radius=12))
    img = Image.alpha_composite(img, rays_layer)

    # === 3. OUTER GLOW / VIGNETTE ===
    glow_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)

    # Soft golden glow in center
    for r in range(300, 0, -2):
        alpha = int(25 * (1 - r / 300))
        glow_draw.ellipse(
            [CENTER - r, CENTER - 80 - r, CENTER + r, CENTER - 80 + r],
            fill=(255, 220, 140, alpha)
        )

    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=30))
    img = Image.alpha_composite(img, glow_layer)

    # === 4. THE CROSS - elegant golden cross ===
    cross_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    cross_draw = ImageDraw.Draw(cross_layer)

    # Cross dimensions
    cross_cx = CENTER
    cross_cy = CENTER - 20
    arm_width = 52
    half_w = arm_width // 2

    # Vertical bar
    v_top = cross_cy - 240
    v_bottom = cross_cy + 300

    # Horizontal bar
    h_left = cross_cx - 190
    h_right = cross_cx + 190
    h_top = cross_cy - 50
    h_bottom = cross_cy + 50

    # Cross shadow
    shadow_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_layer)
    shadow_offset = 8

    # Shadow vertical
    shadow_draw.rounded_rectangle(
        [cross_cx - half_w + shadow_offset, v_top + shadow_offset,
         cross_cx + half_w + shadow_offset, v_bottom + shadow_offset],
        radius=12, fill=(0, 0, 0, 60)
    )
    # Shadow horizontal
    shadow_draw.rounded_rectangle(
        [h_left + shadow_offset, h_top + shadow_offset,
         h_right + shadow_offset, h_bottom + shadow_offset],
        radius=12, fill=(0, 0, 0, 60)
    )
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(radius=15))
    img = Image.alpha_composite(img, shadow_layer)

    # Main cross body - golden gradient effect
    # Draw multiple layers for a metallic gold effect

    # Base gold
    cross_draw.rounded_rectangle(
        [cross_cx - half_w, v_top, cross_cx + half_w, v_bottom],
        radius=10, fill=(218, 175, 75, 255)
    )
    cross_draw.rounded_rectangle(
        [h_left, h_top, h_right, h_bottom],
        radius=10, fill=(218, 175, 75, 255)
    )

    # Lighter gold overlay for 3D effect (left/top highlight)
    highlight = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    h_draw = ImageDraw.Draw(highlight)

    # Vertical highlight strip
    h_draw.rounded_rectangle(
        [cross_cx - half_w, v_top, cross_cx - half_w + 18, v_bottom],
        radius=8, fill=(255, 230, 140, 120)
    )
    # Horizontal highlight strip
    h_draw.rounded_rectangle(
        [h_left, h_top, h_right, h_top + 18],
        radius=8, fill=(255, 230, 140, 120)
    )

    highlight = highlight.filter(ImageFilter.GaussianBlur(radius=5))
    cross_layer = Image.alpha_composite(cross_layer, highlight)

    # Darker gold for depth (right/bottom)
    depth = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    d_draw = ImageDraw.Draw(depth)

    d_draw.rounded_rectangle(
        [cross_cx + half_w - 14, v_top, cross_cx + half_w, v_bottom],
        radius=6, fill=(170, 130, 40, 80)
    )
    d_draw.rounded_rectangle(
        [h_left, h_bottom - 14, h_right, h_bottom],
        radius=6, fill=(170, 130, 40, 80)
    )

    depth = depth.filter(ImageFilter.GaussianBlur(radius=4))
    cross_layer = Image.alpha_composite(cross_layer, depth)

    img = Image.alpha_composite(img, cross_layer)

    # === 5. CROSS CENTER GLOW (where beams intersect) ===
    center_glow = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    cg_draw = ImageDraw.Draw(center_glow)

    for r in range(100, 0, -1):
        alpha = int(60 * (1 - r / 100))
        cg_draw.ellipse(
            [cross_cx - r, cross_cy - r, cross_cx + r, cross_cy + r],
            fill=(255, 255, 220, alpha)
        )

    center_glow = center_glow.filter(ImageFilter.GaussianBlur(radius=20))
    img = Image.alpha_composite(img, center_glow)

    # === 6. SPARKLE STARS ===
    sparkle_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(sparkle_layer)

    star_positions = [
        (180, 160, 18), (820, 200, 14), (150, 750, 12),
        (850, 700, 16), (300, 100, 10), (720, 120, 11),
        (100, 450, 9), (920, 500, 10), (480, 130, 8),
        (560, 870, 9), (200, 880, 11), (830, 870, 8),
        (380, 920, 7), (650, 920, 9), (730, 380, 7),
        (280, 400, 6), (500, 80, 8), (900, 350, 7),
    ]

    for sx, sy, sr in star_positions:
        # 4-pointed star
        for angle in [0, 90]:
            rad = angle * math.pi / 180
            x1 = sx + math.cos(rad) * sr * 2.5
            y1 = sy + math.sin(rad) * sr * 2.5
            x2 = sx - math.cos(rad) * sr * 2.5
            y2 = sy - math.sin(rad) * sr * 2.5
            s_draw.line([(x1, y1), (x2, y2)], fill=(255, 255, 230, 140), width=2)

        # Center dot
        s_draw.ellipse([sx - 3, sy - 3, sx + 3, sy + 3], fill=(255, 255, 240, 200))

    sparkle_layer = sparkle_layer.filter(ImageFilter.GaussianBlur(radius=1.5))
    img = Image.alpha_composite(img, sparkle_layer)

    # === 7. DOVE SILHOUETTE (small, elegant, above cross) ===
    dove_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    dv_draw = ImageDraw.Draw(dove_layer)

    # Simple elegant dove using curves - positioned above the cross
    dove_cx = CENTER
    dove_cy = CENTER - 310
    dove_scale = 0.7

    # Dove body (ellipse)
    body_w = int(35 * dove_scale)
    body_h = int(20 * dove_scale)
    dv_draw.ellipse(
        [dove_cx - body_w, dove_cy - body_h, dove_cx + body_w, dove_cy + body_h],
        fill=(255, 255, 255, 200)
    )

    # Left wing
    wing_points_l = [
        (dove_cx - 10, dove_cy),
        (dove_cx - 80, dove_cy - 55),
        (dove_cx - 60, dove_cy - 15),
        (dove_cx - 30, dove_cy + 5),
    ]
    wing_points_l = [(int(dove_cx + (x - dove_cx) * dove_scale),
                       int(dove_cy + (y - dove_cy) * dove_scale)) for x, y in wing_points_l]
    dv_draw.polygon(wing_points_l, fill=(255, 255, 255, 180))

    # Right wing
    wing_points_r = [
        (dove_cx + 10, dove_cy),
        (dove_cx + 80, dove_cy - 55),
        (dove_cx + 60, dove_cy - 15),
        (dove_cx + 30, dove_cy + 5),
    ]
    wing_points_r = [(int(dove_cx + (x - dove_cx) * dove_scale),
                       int(dove_cy + (y - dove_cy) * dove_scale)) for x, y in wing_points_r]
    dv_draw.polygon(wing_points_r, fill=(255, 255, 255, 180))

    # Head
    head_r = int(12 * dove_scale)
    dv_draw.ellipse(
        [dove_cx + int(20 * dove_scale) - head_r, dove_cy - head_r - int(5 * dove_scale),
         dove_cx + int(20 * dove_scale) + head_r, dove_cy + head_r - int(5 * dove_scale)],
        fill=(255, 255, 255, 200)
    )

    dove_layer = dove_layer.filter(ImageFilter.GaussianBlur(radius=2))
    img = Image.alpha_composite(img, dove_layer)

    # === 8. TEXT "JW" monogram at bottom ===
    text_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    t_draw = ImageDraw.Draw(text_layer)

    # Try to use a nice font, fall back to default
    font_size = 72
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf", font_size)
    except (IOError, OSError):
        try:
            font = ImageFont.truetype("/usr/share/fonts/truetype/liberation/LiberationSerif-Bold.ttf", font_size)
        except (IOError, OSError):
            font = ImageFont.load_default()

    text = "JW"
    bbox = t_draw.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    tx = CENTER - tw // 2
    ty = SIZE - 180

    # Text shadow
    t_draw.text((tx + 3, ty + 3), text, fill=(0, 0, 0, 80), font=font)
    # Main text - golden
    t_draw.text((tx, ty), text, fill=(255, 225, 150, 220), font=font)

    img = Image.alpha_composite(img, text_layer)

    # === 9. SUBTLE BORDER ===
    border_layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(border_layer)

    # Rounded rect border (iOS icons are masked to rounded rect)
    margin = 2
    b_draw.rounded_rectangle(
        [margin, margin, SIZE - margin, SIZE - margin],
        radius=220, outline=(255, 220, 140, 50), width=4
    )

    img = Image.alpha_composite(img, border_layer)

    # === 10. FINAL: Convert to RGB (iOS icons don't use alpha) ===
    final = Image.new('RGB', (SIZE, SIZE), (0, 0, 0))
    final.paste(img, mask=img.split()[3])

    # Save
    icon_path = "/home/user/Claude_Code/JesusWords/JesusWords/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
    final.save(icon_path, "PNG", quality=100)
    print(f"Icon saved to {icon_path}")
    print(f"Size: {final.size}")

    return icon_path

if __name__ == "__main__":
    create_icon()
