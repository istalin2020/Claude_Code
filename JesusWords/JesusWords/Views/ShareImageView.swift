import SwiftUI

// The view that renders the shareable verse image
struct ShareImageView: View {
    let word: JesusWord
    let theme: AppTheme
    let size: CGSize

    var body: some View {
        ZStack {
            // Theme background gradient
            LinearGradient(
                gradient: Gradient(colors: theme.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Decorative overlay elements
            ForEach(Array(theme.overlayElements.enumerated()), id: \.offset) { _, overlay in
                Image(systemName: overlay.systemIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: overlay.size * 1.2, height: overlay.size * 1.2)
                    .foregroundColor(.white.opacity(overlay.opacity))
                    .rotationEffect(.degrees(overlay.rotation))
                    .position(
                        x: size.width * overlay.xOffset,
                        y: size.height * overlay.yOffset
                    )
            }

            // Cross watermark
            Image(systemName: "cross.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .foregroundColor(.white.opacity(0.04))
                .rotationEffect(.degrees(-15))
                .position(x: size.width * 0.5, y: size.height * 0.5)

            // Light rays
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
            .stroke(Color.white.opacity(0.04), lineWidth: 35)

            // Verse content
            VStack(spacing: 0) {
                Spacer().frame(height: size.height * 0.08)

                // Cross icon at top
                Image(systemName: "cross.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.3), radius: 4)

                Spacer().frame(height: 16)

                // Category
                HStack(spacing: 6) {
                    Text(word.categoryEmoji)
                        .font(.system(size: 16))
                    Text(word.categoryDisplay)
                        .font(.system(size: 14, weight: .semibold, design: theme.fontDesign))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.20))
                .clipShape(Capsule())

                Spacer().frame(height: 18)

                // Theme title
                Text(word.theme)
                    .font(.system(size: 22, weight: .bold, design: theme.fontDesign))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.2), radius: 3)

                Spacer().frame(height: 12)

                // Decorative divider
                Rectangle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 60, height: 2)

                Spacer().frame(height: 20)

                // Quote
                Text("\u{201C}\(word.quote)\u{201D}")
                    .font(.system(size: 22, weight: .medium, design: theme.fontDesign))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .padding(.horizontal, 32)
                    .shadow(color: .black.opacity(0.15), radius: 2)

                Spacer().frame(height: 20)

                // Reference
                Text("— \(word.reference)")
                    .font(.system(size: 18, weight: .semibold, design: theme.fontDesign))
                    .foregroundColor(.white.opacity(0.85))
                    .italic()

                Spacer()

                // Bottom bar: App icon + App name
                HStack {
                    // App Icon (bottom-left corner)
                    HStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.95, green: 0.75, blue: 0.30),
                                            Color(red: 0.85, green: 0.55, blue: 0.20)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 36, height: 36)
                                .shadow(color: .black.opacity(0.3), radius: 3, y: 2)

                            Image(systemName: "cross.fill")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 1) {
                            Text("Jesus Words")
                                .font(.system(size: 13, weight: .bold, design: theme.fontDesign))
                                .foregroundColor(.white)
                            Text("Daily Blessings")
                                .font(.system(size: 9))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }

                    Spacer()

                    Text("\u{271D}\u{FE0F}")
                        .font(.system(size: 22))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, size.height * 0.04)
            }
        }
        .frame(width: size.width, height: size.height)
    }
}

// Helper to generate the shareable UIImage
struct ShareImageRenderer {
    @MainActor
    static func renderImage(word: JesusWord, theme: AppTheme) -> UIImage? {
        let size = CGSize(width: 1080, height: 1920) // Instagram story size
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
