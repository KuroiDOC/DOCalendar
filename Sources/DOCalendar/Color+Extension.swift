//
//  Color+Extension.swift
//  
//
//  Created by Daniel Otero on 23/5/23.
//

import SwiftUI

public extension Color {
    #if os(macOS)
    static let label = Color(NSColor.labelColor)
    static let background = Color(NSColor.windowBackgroundColor)
    static let secondaryBackground = Color(NSColor.underPageBackgroundColor)
    static let tertiaryBackground = Color(NSColor.controlBackgroundColor)
    #else
    static let label = Color(UIColor.label)
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let tertiaryBackground = Color(UIColor.tertiarySystemBackground)
    #endif
}
