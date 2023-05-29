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
    }

    var numberOfMonthsInRange: Int {
        guard let monthsBetween = calendar.dateComponents([.month], from: range.lowerBound, to: range.upperBound).month else {
            fatalError("Illegal state")
        }
        return monthsBetween
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
        ForEach(0...numberOfMonthsInRange, id: \.self) { offset in
            let decomposedDate = range.lowerBound.plus(months: offset).decomposed()
            VStack {
                MonthView(
                    month: decomposedDate.month,
                    year: decomposedDate.year,
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
