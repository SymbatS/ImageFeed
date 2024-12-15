import Foundation

final class DateFormatter {
    static let iso8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
    
    static let localizedDateFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
