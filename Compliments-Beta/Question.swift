//
//  Question.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 7/4/20.
//

import Foundation

struct Question {
    var title: String
    var answers: [Answer]
}

struct Answer: Identifiable, Equatable {
    let id: String = UUID().uuidString
    var title: String
}
