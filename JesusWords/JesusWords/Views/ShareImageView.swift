import SwiftUI

// MARK: - Share Image View (1080x1080 — Square IG Post)

struct ShareImageView: View {
    let word: JesusWord
    let theme: AppTheme
    let size: CGSize

    /// Adaptive font size based on quote length (3x scaled for image rendering)
    private var quoteFontSize: CGFloat {
        let length = word.quote.count
        if length < 80 { return 96 }
        if length < 150 { return 80 }
        if length < 250 { return 68 }
        if length < 400 { return 58 }
        return 52
    }

    private var quoteLineSpacing: CGFloat {
        let length = word.quote.count
        if length < 150 { return 36 }
        if length < 300 { return 28 }
        return 22
    }

    var body: some View {
        ZStack {
            themeBackground
            decorativeOverlays
            crossWatermark
            lightRaysEffect
            contentLayout
        }
        .frame(width: size.width, height: size.height)
    }

    // MARK: - Background

    private var themeBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: theme.gradientColors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Decorative Overlays

    private var decorativeOverlays: some View {
        ForEach(Array(theme.overlayElements.enumerated()), id: \.offset) { _, overlay in
            Image(systemName: overlay.systemIcon)
                .resizable()
                .scaledToFit()
                .frame(width: overlay.size * 2.0, height: overlay.size * 2.0)
                .foregroundColor(.white.opacity(overlay.opacity))
                .rotationEffect(.degrees(overlay.rotation))
                .position(
                    x: size.width * overlay.xOffset,
                    y: size.height * overlay.yOffset
                )
        }
    }

    // MARK: - Cross Watermark

    private var crossWatermark: some View {
        Image(systemName: "cross.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 400, height: 400)
            .foregroundColor(.white.opacity(0.04))
            .rotationEffect(.degrees(-15))
            .position(x: size.width * 0.5, y: size.height * 0.45)
    }

    // MARK: - Light Rays

    private var lightRaysEffect: some View {
        Path { path in
            let center = CGPoint(x: size.width * 0.80, y: -30)
            for i in stride(from: 0, to: 360, by: 30) {
                let angle = Double(i) * .pi / 180
                let length = max(size.width, size.height) * 1.5
                path.move(to: center)
                path.addLine(to: CGPoint(
                    x: center.x + cos(angle) * length,
                    y: center.y + sin(angle) * length
                ))
            }
        }
        .stroke(Color.white.opacity(0.04), lineWidth: 50)
    }

    // MARK: - Content Layout

    private var contentLayout: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: size.height * 0.05)
            topCrossIcon
            Spacer().frame(height: 30)
            categoryBadge
            Spacer().frame(height: 24)
            themeTitle
            Spacer().frame(height: 20)
            decorativeDivider
            Spacer()
            quoteText
            Spacer()
            referenceText
            Spacer().frame(height: size.height * 0.05)
            bottomBranding
            Spacer().frame(height: size.height * 0.04)
        }
        .padding(.horizontal, 72)
    }

    private var topCrossIcon: some View {
        Image(systemName: "cross.fill")
            .font(.system(size: 96))
            .foregroundColor(.white.opacity(0.9))
            .shadow(color: .black.opacity(0.3), radius: 8)
    }

    private var categoryBadge: some View {
        HStack(spacing: 12) {
            Text(word.categoryEmoji)
                .font(.system(size: 48))
            Text(word.categoryDisplay)
                .font(.system(size: 42, weight: .semibold, design: theme.fontDesign))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 18)
        .background(Color.white.opacity(0.20))
        .clipShape(Capsule())
    }

    private var themeTitle: some View {
        Text(word.theme)
            .font(.system(size: 64, weight: .bold, design: theme.fontDesign))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .shadow(color: .black.opacity(0.2), radius: 4)
    }

    private var decorativeDivider: some View {
        HStack(spacing: 14) {
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 80, height: 3)
            Image(systemName: "sparkle")
                .font(.system(size: 24))
                .foregroundColor(.white.opacity(0.5))
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 80, height: 3)
        }
    }

    private var quoteText: some View {
        Text("\u{201C}\(word.quote)\u{201D}")
            .font(.system(size: quoteFontSize, weight: .medium, design: theme.fontDesign))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(quoteLineSpacing)
            .shadow(color: .black.opacity(0.15), radius: 3)
    }

    private var referenceText: some View {
        Text("— \(word.reference)")
            .font(.system(size: 52, weight: .semibold, design: theme.fontDesign))
            .foregroundColor(.white.opacity(0.85))
            .italic()
    }

    // MARK: - Bottom Branding (App Icon + App Name)

    private var bottomBranding: some View {
        HStack(spacing: 16) {
            AppIconView(theme: theme)

            VStack(alignment: .leading, spacing: 4) {
                Text("Jesus Words")
                    .font(.system(size: 40, weight: .bold, design: theme.fontDesign))
                    .foregroundColor(.white)
                Text("Daily Blessings")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
    }
}

// MARK: - App Icon View (Jesus with Sheep, Cross Background, Holy Spirit Dove)

struct AppIconView: View {
    let theme: AppTheme

    var body: some View {
        ZStack {
            iconBackground
            crossInBackground
            jesusWithSheep
            holySpiritDove
        }
        .frame(width: 120, height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
    }

    private var iconBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.20, green: 0.35, blue: 0.65),
                Color(red: 0.15, green: 0.20, blue: 0.45),
                Color(red: 0.10, green: 0.15, blue: 0.30)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // Cross in the background
    private var crossInBackground: some View {
        ZStack {
            // Vertical beam
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.15))
                .frame(width: 14, height: 88)
                .offset(y: -4)

            // Horizontal beam
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.15))
                .frame(width: 50, height: 12)
                .offset(y: -24)

            // Glow behind cross
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.92, blue: 0.60).opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 80, height: 80)
                .offset(y: -18)
        }
    }

    // Jesus figure with sheep
    private var jesusWithSheep: some View {
        ZStack {
            // Jesus figure (person)
            Image(systemName: "figure.stand")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(Color(red: 1.0, green: 0.92, blue: 0.70))
                .offset(x: -6, y: 8)

            // Sheep (small figure beside Jesus)
            Image(systemName: "hare.fill")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.7))
                .offset(x: 22, y: 28)

            // Second small sheep
            Image(systemName: "hare.fill")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
                .offset(x: 36, y: 22)
        }
    }

    // Holy Spirit dove at top center
    private var holySpiritDove: some View {
        ZStack {
            // Glow behind dove
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.4),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 18
                    )
                )
                .frame(width: 36, height: 36)
                .offset(y: -42)

            // Dove
            Image(systemName: "bird.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white.opacity(0.95))
                .offset(y: -42)
        }
    }
}

// MARK: - Image Renderer

struct ShareImageRenderer {
    @MainActor
    static func renderImage(word: JesusWord, theme: AppTheme) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Square IG Post
        let view = ShareImageView(word: word, theme: theme, size: size)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        return renderer.uiImage
    }

    @MainActor
    static func renderSquareImage(word: JesusWord, theme: AppTheme) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Square post size
        let view = ShareImageView(word: word, theme: theme, size: size)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        return renderer.uiImage
    }
}
