//
//  GameManager.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/2/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import Foundation
import GameKit
import AudioToolbox

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
    var roundChecked = false
    var gameCorrectSound: SystemSoundID = 0
    var gameIncorrectSound: SystemSoundID = 1
    
    // MARK: Initializers
    init() {
        do {
            let arrayOfDicts = try PlistConverter.array(fromFile: "Events", ofType: "plist")
            let arrayOfEvents = try EventArrayConverter.eventArray(fromArray: arrayOfDicts)
            eventPool = arrayOfEvents
        } catch PlistConversionError.invalidConversion {
            fatalError("Could not convert contents of Plist into [AnyObject]")
        } catch PlistConversionError.missingPlist {
            fatalError("Could not find plist of name 'Events' in file")
        } catch EventCoverterError.invalidConversion {
            fatalError("Unable to create events when converting from [AnyObject]")
        } catch(let error) {
            fatalError("\(error)")
        }
    }
    
    // MARK: Functions
    
    func loadGameSounds() {
        //Create sound for correctly ordered events
        let correctSoundPath = Bundle.main.path(forResource: "magicChime", ofType: "wav")
        let correctSoundUrl = URL(fileURLWithPath: correctSoundPath!)
        AudioServicesCreateSystemSoundID(correctSoundUrl as CFURL, &gameCorrectSound)
         //Create sound for incorrectly ordered events
        let incorrectSoundPath = Bundle.main.path(forResource: "metalTwing", ofType: "wav")
        let incorrectSoundUrl = URL(fileURLWithPath: incorrectSoundPath!)
        AudioServicesCreateSystemSoundID(incorrectSoundUrl as CFURL, &gameIncorrectSound)
    }
    
    func playCorrectAnswerSound() {
        AudioServicesPlaySystemSound(gameCorrectSound)
    }
    func playIncorrectAnswerSound() {
        AudioServicesPlaySystemSound(gameIncorrectSound)
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
        // Start a round of the game
        roundChecked = false
        eventPool.shuffle()
        firstEvent = getEvent()
        secondEvent = getEvent()
        thirdEvent = getEvent()
        fourthEvent = getEvent()
        chosenEvents.removeAll()
    }
    
    func getDateString(eventDescription: String) -> NSMutableAttributedString {
        // Get date to append to the end of the event description
        for event in eventPool {
            if event.eventDescription == eventDescription {
                return event.attributedDescriptionWithDate()
            }
        }
        return NSMutableAttributedString(string: "")
    }
    
    func startOver() {
        // Clear everything out to start game over
        roundsCorrect = 0
        roundsPlayed = 0
        roundEvents.removeAll()
        chosenEvents.removeAll()
    }
    
    func checkRound(userSortedEvents: [String]) -> Bool? {
        // Marking round checked to prevent extra shakes rechecking
            roundChecked = true
            
            // Increment the amount of rounds played this game
            roundsPlayed += 1
            guard let firstEvent = firstEvent,
                let secondEvent = secondEvent,
                let thirdEvent = thirdEvent,
                let fourthEvent = fourthEvent
                else {
                    print("Events do not exist")
                    return nil
            }
            // Add events to array and sort them by date oldest to newest
            roundEvents = [firstEvent, secondEvent, thirdEvent, fourthEvent]
            let sortedEvents = roundEvents.sorted { (event1, event2) -> Bool in
                return event1.date < event2.date
            }
            
            // Get the event descriptions of events in order and check them against the user
            // ordered events
            var sortedEventStrings: [String] = []
            for event in sortedEvents {
                sortedEventStrings.append(event.eventDescription)
            }
            
            return userSortedEvents == sortedEventStrings
    }
}
