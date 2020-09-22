//
//  AnyTransition+Extensions.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 9/22/20.
//

import SwiftUI

extension AnyTransition {

    static func scaleInFadeOut() -> AnyTransition {
        let insertion = AnyTransition.scale
        let removal = AnyTransition.opacity
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
}
