import SwiftUI

@main
struct JesusWordsApp: App {
    @StateObject private var viewModel = WordsViewModel()
    @AppStorage("hasCompletedSetup") private var hasCompletedSetup = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedSetup {
                ContentView()
                    .environmentObject(viewModel)
            } else {
                ReminderSetupView(hasCompletedSetup: $hasCompletedSetup)
                    .environmentObject(viewModel)
            }
        }
    }
}
