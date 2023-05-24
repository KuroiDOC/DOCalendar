//
//  ContentView.swift
//  DOCalendarExample
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI
import DOCalendar

struct ContentView: View {
    @State var selection: Set<Date> = .init()
    @State var isShowingCalendar = false

    var body: some View {
        VStack {
            if !selection.isEmpty {
                ForEach(selection.sorted(by: <), id: \.self) { date in
                    Text(date,style: .date)
                }
            }
            Button {
                isShowingCalendar.toggle()
            } label: {
                Text("Show calendar")
            }
        }
        .sheet(isPresented: $isShowingCalendar) {
            CalendarView(
                range: Date()...Date().addingTimeInterval(24 * 30 * 12 * 3600),
                selection: $selection,
                style: CalendarStyle(selectionStyle: .init(selectionOption: .range))
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
