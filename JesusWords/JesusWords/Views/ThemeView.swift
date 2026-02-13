import SwiftUI

struct ThemeView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var selectedAnimation: String? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: viewModel.selectedTheme)

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5)

                        Text("Themes")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5)

                        Text("Choose your visual experience")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)

                    // Current Theme Preview
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.white)
                            Text("Current Theme")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundColor(.white)
                            Spacer()
                        }

                        HStack(spacing: 14) {
                            Image(systemName: viewModel.selectedTheme.decorativeIcon)
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: viewModel.selectedTheme.gradientColors,
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.selectedTheme.name)
                                    .font(.system(size: 18, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                Text(viewModel.selectedTheme.subtitle)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                        }
                    }
                    .padding(18)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 16)

                    // Theme Grid
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(viewModel.themeManager.allThemes) { theme in
                            ThemePreviewCard(
                                theme: theme,
                                isSelected: theme.id == viewModel.selectedTheme.id,
                                isAnimating: selectedAnimation == theme.id
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    selectedAnimation = theme.id
                                    viewModel.selectTheme(theme)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    selectedAnimation = nil
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 100)
                }
            }
        }
    }
}

struct ThemePreviewCard: View {
    let theme: AppTheme
    let isSelected: Bool
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Theme Preview Image
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: theme.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                // Decorative overlays
                ForEach(Array(theme.overlayElements.enumerated()), id: \.offset) { _, overlay in
                    GeometryReader { geo in
                        Image(systemName: overlay.systemIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: overlay.size * 0.5, height: overlay.size * 0.5)
                            .foregroundColor(.white.opacity(overlay.opacity * 2))
                            .rotationEffect(.degrees(overlay.rotation))
                            .position(
                                x: geo.size.width * overlay.xOffset,
                                y: geo.size.height * overlay.yOffset
                            )
                    }
                }

                // Central icon
                VStack(spacing: 6) {
                    Image(systemName: theme.decorativeIcon)
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.3), radius: 4)

                    Image(systemName: "cross.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }

                // Light rays
                GeometryReader { geo in
                    Path { path in
                        let center = CGPoint(x: geo.size.width * 0.75, y: -10)
                        for i in stride(from: 0, to: 360, by: 45) {
                            let angle = Double(i) * .pi / 180
                            let length = max(geo.size.width, geo.size.height)
                            path.move(to: center)
                            path.addLine(to: CGPoint(
                                x: center.x + cos(angle) * length,
                                y: center.y + sin(angle) * length
                            ))
                        }
                    }
                    .stroke(Color.white.opacity(0.05), lineWidth: 15)
                }
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            // Theme Name & Label
            VStack(spacing: 3) {
                Text(theme.name)
                    .font(.system(size: 13, weight: .bold, design: theme.fontDesign))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(theme.subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.08))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(
                    isSelected ? Color.white : Color.white.opacity(0.15),
                    lineWidth: isSelected ? 2.5 : 1
                )
        )
        .shadow(
            color: isSelected ? Color.white.opacity(0.2) : Color.black.opacity(0.15),
            radius: isSelected ? 12 : 6,
            y: isSelected ? 2 : 4
        )
        .scaleEffect(isAnimating ? 0.92 : 1.0)
        .overlay(
            Group {
                if isSelected {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.green).padding(-2))
                                .shadow(color: .black.opacity(0.3), radius: 4)
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }
        )
    }
}
