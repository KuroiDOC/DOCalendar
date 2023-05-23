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

    public init(itemStyle: ItemStyle = ItemStyle(), selectionStyle: SelectionSyle = SelectionSyle(), headerStyle: HeaderStyle = HeaderStyle()) {
        self.itemStyle = itemStyle
        self.selectionStyle = selectionStyle
        self.headerStyle = headerStyle
    }
}

public struct ItemStyle {
    var background: Color = .background
    var textColor: Color = .label
    var itemBackground: Color = .background
    var font: Font = .body

    public init(background: Color = .background, textColor: Color = .label, itemBackground: Color = .background, font: Font = .body) {
        self.background = background
        self.textColor = textColor
        self.itemBackground = itemBackground
        self.font = font
    }
}

public struct SelectionSyle {
    var background: Color = .accentColor
    var textColor: Color = .white
    var rangeBackground: Color = .accentColor.opacity(0.25)
    var selectionOption: SelectionOption = .single

    public init(background: Color = .accentColor, textColor: Color = .white, rangeBackground: Color = .accentColor.opacity(0.25), selectionOption: SelectionOption = .single) {
        self.background = background
        self.textColor = textColor
        self.rangeBackground = rangeBackground
        self.selectionOption = selectionOption
    }
}

public struct HeaderStyle {
    var weekDayFont: Font = .subheadline
    var weekDayColor: Color = .label
    var weekDayBackground: Color = .background
    var monthFont: Font = .headline
    var monthColor: Color = .label
    var monthBackground: Color = .background

    public init(weekDayFont: Font = .subheadline, weekDayColor: Color = .label, weekDayBackground: Color = .background, monthFont: Font = .headline, monthColor: Color = .label, monthBackground: Color = .background) {
        self.weekDayFont = weekDayFont
        self.weekDayColor = weekDayColor
        self.weekDayBackground = weekDayBackground
        self.monthFont = monthFont
        self.monthColor = monthColor
        self.monthBackground = monthBackground
    }
}

public enum SelectionOption {
    case single
    /// A pair of values
    case range
    /// Multiple days selection
    case multi
}
