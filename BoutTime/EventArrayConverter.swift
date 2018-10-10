//
//  EventArrayConverter.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/3/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class EventArrayConverter {
    
    static func eventArray(fromArray array: [AnyObject]) throws -> [Event] {
        var eventPool: [Event] = []
        
        for event in array {
            guard let eventDescription = event["description"] as? String,
                let eventDate = event["date"] as? Date,
                let url = event["url"] as? String else {
                throw EventCoverterError.invalidConversion
            }
            eventPool.append(Event(eventDescription: eventDescription, date: eventDate, url: url))
        }
        return eventPool
    }
}
