//
//  WeekdaysView.swift
//  
//
//  Created by Daniel Otero on 24/5/23.
//

import SwiftUI

struct WeekdaysView: View {
    var calendar: Calendar
    var style: CalendarStyle

    var body: some View {
        let items = calendar
            .shortWeekdaySymbols
            .shiftLeft(positions: calendar.firstWeekday - 1)
            .map { Item(text: $0) }

        ForEach(items) { weekdayItem in
            Text("\(weekdayItem.text)".capitalized)
                .font(style.headerStyle.weekDayFont)
                .foregroundColor(style.headerStyle.weekDayColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(style.headerStyle.weekDayBackground)
        }
    }

    private struct Item: Identifiable {
        var id = UUID()
        var text: String
    }
}
