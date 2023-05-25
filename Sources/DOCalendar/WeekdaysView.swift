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
        ForEach(calendar.shortWeekdaySymbols, id: \.self) { weekday in
            Text("\(weekday)".capitalized)
                .font(style.headerStyle.weekDayFont)
                .foregroundColor(style.headerStyle.weekDayColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(style.headerStyle.weekDayBackground)
        }
    }
}
