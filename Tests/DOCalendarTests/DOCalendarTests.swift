import XCTest
@testable import DOCalendar

final class DOCalendarTests: XCTestCase {
    func testFirstWeekDayShouldNeverBeLessThanOne() throws {
        Locale.availableIdentifiers
            .map { Locale(identifier: $0 ) }
            .forEach { locale in
                let calendar = locale.calendar
                for year in 2020...2030 {
                    for month in 1...12 {
                        let spares = calendar.weekdaysBeforeMonthStarts(month: month, year: year)
                        XCTAssertTrue(0...6 ~= spares, "Failed for \(year)-\(month)\nLocale \(locale.identifier)\nCalendar \(calendar.identifier)")
                    }
                }
            }
    }
}
