import Foundation
import SwiftUI

class WordsViewModel: ObservableObject {
    @Published var allWords: [JesusWord] = []
    @Published var todaysWord: JesusWord?
    @Published var history: [HistoryEntry] = []
    @Published var reminderHour: Int = 7
    @Published var reminderMinute: Int = 0

    private let historyKey = "viewedWordsHistory"
    private let lastDayKey = "lastShownDay"

    init() {
        loadWords()
        loadHistory()
        loadTodaysWord()
    }

    func loadWords() {
        guard let url = Bundle.main.url(forResource: "jesus_words", withExtension: "json") else {
            print("Could not find jesus_words.json")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            allWords = try JSONDecoder().decode([JesusWord].self, from: data)
        } catch {
            print("Error loading words: \(error)")
        }
    }

    func loadTodaysWord() {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let wordIndex = (dayOfYear - 1) % max(allWords.count, 1)

        guard !allWords.isEmpty else { return }
        todaysWord = allWords[wordIndex]

        // Add to history if not already added today
        let today = Calendar.current.startOfDay(for: Date())
        let lastShownDate = UserDefaults.standard.object(forKey: lastDayKey) as? Date

        if lastShownDate == nil || !Calendar.current.isDate(lastShownDate!, inSameDayAs: today) {
            if let word = todaysWord {
                let entry = HistoryEntry(word: word, dateShown: Date())
                history.insert(entry, at: 0)
                saveHistory()
                UserDefaults.standard.set(today, forKey: lastDayKey)
            }
        }

        // Schedule notification with today's word
        if let word = todaysWord {
            let hour = UserDefaults.standard.integer(forKey: "reminderHour")
            let minute = UserDefaults.standard.integer(forKey: "reminderMinute")
            if hour > 0 || minute > 0 {
                NotificationManager.shared.scheduleDailyNotification(
                    hour: hour, minute: minute,
                    quote: word.quote, reference: word.reference
                )
            }
        }
    }

    func saveHistory() {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }

    func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else { return }
        if let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            history = decoded
        }
    }

    func setReminder(hour: Int, minute: Int) {
        reminderHour = hour
        reminderMinute = minute
        UserDefaults.standard.set(hour, forKey: "reminderHour")
        UserDefaults.standard.set(minute, forKey: "reminderMinute")

        if let word = todaysWord {
            NotificationManager.shared.scheduleDailyNotification(
                hour: hour, minute: minute,
                quote: word.quote, reference: word.reference
            )
        }
    }

    var todaysDayNumber: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
}
