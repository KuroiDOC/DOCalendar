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
    var style = CalendarStyle()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    public init(range: ClosedRange<Date>, selection: Binding<Set<Date>>, calendar: Calendar = Calendar.autoupdatingCurrent, style: CalendarStyle = CalendarStyle()) {
        self.range = range
        self._selection = selection
        self.calendar = calendar
        self.style = style
    }

    var numberOfMonthsInRange: Int {
        guard let monthsBetween = calendar.dateComponents([.month], from: range.lowerBound, to: range.upperBound).month else {
            fatalError("Illegal state")
        }
        return monthsBetween
    }

    public var body: some View {
        ScrollView {
            if horizontalSizeClass == .compact {
                VStack {
                    innerBody
                }
            } else {
                let columns = [GridItem(.adaptive(minimum: 210))]
                LazyVGrid(columns: columns) {
                    innerBody
                }
            }
        }
    }

    private var innerBody: some View {
        ForEach(0...numberOfMonthsInRange, id: \.self) { offset in
            let decomposedDate = range.lowerBound.plus(months: offset).decomposed()
            VStack {
                MonthView(month: decomposedDate.month, year: decomposedDate.year, selections: $selection, calendar: calendar, style: style)
                Spacer()
            }
        }
    }
}
