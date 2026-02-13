import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                HistoryView()
                    .tag(1)

                SettingsView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Tab Bar
            HStack(spacing: 0) {
                tabButton(icon: "house.fill", label: "Today", tag: 0)
                tabButton(icon: "clock.fill", label: "History", tag: 1)
                tabButton(icon: "gearshape.fill", label: "Settings", tag: 2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
            )
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
    }

    private func tabButton(icon: String, label: String, tag: Int) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tag
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(selectedTab == tag ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
    }
}
