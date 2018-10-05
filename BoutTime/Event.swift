//
//  Event.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/1/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

struct Event {
    let eventDescription: String
    let date: Date
    
    init(eventDescription: String, date: Date) {
        self.eventDescription = eventDescription
        self.date = date
    }
}
