import SwiftUI

// MARK: - Share Image View (1080x1080 — Square IG Post)

struct ShareImageView: View {
    let word: JesusWord
    let theme: AppTheme
    let size: CGSize
    let appIconImage: UIImage?
    var language: AppLanguage = .english

    private var displayQuote: String {
        if language == .tamil, let tq = word.tamilQuote { return tq }
        return word.quote
    }

    private var displayTheme: String {
        if language == .tamil, let tt = word.tamilTheme { return tt }
        return word.theme
    }

    private var displayCategory: String {
        language == .tamil ? word.tamilCategoryDisplay : word.categoryDisplay
    }

    /// Adaptive font sizes based on quote length — scales everything down for long quotes
    private var quoteFontSize: CGFloat {
        let length = displayQuote.count
        if length < 80 { return 72 }
        if length < 120 { return 64 }
        if length < 180 { return 52 }
        if length < 280 { return 42 }
        if length < 400 { return 34 }
        return 26
    }

    private var quoteLineSpacing: CGFloat {
        let length = displayQuote.count
        if length < 120 { return 28 }
        if length < 180 { return 20 }
        if length < 280 { return 14 }
        return 10
    }

    private var themeTitleFontSize: CGFloat {
        let length = displayQuote.count
        if length < 180 { return 52 }
        if length < 280 { return 44 }
        if length < 400 { return 38 }
        return 32
    }

    private var referenceFontSize: CGFloat {
        let length = displayQuote.count
        if length < 180 { return 40 }
        if length < 280 { return 34 }
        if length < 400 { return 28 }
        return 24
    }

    private var categoryFontSize: CGFloat {
        let length = displayQuote.count
        if length < 280 { return 32 }
        if length < 400 { return 28 }
        return 24
    }

    private var categoryEmojiSize: CGFloat {
        let length = displayQuote.count
        if length < 280 { return 36 }
        if length < 400 { return 30 }
        return 26
    }

    private var cardInternalPadding: CGFloat {
        let length = displayQuote.count
        if length < 180 { return 36 }
        if length < 280 { return 28 }
        if length < 400 { return 22 }
        return 16
    }

    private var cardItemSpacing: CGFloat {
        let length = displayQuote.count
        if length < 180 { return 20 }
        if length < 280 { return 16 }
        if length < 400 { return 12 }
        return 8
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
            ThemeIcon(systemName: overlay.systemIcon)
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
            // Top cross icon
            topCrossIcon

            Spacer().frame(height: 16)

            // "Jesus Words" title
            jesusWordsTitle

            Spacer().frame(height: size.height * 0.025)

            // Main card with quote content
            quoteCard

            Spacer().frame(height: size.height * 0.025)

            // Bottom branding with app icon at bottom left
            bottomBranding
        }
        .padding(.horizontal, 52)
        .padding(.top, size.height * 0.07)
        .padding(.bottom, size.height * 0.06)
    }

    private var topCrossIcon: some View {
        LatinCrossIcon(size: 72)
            .foregroundColor(.white.opacity(0.92))
            .shadow(color: .black.opacity(0.25), radius: 6)
    }

    private var jesusWordsTitle: some View {
        Text(language == .tamil ? "இயேசுவின் வார்த்தைகள்" : "Jesus Words")
            .font(.system(size: 56, weight: .bold, design: .serif))
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.2), radius: 4)
    }

    // MARK: - Quote Card

    private var quoteCard: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: cardInternalPadding)

            categoryBadge

            Spacer().frame(height: cardItemSpacing)

            themeTitle

            Spacer().frame(height: cardItemSpacing * 0.8)

            decorativeDivider

            Spacer().frame(height: cardItemSpacing)

            quoteText

            Spacer().frame(height: cardItemSpacing)

            referenceText

            Spacer().frame(height: cardInternalPadding)
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
                .font(.system(size: categoryEmojiSize))
            Text(displayCategory)
                .font(.system(size: categoryFontSize, weight: .semibold, design: .serif))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }

    private var themeTitle: some View {
        Text(displayTheme)
            .font(.system(size: themeTitleFontSize, weight: .bold, design: .serif))
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
        Text("\u{201C}\(displayQuote)\u{201D}")
            .font(.system(size: quoteFontSize, weight: .medium, design: .serif))
            .italic()
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .lineSpacing(quoteLineSpacing)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(color: .black.opacity(0.1), radius: 2)
    }

    private var displayReference: String {
        if language == .tamil, let tr = word.tamilReference { return tr }
        return word.reference
    }

    private var referenceText: some View {
        Text("— \(displayReference)")
            .font(.system(size: referenceFontSize, weight: .semibold, design: .serif))
            .italic()
            .foregroundColor(.white.opacity(0.80))
    }

    // MARK: - Bottom Branding (Actual App Icon at bottom left)

    private var bottomBranding: some View {
        HStack(spacing: 14) {
            // Use UIImage-based loading for ImageRenderer compatibility
            if let uiImage = appIconImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(language == .tamil ? "இயேசுவின் வார்த்தைகள்" : "Jesus Words")
                    .font(.system(size: 34, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                Text(language == .tamil ? "தினசரி ஆசீர்வாதங்கள்" : "Daily Blessings")
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()
        }
    }
}

// MARK: - Image Renderer

struct ShareImageRenderer {
    /// Load the app icon as UIImage (asset catalog Image() doesn't work with ImageRenderer)
    private static func loadAppIcon() -> UIImage? {
        UIImage(named: "ShareAppIcon")
    }

    @MainActor
    static func renderImage(word: JesusWord, theme: AppTheme, language: AppLanguage = .english) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Square IG Post
        let appIcon = loadAppIcon()
        let view = ShareImageView(word: word, theme: theme, size: size, appIconImage: appIcon, language: language)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        return renderer.uiImage
    }

    @MainActor
    static func renderSquareImage(word: JesusWord, theme: AppTheme, language: AppLanguage = .english) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Square post size
        let appIcon = loadAppIcon()
        let view = ShareImageView(word: word, theme: theme, size: size, appIconImage: appIcon, language: language)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 1.0
        return renderer.uiImage
    }
}
