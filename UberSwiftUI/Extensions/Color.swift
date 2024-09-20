//
//  Color.swift
//  UberSwiftUITutorial
//
//  Created by Aman on 21/07/23.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}


struct ColorTheme {
    let backgroundColor = Color("BackgroundColor")
    let secondarybackgroundColor = Color("SecondaryBackgroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
}
