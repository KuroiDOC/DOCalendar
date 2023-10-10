//
//  WeekdaysView.swift
//  
//
//  Created by Daniel Otero on 24/5/23.
//

import SwiftUI

public struct WeekdayItems: View {
    var calendar: Calendar
    var style: CalendarStyle

    public init(calendar: Calendar = .autoupdatingCurrent, style: CalendarStyle = .init()) {
        self.calendar = calendar
        self.style = style
    }

    public var body: some View {
        let items = calendar
            .shortWeekdaySymbols
            .shiftLeft(positions: calendar.firstWeekday - 1)
            .map { Item(text: $0) }

        ForEach(items) { weekdayItem in
            Text("\(weekdayItem.text)".capitalized)
                .font(style.headerStyle.weekDayFont)
                .foregroundColor(style.headerStyle.weekDayColor)
                .frame(maxWidth: .infinity)
        }
    }

    private struct Item: Identifiable {
        var id = UUID()
        var text: String
    }
}

#Preview {
    HStack {
        WeekdayItems(calendar: .autoupdatingCurrent, style: .init())
    }
    .padding([.horizontal, .top], 24)
    .background(Color.gray)
}

