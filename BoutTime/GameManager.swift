//
//  GameManager.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/2/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation

class GameManager {
    
    // MARK: Properties
    var events = EventPool()
    
    init() {
        do {
            let arrayOfDicts = try PlistConverter.array(fromFile: "Events", ofType: "plist")
            let arrayOfEvents = try EventArrayConverter.eventArray(fromArray: arrayOfDicts)
            events.eventsArray = arrayOfEvents
        } catch(let error) {
            fatalError("\(error)")
        }
    }
    
    
}
