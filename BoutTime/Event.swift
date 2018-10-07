//
//  Event.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/1/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    let eventDescription: String
    let date: Date
    
    init(eventDescription: String, date: Date) {
        self.eventDescription = eventDescription
        self.date = date
    }
    
    func attributeDescription() -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        paragraphStyle.headIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(string: self.eventDescription, attributes: attributes)
    }
}
