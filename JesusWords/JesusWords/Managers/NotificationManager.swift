import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    /// Schedule notifications for the next 7 days, each with the correct word for that day.
    func scheduleDailyNotifications(hour: Int, minute: Int, allWords: [JesusWord]) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        guard !allWords.isEmpty else { return }

        for dayOffset in 0..<7 {
            guard let futureDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }

            // Calculate the correct word for this specific future date
            let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: futureDate) ?? 1
            let wordIndex = (dayOfYear - 1) % allWords.count
            let word = allWords[wordIndex]

            let content = UNMutableNotificationContent()
            content.title = "✝️ Jesus Words"
            content.subtitle = word.reference
            content.body = word.quote
            content.sound = .default
            content.badge = 1

            // Use exact date (year/month/day/hour/minute) — non-repeating
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: futureDate)
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "jesuswords-day-\(dayOffset)", content: content, trigger: trigger)
            center.add(request)
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
