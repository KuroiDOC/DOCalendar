import Foundation
import SwiftUI

internal struct MonthView: View {
    let month: Int
    let year: Int
    let range: ClosedRange<Date>
    @Binding
    var selections: [Date]
    let calendar: Calendar
    let style: CalendarStyle
    let allowsRepetition: Bool

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private let items: [Item]

    init(month: Int, year: Int, range: ClosedRange<Date>, selections: Binding<[Date]>, calendar: Calendar = Calendar.autoupdatingCurrent, style: CalendarStyle = CalendarStyle(), allowsRepetition: Bool = false) {
        self.month = month
        self.year = year
        self.range = range
        self._selections = selections
        self.calendar = calendar
        self.style = style
        self.items = Self.buildItems(calendar: calendar, month: month, year: year)
        self.allowsRepetition = allowsRepetition
    }

    public var body: some View {
        VStack {
            Text(verbatim: "\(monthName) \(year)")
                .textCase(style.headerStyle.monthCase)
                .font(style.headerStyle.monthFont)
                .foregroundColor(style.headerStyle.monthColor)
                .padding(.vertical, style.rowSpacing / 2)
                .background(style.headerStyle.monthBackground)

            let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

            LazyVGrid(columns: columns, spacing: style.rowSpacing) {
                if style.headerStyle.shouldDisplay, horizontalSizeClass != .compact {
                    WeekdayItems(calendar: calendar, style: style)
                        .padding(.vertical, 16)
                        .background(style.headerStyle.weekDayBackground)
                }

                ForEach(items) { item in
                    if let day = item.decomposedDate?.day {
                        Button {
                            handleSelection(for: day)
                        } label: {
                            Text("\(day)")
                                .font(font(for: day))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fill)
                                .foregroundColor(foregroundColor(for: day))
                                .background(
                                    background(for: day)
                                )
                        }

                    } else {
                        style.itemStyle.background
                    }
                }
            }
        }
    }

    static func lastDay(calendar: Calendar, month: Int, year: Int) -> Int {
        var dateComponents = DateComponents(calendar: calendar)
        dateComponents.day = 1
        dateComponents.month = month
        dateComponents.year = year

        guard let date = dateComponents.date,
              let result =  calendar.range(of: .day, in: .month, for: date) else {
            fatalError("Invalid date components")
        }

        return result.upperBound - 1
    }

    static func buildItems(calendar: Calendar, month: Int, year: Int) -> [Item] {
        let spareWeekdays = calendar.weekdaysBeforeMonthStarts(month: month, year: year)
        let lastDay = lastDay(calendar: calendar, month: month, year: year)

        let spares = (0..<spareWeekdays).map { _ in Item() }
        let result = spares + (1...lastDay).map {
            Item(decomposedDate: Date.Decomposed(year: year, month: month, day: $0))
        }

        return result + (1..<(7 - (result.count % 7))).map { _ in Item() }
    }

    func date(for day: Int) -> Date {
        guard let date = Date.bySetting(day: day, month: month, year: year, calendar: calendar) else {
            fatalError("Invalid date components")
        }

        return date
    }

    @ViewBuilder
    func background(for day: Int) -> some View {
        let date: Date = date(for: day)

        switch style.selectionStyle.selectionOption {
        case .single where selections.contains(date), .multi where selections.contains(date):
            Circle()
                .fill(style.selectionStyle.background)
        case .range where selections.contains(date) && selections.count == 1:
            Circle()
                .fill(style.selectionStyle.background)
        case .range where selections.contains(date) && selections.count == 2:
            Circle()
                .fill(style.selectionStyle.background)
                .background(
                    rangeSelectionBackground(date: date)
                )
        case .range where isDateInRange(date: date):
            style.selectionStyle.rangeBackground
        case _ where calendar.isDateInToday(date):
            AnyView(style.itemStyle.todayBackground)
        default:
            style.itemStyle.itemBackground
        }
    }

    @ViewBuilder
    func rangeSelectionBackground(date: Date) -> some View {
        if let selectionRange, selectionRange.lowerBound != selectionRange.upperBound {
            HStack {
                if selectionRange.lowerBound == date {
                    Rectangle()
                        .fill(style.itemStyle.itemBackground)
                    Rectangle()
                        .fill(style.selectionStyle.rangeBackground)
                } else {
                    Rectangle()
                        .fill(style.selectionStyle.rangeBackground)
                    Rectangle()
                        .fill(style.itemStyle.itemBackground)
                }
            }
        }
    }


    func isDateInRange(date: Date) -> Bool {
        if let selectionRange {
            return selectionRange ~= date
        }
        return false
    }

    func foregroundColor(for day: Int) -> Color {
        let date = date(for: day)
        if selections.contains(date) {
            return style.selectionStyle.textColor
        } else if range ~= date {
            return calendar.isDateInToday(date) ? style.itemStyle.todayTextColor : style.itemStyle.textColor
        } else {
            return style.itemStyle.unavailableTextColor
        }
    }

    func font(for day: Int) -> Font {
        let date = date(for: day)
        if selections.contains(date) {
            return style.selectionStyle.font
        } else if range ~= date {
            return calendar.isDateInToday(date) ? style.itemStyle.todayFont : style.itemStyle.font
        } else {
            return style.itemStyle.unavailableFont
        }
    }

    var selectionRange: ClosedRange<Date>? {
        let sortedSelections = selections.sorted(by: <)
        if sortedSelections.count == 2,
           let lower = sortedSelections.first,
           let upper = sortedSelections.last {
            return lower...upper
        }
        return nil
    }

    var monthName: String {
        let date = date(for: 1)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date).capitalized
    }

    func handleSelection(for day: Int) {
        let date = date(for: day)
        guard range ~= date else { return }

        switch style.selectionStyle.selectionOption {
        case .single:
            selections = [date]
        case .range:
            switch selectionRange {
            case .none:
                if allowsRepetition {
                    selections.append(date)
                } else {
                    var selectionSet = Set(selections)
                    selectionSet.insert(date)
                    selections = Array(selectionSet)
                }
            case .some(let selectionRange) where selectionRange ~= date:
                selections = [date]
            case .some(let selectionRange):
                selections = [
                    min(selectionRange.lowerBound, date),
                    max(selectionRange.upperBound, date)
                ]
            }
        case .multi:
            if allowsRepetition {
                selections.append(date)
            } else {
                var selectionSet = Set(selections)
                if selectionSet.contains(date) {
                    selectionSet.remove(date)
                } else {
                    selectionSet.insert(date)
                }
                selections = Array(selectionSet)
            }
        }
    }
}

struct Item: Identifiable {
    var id: String
    var decomposedDate: Date.Decomposed?

    init(decomposedDate: Date.Decomposed? = nil) {
        self.id = UUID().uuidString
        self.decomposedDate = decomposedDate

        if let decomposedDate {
            id = "\(decomposedDate.year)-\(decomposedDate.month)-\(decomposedDate.day)"
        }
    }
}

#if DEBUG



struct Container: View {
    var month: Int
    var year: Int
    var style = CalendarStyle(selectionStyle: .init(selectionOption: .range))
    @State var selection: [Date] = .init()

    static let range: ClosedRange<Date> = {
        let date = Date().plus(months: 1).decomposed()
        return Date.bySetting(day: 15, month: 2, year: 2023)!...Date.bySetting(day: date.day, month: date.month, year: date.year)!
    }()

    var body: some View {
        MonthView(month: month, year: year, range: Self.range, selections: $selection, style: style)
    }
}

#Preview("Default") {
    ScrollView {
        VStack {
            let date = Date().decomposed()
            MonthView(month: 2, year: 2023, range: Container.range, selections: .constant([]))
            Container(month: 3, year: 2023)
            Container(month: 4, year: 2023, style: .init())
            Container(month: 5, year: 2023)
            Container(month: date.month, year: date.year)
        }
    }
}

#Preview("Spaced") {
    ScrollView {
        VStack {
            Container(month: 3, year: 2023, style: .init(rowSpacing: 32))
            Container(month: 4, year: 2023, style: .init(rowSpacing: 32))
        }
    }
}

#Preview("Today background") {
    ScrollView {
        VStack {
            let date = Date().decomposed()
            Container(month: date.month, year: date.year, style: .init(
                itemStyle: .init(todayBackground: Circle().stroke(Color.black).padding(1))
            ))
        }
    }
}
#endif
