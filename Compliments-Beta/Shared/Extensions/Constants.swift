//
//  Constants.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/21/22.
//

import Foundation
import SwiftUI

enum Constants {
    
    // MARK: - Padding
    
    enum Padding: CGFloat {
        case none = 0
        /// 2.0
        case tiny = 2
        /// 4.0
        case minimal = 4
        /// 8.0
        case small = 8
        /// 12.0
        case medium = 12
        /// 16.0
        case large = 16
        /// 20.0
        case extraLarge = 20
        /// 24.0
        case doubleMedium = 24
        /// 32.0
        case doubleLarge = 32
        /// 40.0
        case doubleExtraLarge = 40
        /// 64.0
        case huge = 64
        /// 10.0 (Used specifically to add padding to buttons with hover effect)
        case hover = 10
        /// -4
        case negativeMinimal = -4
        /// -8
        case negativeSmall = -8
        /// -12
        case negativeDefault = -12
        /// -16
        case negativeLarge = -16
    }
    
    
    // MARK: - Spacing
    
    /// 0.0
    static let noSpacing: CGFloat = 0
    /// 2.0
    static let tinySpacing: CGFloat = 2
    /// 4.0
    static let minimalSpacing: CGFloat = 4
    /// 8.0
    static let defaultSpacing: CGFloat = 8
    /// 12.0
    static let mediumSpacing: CGFloat = 12
    /// 16.0
    static let doubleSpacing: CGFloat = 16
    /// 24.0
    static let tripleSpacing: CGFloat = 24
    /// 32.0
    static let quadrupleSpacing: CGFloat = 32
    
    
    // MARK: - Corner radius
    
    /// 4.0
    static let minimalCornerRadius: CGFloat = 4.0
    /// 8.0
    static let defaultCornerRadius: CGFloat = 8.0
    /// 16.0
    static let doubleCornerRadius: CGFloat = 16.0
    
}
