//
//  Localized.swift
//  Compliments-Beta
//
//  Created by Derik Flanary on 4/21/22.
//

import Foundation

enum Localized {

    static let disclaimer = NSLocalizedString("This recognition may be made viewable for company personnel and the public. By filling out this information and submitting it you are authorizing us to share it as described.", comment: "Disclaimer for user to know that the text the enter could be viewed by the public or employees of the company.")
    static let responsePlaceholder = NSLocalizedString("Please leave your response here", comment: "Placeholder text for the user to write their response")
    static let recognizeExplanation = NSLocalizedString("Please help us recognize the one who provided you with exceptional care during your stay.", comment: "Explains what we want the user to type into a text box.")
    static let selectRating = NSLocalizedString("Select a rating for this employee based on the service you received", comment: "Title asking user to select a rating like 1-5 with 5 being the best for how well they were served at a business establishment.")
    static let submit = NSLocalizedString("Submit", comment: "Button title to submit response")
    static let tellUsWhy = NSLocalizedString("Briefly tell us why", comment: "Leave a message about why you gave the rating you received.")
}
