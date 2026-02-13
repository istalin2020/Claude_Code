import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: WordsViewModel
    @State private var selectedTime = Date()
    @State private var showingSaved = false

    var body: some View {
        ZStack {
            ThemeBackgroundView(theme: viewModel.selectedTheme)

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.system(size: 32, weight: .bold, design: viewModel.selectedTheme.fontDesign))
                            .foregroundColor(.white)
                        Text("Customize your experience")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 20)

                    // Reminder Time
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                            Text("Reminder Time")
                                .font(.system(size: 18, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white)
                            Spacer()
                        }

                        DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .colorScheme(.dark)

                        Button(action: saveReminder) {
                            HStack {
                                Image(systemName: showingSaved ? "checkmark.circle.fill" : "bell.badge")
                                Text(showingSaved ? "Saved!" : "Update Reminder")
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(showingSaved ? Color.green.opacity(0.4) : Color.white.opacity(0.2))
                                    .overlay(Capsule().stroke(Color.white.opacity(0.4), lineWidth: 1))
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 16)

                    // About Section
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundColor(.white)
                            Text("About")
                                .font(.system(size: 18, weight: .semibold, design: viewModel.selectedTheme.fontDesign))
                                .foregroundColor(.white)
                            Spacer()
                        }

                        Text("Jesus Words brings you 365 authentic spoken words of Jesus Christ from the New Testament. Start each day with His wisdom, comfort, and encouragement.")
                            .font(.system(size: 14, design: viewModel.selectedTheme.fontDesign))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)

                        Divider().background(Color.white.opacity(0.3))

                        VStack(spacing: 8) {
                            aboutRow(label: "Total Words", value: "365")
                            aboutRow(label: "Categories", value: "8")
                            aboutRow(label: "Source", value: "New Testament (NIV)")
                            aboutRow(label: "Version", value: "1.0.0")
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 100)
                }
            }
        }
        .onAppear {
            let hour = UserDefaults.standard.integer(forKey: "reminderHour")
            let minute = UserDefaults.standard.integer(forKey: "reminderMinute")
            var components = DateComponents()
            components.hour = hour > 0 ? hour : 7
            components.minute = minute
            if let date = Calendar.current.date(from: components) {
                selectedTime = date
            }
        }
    }

    private func aboutRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.6))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white.opacity(0.9))
        }
    }

    private func saveReminder() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let hour = components.hour ?? 7
        let minute = components.minute ?? 0
        viewModel.setReminder(hour: hour, minute: minute)

        withAnimation {
            showingSaved = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showingSaved = false
            }
        }
    }
}
