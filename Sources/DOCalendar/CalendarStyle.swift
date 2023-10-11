//
//  Theme.swift
//  
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI

public struct CalendarStyle {
    var itemStyle = ItemStyle()
    var selectionStyle = SelectionSyle()
    var headerStyle = HeaderStyle()
    var rowSpacing: CGFloat

    public init(itemStyle: ItemStyle = ItemStyle(), selectionStyle: SelectionSyle = SelectionSyle(), headerStyle: HeaderStyle = HeaderStyle(), rowSpacing: CGFloat = 0) {
        self.itemStyle = itemStyle
        self.selectionStyle = selectionStyle
        self.headerStyle = headerStyle
        self.rowSpacing = rowSpacing
    }
}

public struct ItemStyle {
    var background: Color
    var itemBackground: Color
    var textColor: Color
    var font: Font
    var todayTextColor: Color
    var todayFont: Font
    var todayBackground: any View
    var unavailableTextColor: Color
    var unavailableFont: Font

    public init(
        background: Color = .background,
        itemBackground: Color = .background,
        textColor: Color = .label,
        font: Font = .body,
        todayTextColor: Color = .accentColor,
        todayFont: Font = .body.bold(),
        todayBackground: any View = Color.background,
        unavailableTextColor: Color = .secondaryLabel,
        unavailableFont: Font = .body
    ) {
        self.background = background
        self.itemBackground = itemBackground
        self.textColor = textColor
        self.font = font
        self.todayTextColor = todayTextColor
        self.todayFont = todayFont
        self.todayBackground = todayBackground
        self.unavailableTextColor = unavailableTextColor
        self.unavailableFont = unavailableFont
    }
}

public struct SelectionSyle {
    var background: Color
    var textColor: Color
    var font: Font
    var rangeBackground: Color
    var selectionOption: SelectionOption

    public init(background: Color = .accentColor, textColor: Color = .white, font: Font = .body, rangeBackground: Color = .accentColor.opacity(0.25), selectionOption: SelectionOption = .single) {
        self.background = background
        self.textColor = textColor
        self.font = font
        self.rangeBackground = rangeBackground
        self.selectionOption = selectionOption
    }
}

public struct HeaderStyle {
    var shouldDisplay: Bool
    var weekDayFont: Font
    var weekDayColor: Color
    var weekDayBackground: Color
    var monthFont: Font
    var monthColor: Color
    var monthBackground: Color
    var monthCase: Text.Case?

    public init(shouldDisplay: Bool = true, weekDayFont: Font = .subheadline, weekDayColor: Color = .label, weekDayBackground: Color = .background, monthFont: Font = .headline, monthColor: Color = .label, monthBackground: Color = .background, monthCase: Text.Case? = .none) {
        self.shouldDisplay = shouldDisplay
        self.weekDayFont = weekDayFont
        self.weekDayColor = weekDayColor
        self.weekDayBackground = weekDayBackground
        self.monthFont = monthFont
        self.monthColor = monthColor
        self.monthBackground = monthBackground
        self.monthCase = monthCase
    }
}

public enum SelectionOption {
    case single
    /// A pair of values
    case range
    /// Multiple days selection
    case multi
}
