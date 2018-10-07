//
//  GameViewController.swift
//  BoutTime
//
//  Created by Joshua Borck on 9/26/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       beginRound()
    }
    
    @IBAction func eventSwap(sender: UIButton) {
        switch sender.restorationIdentifier {
        case "firstDownButton":
            switchEvents(firstLabel: firstLabel, secondLabel: secondLabel)
        case "secondDownButton":
            switchEvents(firstLabel: secondLabel, secondLabel: thirdLabel)
        case "thirdDownButton":
            switchEvents(firstLabel: thirdLabel, secondLabel: fourthLabel)
        case "firstUpBUtton":
            switchEvents(firstLabel: secondLabel, secondLabel: firstLabel)
        case "secondUpBUtton":
            switchEvents(firstLabel: thirdLabel, secondLabel: secondLabel)
        case "thirdUpBUtton":
            switchEvents(firstLabel: fourthLabel, secondLabel: thirdLabel)
        default: break
            
        }
    }
    
    func switchEvents(firstLabel: UILabel, secondLabel: UILabel) {
            let holder = firstLabel.attributedText
            firstLabel.attributedText = secondLabel.attributedText
            secondLabel.attributedText = holder
    }
    
    
    func beginRound() {
        gameManager.startRound()
        guard let firstEventDescription = gameManager.firstEvent?.attributeDescription(),
            let secondEventDescription = gameManager.secondEvent?.attributeDescription(),
            let thirdEventDescription = gameManager.thirdEvent?.attributeDescription(),
            let fourthEventDescription = gameManager.fourthEvent?.attributeDescription() else {
                // TODO: throw an error
                print("Events do not exist")
                return
        }
        
        firstLabel.attributedText = firstEventDescription
        secondLabel.attributedText = secondEventDescription
        thirdLabel.attributedText = thirdEventDescription
        fourthLabel.attributedText = fourthEventDescription
    }
    
    func getEventOrder() -> [String] {
        var orderedEventStrings: [String] = []
        guard let firstDescription = firstLabel.attributedText?.string,
            let secondDescription = secondLabel.attributedText?.string,
            let thirdDescription = thirdLabel.attributedText?.string,
            let fourthDescription = fourthLabel.attributedText?.string else {
                // TODO: Throw error
                
                return []
        }
        orderedEventStrings = [firstDescription, secondDescription, thirdDescription, fourthDescription]
        return orderedEventStrings
    }
    
    func checkAnswers() {
        let userSortedEvents = getEventOrder()
        let isCorrect = gameManager.checkRound(userSortedEvents: userSortedEvents)
        
        if isCorrect {
            
        }
    }

}
