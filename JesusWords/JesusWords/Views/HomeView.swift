import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            BackgroundView(dayOfYear: viewModel.todaysDayNumber)

            ScrollView {
                VStack(spacing: 24) {
                    Spacer().frame(height: 20)

                    // App Title
                    VStack(spacing: 4) {
                        Image(systemName: "cross.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5)

                        Text("Jesus Words")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 5)

                        Text("Day \(viewModel.todaysDayNumber) of 365")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 10)

                    // Today's Word Card
                    if let word = viewModel.todaysWord {
                        VStack(spacing: 16) {
                            // Category Badge
                            HStack {
                                Text(word.categoryEmoji)
                                Text(word.categoryDisplay)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.25))
                            .clipShape(Capsule())
                            .foregroundColor(.white)

                            // Theme
                            Text(word.theme)
                                .font(.system(size: 18, weight: .bold, design: .serif))
                                .foregroundColor(.white)

                            // Divider
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 60, height: 2)

                            // Quote
                            Text("\u{201C}\(word.quote)\u{201D}")
                                .font(.system(size: 20, weight: .medium, design: .serif))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineSpacing(6)
                                .padding(.horizontal, 8)

                            // Reference
                            Text("— \(word.reference)")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
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

                    // Share Button
                    if let word = viewModel.todaysWord {
                        ShareLink(
                            item: "\u{201C}\(word.quote)\u{201D} — \(word.reference)\n\nShared from Jesus Words App \u{271D}\u{FE0F}",
                            subject: Text("Jesus Words - \(word.theme)"),
                            message: Text(word.quote)
                        ) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share This Blessing")
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
    }
}
