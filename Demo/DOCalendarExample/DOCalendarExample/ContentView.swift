//
//  ContentView.swift
//  DOCalendarExample
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI
import DOCalendar

struct ContentView: View {
    @State var selection: Array<Date> = .init()
    @State var isShowingCalendar = false
    @State var calendarStyle = CalendarStyle()
    @State var allowsRepetition = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Allow repeated dates")
                Toggle("", isOn: $allowsRepetition)
                    .labelsHidden()
                Spacer()
            }

            Button {
                calendarStyle = CalendarStyle(selectionStyle: .init(selectionOption: .range))
                isShowingCalendar.toggle()
            } label: {
                Text("Show range selection calendar")
            }
            .padding(.top, 8)

            Button {
                calendarStyle = CalendarStyle(selectionStyle: .init(selectionOption: .multi))
                isShowingCalendar.toggle()
            } label: {
                Text("Show multiple selection calendar")
            }
            .padding(.top, 8)

            if !selection.isEmpty {
                Text("Selected dates:")
                    .padding(.top, 8)
                ForEach(Array(selection.sorted(by: <).enumerated()), id: \.self.offset) { date in
                    Text(date.element, style: .date)
                }
            }

        }
        .sheet(isPresented: $isShowingCalendar) {
            CalendarView(
                range: Date()...Calendar.autoupdatingCurrent.date(byAdding: .year, value: 2, to: Date())!,
                selection: $selection,
                numColumns: 3,
                style: calendarStyle,
                allowsRepetition: allowsRepetition
            )
            .padding(.top, 16)
            .overlay(
                VStack {
                    Spacer()
                    Button {
                        isShowingCalendar.toggle()
                    } label: {
                        Text("DONE")
                    }
                    .buttonStyle(.bordered)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
