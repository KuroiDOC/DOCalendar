//
//  Calendar.swift
//  
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI

public struct CalendarView: View {
    var range: ClosedRange<Date>
    @Binding var selection: Set<Date>
    var calendar = Calendar.autoupdatingCurrent
    var gridItemMinimunWidth: CGFloat
    var style = CalendarStyle()

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private let items: [CalendarItem]

    public init(
        range: ClosedRange<Date>,
        selection: Binding<Set<Date>>,
        calendar: Calendar = Calendar.autoupdatingCurrent,
        gridItemMinimunWidth: CGFloat = 210,
        style: CalendarStyle = CalendarStyle()
    ) {
        self.range = range
        self._selection = selection
        self.calendar = calendar
        self.gridItemMinimunWidth = gridItemMinimunWidth
        self.style = style

//        items = (0...Self.numberOfMonthsIn(range: range, calendar: calendar)).map {
//            CalendarItem(decomposedDate: range.lowerBound.plus(months: $0).decomposed())
//        }
        items = Self.buildItems(range: range, calendar: calendar)
    }

    private static func buildItems(range: ClosedRange<Date>, calendar: Calendar) -> [CalendarItem] {
        guard let lowerBound = range.lowerBound.bySetting(day: 1) else {
            fatalError("Invalid date components")
        }

        var result: [CalendarItem] = []
        var date = calendar.startOfDay(for: lowerBound)
        repeat {
            let item = CalendarItem(decomposedDate: date.decomposed(calendar: calendar))
            result.append(item)
            date = date.plus(months: 1)
        } while range ~= date

        return result
    }

    public var body: some View {
        VStack {
            if horizontalSizeClass == .compact {
                HStack(spacing: 0) {
                    WeekdaysView(calendar: calendar, style: style)
                }
            }
            ScrollView {
                if horizontalSizeClass == .compact {
                    VStack {
                        innerBody
                    }
                } else {
                    let columns = [GridItem(.adaptive(minimum: gridItemMinimunWidth))]
                    LazyVGrid(columns: columns) {
                        innerBody
                    }
                }
            }
        }
    }

    private var innerBody: some View {
        ForEach(items) { item in
            VStack {
                MonthView(
                    month: item.decomposedDate.month,
                    year: item.decomposedDate.year,
                    range: adjustRange(range),
                    selections: $selection,
                    calendar: calendar,
                    style: style
                )
                Spacer()
            }
        }
    }

    /// Sets the range to the start of the day to the end of it
    func adjustRange(_ range: ClosedRange<Date>) -> ClosedRange<Date> {
        let lowerBound = calendar.startOfDay(for: range.lowerBound)
        let upperBound = calendar.startOfDay(for: range.upperBound).plus(days: 1, seconds: -1)
        return lowerBound...upperBound
    }
}

private struct CalendarItem: Identifiable {
    var decomposedDate: Date.Decomposed
    var id: String {
        "\(decomposedDate.year)-\(decomposedDate.month)"
    }
}
