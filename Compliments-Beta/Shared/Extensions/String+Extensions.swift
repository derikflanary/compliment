//
//  String+Extensions.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 5/12/21.
//

import Foundation

extension String {
    
    /// Returns true if there is no text or just empty spaces and lines in the text
    var isBlank: Bool {
        isEmpty || trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

}
