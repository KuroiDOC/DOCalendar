//
//  Date+Utils.swift
//  
//
//  Created by Daniel Otero on 23/5/23.
//

import Foundation

extension Date {
    struct Decomposed {
        public var year: Int
        public var month: Int
        public var day: Int
        public var hour: Int
        public var minute: Int

        public init(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) {
            self.year = year
            self.month = month
            self.day = day
            self.hour = hour
            self.minute = minute
        }
    }

    func decomposed(calendar: Calendar = Calendar.current) -> Decomposed {
        let dateComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]

        let components = calendar.dateComponents(dateComponents, from: self)
        guard let year = components.year, let month = components.month, let day = components.day, let hour = components.hour, let minute = components.minute else {
            fatalError("Invalid date components")
        }
        return Decomposed(year: year, month: month, day: day, hour: hour, minute: minute)
    }

    /// Adds time amounts to date. Can be used with negative amounts
    func plus(days: Int = 0, months: Int = 0, years: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let calendar = Calendar.current
        let dateComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]

        var components = calendar.dateComponents(dateComponents, from: self)
        components.day = components.day! + days
        components.month = components.month! + months
        components.year = components.year! + years
        components.hour = components.hour! + hours
        components.minute = components.minute! + minutes
        components.second = components.second! + seconds

        return calendar.date(from: components)!
    }

    static func bySetting(day: Int? = nil, month: Int? = nil, year: Int? = nil, calendar: Calendar = .autoupdatingCurrent) -> Date? {
        bySetting(components: DateComponents(), day: day, month: month, year: year, calendar: calendar)
    }

    func bySetting(day: Int? = nil, month: Int? = nil, year: Int? = nil, calendar: Calendar = .autoupdatingCurrent) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)

        return Self.bySetting(components: components, day: day, month: month, year: year, calendar: calendar)
    }

    private static func bySetting(components: DateComponents, day: Int? = nil, month: Int? = nil, year: Int? = nil, calendar: Calendar) -> Date? {
        var components = components

        if let day {
            components.day = day
        }
        if let month {
            components.month = month
        }
        if let year {
            components.year = year
        }

        return calendar.date(from: components)
    }
}

extension Calendar {
    func weekdaysBeforeMonthStarts(month: Int, year: Int) -> Int {
        guard let date = Date.bySetting(day: 1, month: month, year: year, calendar: self) else {
            fatalError("Invalid date components")
        }

        let result = self.component(.weekday, from: date) - self.firstWeekday
        switch result {
        case ..<0:
            return result + 7
        default:
            return result
        }
    }
}
