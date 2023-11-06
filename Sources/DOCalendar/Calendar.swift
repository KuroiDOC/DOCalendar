//
//  Calendar.swift
//  
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI

public struct CalendarView: View {
    var range: ClosedRange<Date>
    @Binding var selection: [Date]
    var calendar = Calendar.autoupdatingCurrent
    var numColumns: Int
    var style = CalendarStyle()
    var allowsRepetition: Bool

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private let items: [CalendarItem]

    public init(
        range: ClosedRange<Date>,
        selection: Binding<[Date]>,
        calendar: Calendar = Calendar.autoupdatingCurrent,
        numColumns: Int = 2,
        style: CalendarStyle = CalendarStyle(),
        allowsRepetition: Bool = false
    ) {
        self.range = range
        self._selection = selection
        self.calendar = calendar
        self.numColumns = numColumns
        self.style = style
        self.allowsRepetition = allowsRepetition
        
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
            if style.headerStyle.shouldDisplay, horizontalSizeClass == .compact {
                HStack(spacing: 0) {
                    WeekdayItems(calendar: calendar, style: style)
                        .padding(.vertical, 16)
                        .background(style.headerStyle.weekDayBackground)
                }
            }
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    if horizontalSizeClass == .compact {
                        VStack {
                            innerBody
                        }
                    } else {
                        // Because of a glitchy behaviour using a LazyVGrid, this multiple month layout is restricted for iOS 16
                        if #available(iOS 16, *) {
                            Grid {
                                let chunks = items.chunked(into: numColumns)
                                ForEach(0..<chunks.count, id: \.self) { index in
                                    let chunk = chunks[index]
                                    GridRow(alignment: .top) {
                                        ForEach(chunk) { item in
                                            let decomposedDate = item.decomposedDate
                                            MonthView(
                                                month: decomposedDate.month,
                                                year: decomposedDate.year,
                                                range: adjustRange(range),
                                                selections: $selection,
                                                calendar: calendar,
                                                style: style
                                            )
                                            .id(item.id)
                                        }
                                    }
                                }
                            }
                        } else {
                            VStack {
                                innerBody
                            }
                        }
                    }
                }
                .onAppear {
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 500 * NSEC_PER_MSEC)
                        if let nearestDate = self.selection.sorted(by: <).first {
                            let item = CalendarItem(decomposedDate: nearestDate.decomposed(calendar: calendar))
                            withAnimation {
                                scrollViewProxy.scrollTo(item.id, anchor: .top)
                            }
                        }
                    }

                }
            }
        }
    }

    private var innerBody: some View {
        ForEach(items) { item in
            MonthView(
                month: item.decomposedDate.month,
                year: item.decomposedDate.year,
                range: adjustRange(range),
                selections: $selection,
                calendar: calendar,
                style: style,
                allowsRepetition: allowsRepetition
            )
            .id(item.id)
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

private extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

#if DEBUG
struct PreviewContainer: View {
    @State var selection: [Date] = []
    var style = CalendarStyle()

    var body: some View {
        CalendarView(range: Date()...Date().plus(years: 1), selection: $selection, style: style)
    }
}

#Preview("Default") {
    PreviewContainer()
}

#Preview("Customized") {
    PreviewContainer(style: .init(headerStyle: .init(weekDayColor: .white, weekDayBackground: .gray)))
}

#Preview("No Header") {
    PreviewContainer(style: .init(headerStyle: .init(shouldDisplay: false)))
}

#endif
