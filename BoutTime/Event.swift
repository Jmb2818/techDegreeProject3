//
//  Event.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/1/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation
import UIKit

class Event {
    
    // MARK: Properties
    let eventDescription: String
    let date: Date
    let formatter = DateFormatter()
    let url: String
    
    // MARK: Initializer
    init(eventDescription: String, date: Date, url: String) {
        self.eventDescription = eventDescription
        self.date = date
        self.url = url
    }
    
    func eventDateString() -> String {
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self.date)
    }
    
    func attributeDescription() -> NSMutableAttributedString {
        // Return the event's description in an attributed style that matches design
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        paragraphStyle.headIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(string: self.eventDescription, attributes: attributes)
    }
    
    func attributedDescriptionWithDate() -> NSMutableAttributedString {
        // Return the event's description with a date in an attributed style that matches design
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        paragraphStyle.headIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        return NSMutableAttributedString(string: "\(self.eventDescription) - \(eventDateString())", attributes: attributes)
    }
}
