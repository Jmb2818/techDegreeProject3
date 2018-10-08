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
    @IBOutlet weak var roundSuccessButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var gameManager = GameManager()
    var countdownSeconds = 60
    var roundTimer = Timer()
    var countdownTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       beginRound()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            checkAnswers()
        }
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
    
    @IBAction func beginNextRound(_ sender: UIButton) {
        if gameManager.roundsPlayed == gameManager.roundsPerGame {
            performSegue(withIdentifier: "showScore", sender: nil)
        } else {
            beginRound()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScore" {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = gameManager.roundsCorrect
                destinationVC.mainViewController = self
            }
        }
    }
    
    func runTimer() {
        // Create timer for the round where if no choice is made before the time is up still display question
        roundTimer = Timer.scheduledTimer(timeInterval: Double(gameManager.secondsPerRound), target: self, selector: #selector(checkAnswers), userInfo: nil, repeats: true)
        // Create a timer to update the countdown timer
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCountdown), userInfo: nil, repeats: true)
    }
    
    func beginRound() {
        gameManager.startRound()
        timerLabel.isHidden = false
        timerLabel.text = "1:00"
        countdownSeconds = gameManager.secondsPerRound
        roundSuccessButton.isEnabled = false
        roundSuccessButton.isHidden = true
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
        runTimer()
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
    
    @objc func checkAnswers() {
        roundTimer.invalidate()
        countdownTimer.invalidate()
        let userSortedEvents = getEventOrder()
        timerLabel.isHidden = true
        roundSuccessButton.isEnabled = true
        let isCorrect = gameManager.checkRound(userSortedEvents: userSortedEvents)
        guard let firstDescription = firstLabel.attributedText?.string,
            let secondDescription = secondLabel.attributedText?.string,
            let thirdDescription = thirdLabel.attributedText?.string,
            let fourthDescription = fourthLabel.attributedText?.string else {
                // TODO: Throw error
                
                return
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        paragraphStyle.headIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        firstLabel.attributedText = NSMutableAttributedString(string: "\(firstDescription) - \(gameManager.getDateString(eventDescription: firstDescription))", attributes: attributes)
        
        secondLabel.attributedText = NSMutableAttributedString(string: "\(secondDescription) - \(gameManager.getDateString(eventDescription: secondDescription))", attributes: attributes)
        
        thirdLabel.attributedText = NSMutableAttributedString(string: "\(thirdDescription) - \(gameManager.getDateString(eventDescription: thirdDescription))", attributes: attributes)
        
        fourthLabel.attributedText = NSMutableAttributedString(string: "\(fourthDescription) - \(gameManager.getDateString(eventDescription: fourthDescription))", attributes: attributes)
        
        if isCorrect {
            roundSuccessButton.setBackgroundImage(UIImage(named: "next_round_success"), for: .normal)
            gameManager.roundsCorrect += 1
            roundSuccessButton.isHidden = false
        } else {
            roundSuccessButton.setBackgroundImage(UIImage(named: "next_round_fail"), for: .normal)
            roundSuccessButton.isHidden = false
        }
    }
    
    @objc func displayCountdown() {
        // Update countdown label every second to update user of time left
        if countdownSeconds >= 10 {
            countdownSeconds -= 1
            timerLabel.text = "0:\(countdownSeconds)"
        } else {
            countdownSeconds -= 1
            timerLabel.text = "0:0\(countdownSeconds)"
        }
    }

}
