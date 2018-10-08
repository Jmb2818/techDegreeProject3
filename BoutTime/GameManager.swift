//
//  GameManager.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/2/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation
import GameKit

class GameManager {
    
    // MARK: Properties
    var eventPool: [Event] = []
    var chosenEvents: [Int] = []
    var firstEvent: Event?
    var secondEvent: Event?
    var thirdEvent: Event?
    var fourthEvent: Event?
    var roundEvents: [Event] = []
    let eventsPerRound = 4
    let formatter = DateFormatter()
    let secondsPerRound = 60
    let roundsPerGame = 6
    var roundsPlayed = 0
    var roundsCorrect = 0
    
    
    init() {
        do {
            let arrayOfDicts = try PlistConverter.array(fromFile: "Events", ofType: "plist")
            let arrayOfEvents = try EventArrayConverter.eventArray(fromArray: arrayOfDicts)
            eventPool = arrayOfEvents
        } catch(let error) {
            fatalError("\(error)")
        }
    }
    
    func getEvent() -> Event {
        // check to see if this questions index is in the selected question index array
        // If so then pick another question, if not then add that index to the array and pass
        // the question to the caller
        var foundNewEvent = false
        while foundNewEvent == false {
            let selectedEventIndex = GKRandomSource.sharedRandom().nextInt(upperBound: eventPool.count)
            if !chosenEvents.contains(selectedEventIndex) {
                let event = eventPool[selectedEventIndex]
                chosenEvents.append(selectedEventIndex)
                foundNewEvent = true
                return event
            }
        }
    }
    
    func startRound() {
        eventPool.shuffle()
        firstEvent = getEvent()
        secondEvent = getEvent()
        thirdEvent = getEvent()
        fourthEvent = getEvent()
        chosenEvents.removeAll()
    }
    
    func getDateString(eventDescription: String) -> String {
        formatter.dateFormat = "yyyy"
        for event in eventPool {
            if event.eventDescription == eventDescription {
                return formatter.string(from: event.date)
            }
        }
        return ""
    }
    
    func startOver() {
        roundsCorrect = 0
        roundsPlayed = 0
        roundEvents.removeAll()
        chosenEvents.removeAll()
    }
    
    func checkRound(userSortedEvents: [String]) -> Bool {
        roundsPlayed += 1
        guard let firstEvent = firstEvent,
            let secondEvent = secondEvent,
            let thirdEvent = thirdEvent,
            let fourthEvent = fourthEvent else { return false }
        roundEvents = [firstEvent, secondEvent, thirdEvent, fourthEvent]
        let sortedEvents = roundEvents.sorted { (event1, event2) -> Bool in
            return event1.date < event2.date
        }
        var sortedEventStrings: [String] = []
        for event in sortedEvents {
            sortedEventStrings.append(event.eventDescription)
        }
        
        return userSortedEvents == sortedEventStrings
    }
}
