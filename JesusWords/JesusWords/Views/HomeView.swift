import SwiftUI

struct ShareableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct HomeView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var isAnimating = false
    @State private var shareableImage: ShareableImage? = nil
    @State private var showExplanation = false

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: viewModel.selectedTheme)

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    // App Title + Language Toggle
                    ZStack {
                        // Center: App Title
                        VStack(spacing: 4) {
                            LatinCrossIcon(size: 36)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 5)

                            Text(viewModel.selectedLanguage == .tamil ? "இயேசுவின் வார்த்தைகள்" : "Jesus Words")
                                .font(.system(size: 32, weight: .bold, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        }

                        // Top Right: Language Toggle
                        HStack {
                            Spacer()
                            LanguageToggle(selectedLanguage: $viewModel.selectedLanguage) { language in
                                viewModel.setLanguage(language)
                            }
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)

                    // Today's Word Card
                    if let word = viewModel.todaysWord {
                        VStack(spacing: 16) {
                            // Category Badge
                            HStack {
                                Text(word.categoryEmoji)
                                Text(viewModel.selectedLanguage == .tamil ? word.tamilCategoryDisplay : word.categoryDisplay)
                                    .font(.system(size: 14, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Capsule())
                            .foregroundColor(.white)

                            // Theme
                            Text(word.theme)
                                .font(.system(size: 18, weight: .bold, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white)

                            // Divider
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 60, height: 2)

                            // Quote
                            let displayQuote = (viewModel.selectedLanguage == .tamil && word.tamilQuote != nil) ? word.tamilQuote! : word.quote
                            Text("\u{201C}\(displayQuote)\u{201D}")
                                .font(.system(size: 20, weight: .medium, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 8)

                            // Reference
                            Text("— \(word.reference)")
                                .font(.system(size: 16, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white.opacity(0.85))
                                .italic()
                        }
                        .padding(28)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
                        )
                        .padding(.horizontal, 20)
                        .scaleEffect(isAnimating ? 1.0 : 0.95)
                        .opacity(isAnimating ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.8), value: isAnimating)
                    }

                    // Share as Image Button
                    if let word = viewModel.todaysWord {
                        Button(action: {
                            if let rendered = ShareImageRenderer.renderImage(
                                word: word,
                                theme: viewModel.selectedTheme
                            ) {
                                shareableImage = ShareableImage(image: rendered)
                            }
                        }) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text(viewModel.selectedLanguage == .tamil ? "இந்த ஆசீர்வாதத்தைப் பகிரு" : "Share This Blessing")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                            )
                        }

                        // Understand This Verse Button
                        Button(action: {
                            showExplanation = true
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                Text(viewModel.selectedLanguage == .tamil ? "இந்த வசனத்தைப் புரிந்துகொள்" : "Understand This Verse")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                            )
                        }
                    }

                    Spacer().frame(height: 100)
                }
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
        }
        .sheet(item: $shareableImage) { item in
            ShareSheet(activityItems: [item.image])
        }
        .sheet(isPresented: $showExplanation) {
            if let word = viewModel.todaysWord {
                ExplanationView(word: word, language: viewModel.selectedLanguage, theme: viewModel.selectedTheme)
            }
        }
    }
}

// MARK: - Language Toggle
struct LanguageToggle: View {
    @Binding var selectedLanguage: AppLanguage
    var onToggle: (AppLanguage) -> Void

    var body: some View {
        HStack(spacing: 0) {
            toggleButton(for: .english, label: "En")
            toggleButton(for: .tamil, label: "த")
        }
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private func toggleButton(for language: AppLanguage, label: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedLanguage = language
                onToggle(language)
            }
        }) {
            Text(label)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    selectedLanguage == language ? Color.white.opacity(0.3) : Color.clear
                )
                .clipShape(Capsule())
        }
    }
}

// MARK: - Explanation View
struct ExplanationView: View {
    let word: JesusWord
    let language: AppLanguage
    let theme: AppTheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: theme)

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Title
                    VStack(spacing: 8) {
                        Image(systemName: "book.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)

                        Text(language == .tamil ? "வசன விளக்கம்" : "Verse Explanation")
                            .font(.system(size: 24, weight: .bold, design: theme.fontDesign))
                            .foregroundColor(.white)
                    }

                    // The Verse Card
                    VStack(spacing: 12) {
                        let displayQuote = (language == .tamil && word.tamilQuote != nil) ? word.tamilQuote! : word.quote
                        Text("\u{201C}\(displayQuote)\u{201D}")
                            .font(.system(size: 16, weight: .medium, design: theme.fontDesign))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)

                        Text("— \(word.reference)")
                            .font(.system(size: 14, weight: .semibold, design: theme.fontDesign))
                            .foregroundColor(.white.opacity(0.85))
                            .italic()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.15))
                    )
                    .padding(.horizontal, 20)

                    // Explanation Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                            Text(language == .tamil ? "எளிய விளக்கம்" : "Simple Explanation")
                                .font(.system(size: 18, weight: .bold, design: theme.fontDesign))
                                .foregroundColor(.white)
                        }

                        let explanationText: String = {
                            if language == .tamil, let tamilExp = word.tamilExplanation {
                                return tamilExp
                            } else if let exp = word.explanation {
                                return exp
                            } else {
                                return language == .tamil
                                    ? "இந்த வசனத்தின் விளக்கம் விரைவில் கிடைக்கும்."
                                    : "Explanation coming soon."
                            }
                        }()

                        Text(explanationText)
                            .font(.system(size: 16, weight: .regular, design: theme.fontDesign))
                            .foregroundColor(.white.opacity(0.95))
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 40)
                }
            }
        }
    }
}

// UIKit share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
