import SwiftUI

struct CalendarEvent: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var participants: [User]
    var location: String?
    var isAllDay: Bool
    var recurrence: RecurrenceRule?
    var reminders: [Reminder]
    var colorHex: String
    var notes: String?
    
    enum RecurrenceRule: Codable, Equatable {
        case daily
        case weekly(onDays: [Weekday])
        case monthly(onDay: Int)
        case yearly(onMonth: Int, day: Int)
        case custom(rule: String)
    }
    
    enum Weekday: Int, Codable {
        case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    }
    
    struct Reminder: Codable, Equatable {
        var timeInterval: TimeInterval
        var type: ReminderType
        
        enum ReminderType: Codable {
            case notification
            case email
            case both
        }
    }
    
    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    init(id: UUID = UUID(), title: String, description: String = "", startDate: Date, endDate: Date, participants: [User] = [], location: String? = nil, isAllDay: Bool = false, recurrence: RecurrenceRule? = nil, reminders: [Reminder] = [], color: Color = .blue, notes: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.participants = participants
        self.location = location
        self.isAllDay = isAllDay
        self.recurrence = recurrence
        self.reminders = reminders
        self.colorHex = color.toHex() ?? "#0000FF"
        self.notes = notes
    }
}

extension CalendarEvent {
    static func ==(lhs: CalendarEvent, rhs: CalendarEvent) -> Bool {
        lhs.id == rhs.id
    }
}

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
