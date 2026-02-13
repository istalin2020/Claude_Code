import Foundation

struct JesusWord: Codable, Identifiable, Equatable {
    let id: Int
    let day: Int
    let category: String
    let quote: String
    let reference: String
    let theme: String

    var categoryDisplay: String {
        switch category {
        case "DontBeAfraid": return "Don't Be Afraid"
        case "DontBeSad": return "Don't Be Sad"
        case "YouCanDoIt": return "You Can Do It"
        case "IAmThereForYou": return "I Am There For You"
        case "DontWorry": return "Don't Worry"
        case "YouAreBlessed": return "You Are Blessed"
        case "PrayYouWillGet": return "Pray & Receive"
        case "ParableMoral": return "Parable Wisdom"
        default: return category
        }
    }

    var categoryEmoji: String {
        switch category {
        case "DontBeAfraid": return "🛡️"
        case "DontBeSad": return "☀️"
        case "YouCanDoIt": return "💪"
        case "IAmThereForYou": return "🤲"
        case "DontWorry": return "🕊️"
        case "YouAreBlessed": return "✨"
        case "PrayYouWillGet": return "🙏"
        case "ParableMoral": return "📖"
        default: return "✝️"
        }
    }
}

struct HistoryEntry: Codable, Identifiable {
    let id: UUID
    let word: JesusWord
    let dateShown: Date

    init(word: JesusWord, dateShown: Date = Date()) {
        self.id = UUID()
        self.word = word
        self.dateShown = dateShown
    }
}
