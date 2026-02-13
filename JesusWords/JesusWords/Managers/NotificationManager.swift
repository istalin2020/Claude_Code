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

    func scheduleDailyNotification(hour: Int, minute: Int, quote: String, reference: String) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Schedule notifications for the next 7 days
        for dayOffset in 0..<7 {
            let content = UNMutableNotificationContent()
            content.title = "✝️ Jesus Words"
            content.subtitle = reference
            content.body = quote
            content.sound = .default
            content.badge = 1

            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute

            if dayOffset == 0 {
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "jesuswords-daily", content: content, trigger: trigger)
                center.add(request)
            } else {
                guard let futureDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }
                let futureComponents = Calendar.current.dateComponents([.year, .month, .day], from: futureDate)
                dateComponents.year = futureComponents.year
                dateComponents.month = futureComponents.month
                dateComponents.day = futureComponents.day

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let request = UNNotificationRequest(identifier: "jesuswords-day-\(dayOffset)", content: content, trigger: trigger)
                center.add(request)
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
