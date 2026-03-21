import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var selectedEntry: HistoryEntry?

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: viewModel.selectedTheme)

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text(viewModel.selectedLanguage == .tamil ? "வரலாறு" : "History")
                        .font(.system(size: 32, weight: .bold, design: viewModel.selectedTheme.fontDesign))
                        .foregroundColor(.white)
                    Text(viewModel.selectedLanguage == .tamil ? "உங்கள் தினசரி ஆசீர்வாதங்கள்" : "Your Daily Blessings")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 20)
                .padding(.bottom, 16)

                if viewModel.history.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.5))
                        Text(viewModel.selectedLanguage == .tamil ? "இதுவரை வரலாறு இல்லை" : "No history yet")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                        Text(viewModel.selectedLanguage == .tamil ? "உங்கள் தினசரி வார்த்தைகள் இங்கே தோன்றும்" : "Your daily words will appear here")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.history) { entry in
                                HistoryCard(entry: entry, fontDesign: viewModel.selectedTheme.fontDesign, language: viewModel.selectedLanguage)
                                    .onTapGesture {
                                        selectedEntry = entry
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            HistoryDetailView(entry: entry)
                .environmentObject(viewModel)
        }
    }
}

struct HistoryCard: View {
    let entry: HistoryEntry
    var fontDesign: Font.Design = .serif
    var language: AppLanguage = .english

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: entry.dateShown)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.word.categoryEmoji)
                Text(language == .tamil ? entry.word.tamilCategoryDisplay : entry.word.categoryDisplay)
                    .font(.system(size: 12, weight: .semibold, design: fontDesign))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(dateString)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }

            Text(language == .tamil ? (entry.word.tamilTheme ?? entry.word.theme) : entry.word.theme)
                .font(.system(size: 16, weight: .bold, design: fontDesign))
                .foregroundColor(.white)

            let displayQuote = (language == .tamil && entry.word.tamilQuote != nil) ? entry.word.tamilQuote! : entry.word.quote
            Text("\u{201C}\(displayQuote)\u{201D}")
                .font(.system(size: 14, design: fontDesign))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(3)
                .lineSpacing(3)

            let displayRef = (language == .tamil && entry.word.tamilReference != nil) ? entry.word.tamilReference! : entry.word.reference
            Text("— \(displayRef)")
                .font(.system(size: 13, weight: .medium, design: fontDesign))
                .foregroundColor(.white.opacity(0.7))
                .italic()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

struct HistoryDetailView: View {
    let entry: HistoryEntry
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var shareableImage: ShareableImage? = nil

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: viewModel.selectedTheme)

            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .padding()

                Spacer()

                VStack(spacing: 16) {
                    Text(entry.word.categoryEmoji)
                        .font(.system(size: 44))

                    Text(viewModel.selectedLanguage == .tamil ? entry.word.tamilCategoryDisplay : entry.word.categoryDisplay)
                        .font(.system(size: 16, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                        .foregroundColor(.white.opacity(0.8))

                    Text(viewModel.selectedLanguage == .tamil ? (entry.word.tamilTheme ?? entry.word.theme) : entry.word.theme)
                        .font(.system(size: 24, weight: .bold, design: viewModel.selectedTheme.fontDesign))
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 60, height: 2)

                    let displayQuote = (viewModel.selectedLanguage == .tamil && entry.word.tamilQuote != nil) ? entry.word.tamilQuote! : entry.word.quote
                    Text("\u{201C}\(displayQuote)\u{201D}")
                        .font(.system(size: 22, weight: .medium, design: viewModel.selectedTheme.fontDesign))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 20)

                    let detailRef = (viewModel.selectedLanguage == .tamil && entry.word.tamilReference != nil) ? entry.word.tamilReference! : entry.word.reference
                    Text("— \(detailRef)")
                        .font(.system(size: 18, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                        .foregroundColor(.white.opacity(0.85))
                        .italic()

                    let formatter: DateFormatter = {
                        let f = DateFormatter()
                        f.dateStyle = .long
                        return f
                    }()

                    Text(viewModel.selectedLanguage == .tamil
                        ? "\(formatter.string(from: entry.dateShown)) அன்று காட்டப்பட்டது"
                        : "Shown on \(formatter.string(from: entry.dateShown))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal, 20)

                // Share as Image button
                Button(action: {
                    if let rendered = ShareImageRenderer.renderImage(
                        word: entry.word,
                        theme: viewModel.selectedTheme,
                        language: viewModel.selectedLanguage
                    ) {
                        shareableImage = ShareableImage(image: rendered)
                    }
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle.angled")
                        Text(viewModel.selectedLanguage == .tamil ? "படமாகப் பகிரு" : "Share as Image")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(Color.white.opacity(0.2)))
                }

                Spacer()
            }
        }
        .sheet(item: $shareableImage) { item in
            ShareSheet(activityItems: [item.image])
        }
    }
}
