import Foundation
import SwiftUI

internal struct MonthView: View {
    var month: Int
    var year: Int
    @Binding
    var selections: Set<Date>
    var calendar: Calendar = Calendar.autoupdatingCurrent
    var style: CalendarStyle = CalendarStyle()

    public var body: some View {
        Text(monthName)
            .font(style.headerStyle.monthFont)
            .foregroundColor(style.headerStyle.monthColor)
            .background(style.headerStyle.monthBackground)

        let columns = [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]

        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
                Text("\(weekday)".capitalized)
                    .font(style.headerStyle.weekDayFont)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(style.headerStyle.weekDayColor)
                    .background(style.headerStyle.weekDayBackground)
            }

            let items = buildItems()
            ForEach(items) { item in
                if let day = item.day {
                    Button {
                        handleSelection(for: day)
                    } label: {
                        Text("\(day)")
                            .font(style.itemStyle.font)
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

    var lastDay: Int {
        var dateComponents = DateComponents(calendar: calendar)
        dateComponents.month = month
        dateComponents.year = year

        guard let date = dateComponents.date,
                let result =  calendar.range(of: .day, in: .month, for: date) else {
            fatalError("Invalid date components")
        }

        return result.upperBound - 1
    }

    // From 1 to 7
    var firstWeekDay: Int {
        var dateComponents = DateComponents(calendar: calendar)
        dateComponents.day = 1
        dateComponents.month = month
        dateComponents.year = year

        guard let date = dateComponents.date else {
            fatalError("Invalid date components")
        }

        return calendar.component(.weekday, from: date)
    }

    func buildItems() -> [Item] {
        let spares = (1..<firstWeekDay).map { _ in Item() }
        return spares + (1...lastDay).map {
            Item(day: $0)
        }
    }

    func date(for day: Int) -> Date {
        var dateComponents = DateComponents(calendar: calendar)
        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year

        guard let date = dateComponents.date else {
            fatalError("Invalid date components")
        }

        return date
    }

    @ViewBuilder
    func background(for day: Int) -> some View {
        let date = date(for: day)

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
        default:
            style.itemStyle.itemBackground
        }
    }

    @ViewBuilder
    func rangeSelectionBackground(date: Date) -> some View {
        if let selectionRange {
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
        if selections.contains(date(for: day)) {
            return style.selectionStyle.textColor
        }
        return style.itemStyle.textColor
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
        switch style.selectionStyle.selectionOption {
        case .single:
            selections = [date]
        case .range:
            switch selectionRange {
            case .none:
                selections.insert(date)
            case .some(let selectionRange) where selectionRange ~= date:
                selections = [date]
            case .some(let selectionRange):
                selections = [
                    min(selectionRange.lowerBound, date),
                    max(selectionRange.upperBound, date)
                ]
            }
        case .multi:
            selections.insert(date)
        }
    }
}

struct Item: Identifiable {
    var id = UUID()
    var day: Int?
}

struct Month_previews: PreviewProvider {
    struct Container: View {
        var month: Int
        var year: Int
        var style = CalendarStyle(selectionStyle: .init(selectionOption: .range))
        @State var selection: Set<Date> = .init()

        var body: some View {
            MonthView(month: 4, year: 2023, selections: $selection, style: style)
        }
    }

    static var previews: some View {
        ScrollView {
            VStack {
                MonthView(month: 2, year: 2023, selections: .constant([]))
                Container(month: 3, year: 2023)
                Container(month: 4, year: 2023, style: .init())
                Container(month: 5, year: 2023)
            }
        }
    }
}