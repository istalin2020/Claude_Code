import SwiftUI

// MARK: - Share Image View (1080x1080 — Square IG Post)

struct ShareImageView: View {
    let word: JesusWord
    let theme: AppTheme
    let size: CGSize

    /// Adaptive font size based on quote length (scaled for 1080 image rendering)
    private var quoteFontSize: CGFloat {
        let length = word.quote.count
        if length < 80 { return 72 }
        if length < 120 { return 64 }
        if length < 180 { return 56 }
        if length < 280 { return 48 }
        if length < 400 { return 42 }
        return 36
    }

    private var quoteLineSpacing: CGFloat {
        let length = word.quote.count
        if length < 120 { return 28 }
        if length < 250 { return 22 }
        return 16
    }

    var body: some View {
        ZStack {
            themeBackground
            decorativeOverlays
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
            Spacer().frame(height: size.height * 0.04)

            // Top cross icon
            topCrossIcon

            Spacer().frame(height: 16)

            // "Jesus Words" title
            jesusWordsTitle

            Spacer().frame(height: size.height * 0.03)

            // Main card with quote content
            quoteCard

            Spacer().frame(height: size.height * 0.03)

            // Bottom branding with app icon at left
            bottomBranding

            Spacer().frame(height: size.height * 0.035)
        }
        .padding(.horizontal, 52)
    }

    private var topCrossIcon: some View {
        Image(systemName: "cross.fill")
            .font(.system(size: 72))
            .foregroundColor(.white.opacity(0.92))
            .shadow(color: .black.opacity(0.25), radius: 6)
    }

    private var jesusWordsTitle: some View {
        Text("Jesus Words")
            .font(.system(size: 56, weight: .bold, design: .serif))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 4)
    }

    // MARK: - Quote Card

    private var quoteCard: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 36)

            categoryBadge

            Spacer().frame(height: 20)

            themeTitle

            Spacer().frame(height: 16)

            decorativeDivider

            Spacer().frame(height: 24)

            quoteText

            Spacer().frame(height: 24)

            referenceText

            Spacer().frame(height: 36)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.black.opacity(0.22))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var categoryBadge: some View {
        HStack(spacing: 10) {
            Text(word.categoryEmoji)
                .font(.system(size: 36))
            Text(word.categoryDisplay)
                .font(.system(size: 32, weight: .semibold, design: .serif))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }

    private var themeTitle: some View {
        Text(word.theme)
            .font(.system(size: 52, weight: .bold, design: .serif))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .shadow(color: .black.opacity(0.15), radius: 3)
    }

    private var decorativeDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 70, height: 2)
            Image(systemName: "sparkle")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.4))
            Rectangle()
                .fill(Color.white.opacity(0.25))
                .frame(width: 70, height: 2)
        }
    }

    private var quoteText: some View {
        Text("\u{201C}\(word.quote)\u{201D}")
            .font(.system(size: quoteFontSize, weight: .medium, design: .serif))
            .italic()
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(quoteLineSpacing)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(color: .black.opacity(0.1), radius: 2)
    }

    private var referenceText: some View {
        Text("— \(word.reference)")
            .font(.system(size: 40, weight: .semibold, design: .serif))
            .italic()
            .foregroundColor(.white.opacity(0.80))
    }

    // MARK: - Bottom Branding (App Icon at bottom left)

    private var bottomBranding: some View {
        HStack(spacing: 14) {
            // Use the actual generated app icon from asset catalog
            AppIconView(theme: theme)

            VStack(alignment: .leading, spacing: 3) {
                Text("Jesus Words")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                Text("Daily Blessings")
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundColor(.white.opacity(0.55))
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
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
    }

    private var iconBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.22, green: 0.08, blue: 0.33),
                Color(red: 0.40, green: 0.12, blue: 0.39),
                Color(red: 0.66, green: 0.24, blue: 0.31),
                Color(red: 0.88, green: 0.63, blue: 0.18)
            ],
            startPoint: .center,
            endPoint: .init(x: 1.0, y: 1.0)
        )
    }

    // Cross in the background
    private var crossInBackground: some View {
        ZStack {
            // Vertical beam
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.82, green: 0.67, blue: 0.25).opacity(0.85))
                .frame(width: 12, height: 72)
                .offset(y: -2)

            // Horizontal beam
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(red: 0.82, green: 0.67, blue: 0.25).opacity(0.85))
                .frame(width: 46, height: 11)
                .offset(y: -20)

            // Glow behind cross
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 1.0, green: 0.92, blue: 0.60).opacity(0.25),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 35
                    )
                )
                .frame(width: 70, height: 70)
                .offset(y: -14)
        }
    }

    // Jesus figure with sheep
    private var jesusWithSheep: some View {
        ZStack {
            // Jesus figure
            Image(systemName: "figure.stand")
                .font(.system(size: 34, weight: .medium))
                .foregroundColor(Color(red: 0.25, green: 0.14, blue: 0.10).opacity(0.85))
                .offset(x: -2, y: 8)

            // Sheep
            Image(systemName: "hare.fill")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.65))
                .offset(x: 18, y: 24)
        }
    }

    // Holy Spirit dove
    private var holySpiritDove: some View {
        ZStack {
            // Glow behind dove
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.white.opacity(0.35),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 15
                    )
                )
                .frame(width: 30, height: 30)
                .offset(y: -38)

            // Dove
            Image(systemName: "bird.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white.opacity(0.90))
                .offset(y: -38)
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
