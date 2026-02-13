import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var selectedEntry: HistoryEntry?

    var body: some View {
        ZStack {
            BackgroundView(dayOfYear: viewModel.todaysDayNumber)

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("History")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    Text("Your Daily Blessings")
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
                        Text("No history yet")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Your daily words will appear here")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.history) { entry in
                                HistoryCard(entry: entry)
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
        }
    }
}

struct HistoryCard: View {
    let entry: HistoryEntry

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: entry.dateShown)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(entry.word.categoryEmoji)
                Text(entry.word.categoryDisplay)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(dateString)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }

            Text(entry.word.theme)
                .font(.system(size: 16, weight: .bold, design: .serif))
                .foregroundColor(.white)

            Text("\u{201C}\(entry.word.quote)\u{201D}")
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(3)
                .lineSpacing(3)

            Text("— \(entry.word.reference)")
                .font(.system(size: 13, weight: .medium, design: .serif))
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

    var body: some View {
        ZStack {
            BackgroundView(dayOfYear: entry.word.day)

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

                    Text(entry.word.categoryDisplay)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))

                    Text(entry.word.theme)
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundColor(.white)

                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 60, height: 2)

                    Text("\u{201C}\(entry.word.quote)\u{201D}")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .padding(.horizontal, 20)

                    Text("— \(entry.word.reference)")
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundColor(.white.opacity(0.85))
                        .italic()

                    let formatter: DateFormatter = {
                        let f = DateFormatter()
                        f.dateStyle = .long
                        return f
                    }()

                    Text("Shown on \(formatter.string(from: entry.dateShown))")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(28)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
                .padding(.horizontal, 20)

                // Share button
                ShareLink(
                    item: "\u{201C}\(entry.word.quote)\u{201D} — \(entry.word.reference)\n\nShared from Jesus Words App \u{271D}\u{FE0F}"
                ) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
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
    }
}
