//
//  GameViewController.swift
//  BoutTime
//
//  Created by Joshua Borck on 9/26/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: IBOutlets - Labels
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var roundSuccessButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var firstStackView: UIStackView!
    // MARK: IBOutlets - Buttons
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var sixthButton: UIButton!
    
    // MARK: Properties
    var gameManager = GameManager()
    var countdownSeconds = 60
    var roundTimer = Timer()
    var countdownTimer = Timer()
    var selectedURL = ""
    var labelArray: [UILabel] = []
    var buttonArray: [UIButton] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get arrays of all interactable UI elements to set up the game
        labelArray = [firstLabel, secondLabel, thirdLabel, fourthLabel]
        buttonArray = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton]
        setupGame()
        startRound()
    }
    
    // Set up the motion detection
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEvent.EventSubtype.motionShake {
            checkAnswers()
        }
    }
    
    @IBAction func eventSwap(sender: UIButton) {
        // Swap events based on what button is pressed
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
    func roundOuterCorners(for label: UILabel) {
        // Round corners of labels on the correct corners to match mock
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
    func roundOuterCorners(for button: UIButton) {
        // Round corners of buttons on the correct corners to match mock
        for button in buttonArray {
            switch button.restorationIdentifier {
            case "firstDownButton", "thirdUpBUtton":
                button.layer.cornerRadius = 5
                button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case "secondDownButton", "thirdDownButton":
                button.layer.cornerRadius = 5
                button.layer.maskedCorners = [.layerMaxXMinYCorner]
            case "firstUpBUtton", "secondUpBUtton":
                button.layer.cornerRadius = 5
                button.layer.maskedCorners = [.layerMaxXMaxYCorner]
            default: break
            }
        }
    }
    
    func setupGame() {
        // Setup all the UI for the game like buttons and labels
        for label in labelArray {
            roundOuterCorners(for: label)
            createTapRecognizer(label: label)
        }
        
        for button in buttonArray {
            roundOuterCorners(for: button)
        }
    }
    
    func switchEvents(firstLabel: UILabel, secondLabel: UILabel) {
        // Hold on to what is in the labels
            let holder = firstLabel.attributedText
            let holder2 = secondLabel.attributedText
        // Blank them out to start the beginning animation making it seem like they both
        // are disappearing and re-appearing in each others spots
            firstLabel.attributedText = NSMutableAttributedString(string: "")
            secondLabel.attributedText = NSMutableAttributedString(string: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            secondLabel.attributedText = holder
            firstLabel.attributedText = holder2
        }
    }
    
    func enableButtons(_ bool: Bool) {
        // Enable or disable buttons to move events
        firstButton.isEnabled = bool
        secondButton.isEnabled = bool
        thirdButton.isEnabled = bool
        fourthButton.isEnabled = bool
        fifthButton.isEnabled = bool
        sixthButton.isEnabled = bool
    }
    
    
    @IBAction func startNextRound(_ sender: UIButton) {
        if gameManager.roundsPlayed == gameManager.roundsPerGame {
            // If six rounds have been completed then show the score screen
            performSegue(withIdentifier: "showScore", sender: nil)
        } else {
            // Start new round
            startRound()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScore" {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = gameManager.roundsCorrect
                destinationVC.mainViewController = self
            }
        }
        
        if segue.identifier == "showWeb" {
            if let destinationVC = segue.destination as? WebViewController {
                destinationVC.url = selectedURL
            }
        }
    }
    
    func runTimer() {
        // Create timer for the round where if no choice is made before the time is up then score the round
        roundTimer = Timer.scheduledTimer(timeInterval: Double(gameManager.secondsPerRound), target: self, selector: #selector(checkAnswers), userInfo: nil, repeats: true)
        // Create a timer to update the countdown timer label
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayCountdown), userInfo: nil, repeats: true)
    }
    
    func setUpRound() {
        // Setup the round by hiding specific UI and resetting labels
        gameManager.startRound()
        gameManager.loadGameSounds()
        timerLabel.isHidden = false
        timerLabel.text = "1:00"
        countdownSeconds = gameManager.secondsPerRound
        roundSuccessButton.isEnabled = false
        roundSuccessButton.isHidden = true
        hintLabel.text = "Shake to complete"
        enableButtons(true)
    }
    
    func endRound() {
        // Switch the hint label so the user knows they can learn more from the events
        hintLabel.text = "Tap events to learn more"
        
        // End round by ending timers and hiding specific UI
        roundTimer.invalidate()
        countdownTimer.invalidate()
        timerLabel.isHidden = true
        roundSuccessButton.isEnabled = true
        enableButtons(false)
    }
    
    func startRound() {
        setUpRound()
        // Get the event descriptions to populate the labels
        guard let firstEvent = gameManager.firstEvent,
            let secondEvent = gameManager.secondEvent,
            let thirdEvent = gameManager.thirdEvent,
            let fourthEvent = gameManager.fourthEvent else {
                print("Events do not exist")
                return
        }
        
        firstLabel.attributedText = firstEvent.attributeDescription()
        secondLabel.attributedText = secondEvent.attributeDescription()
        thirdLabel.attributedText = thirdEvent.attributeDescription()
        fourthLabel.attributedText = fourthEvent.attributeDescription()
        runTimer()
    }
    
    func getEventOrder() -> [String] {
        // Get the order of events as the user has moved them in the UI
        var orderedEventStrings: [String] = []
        guard let firstDescription = firstLabel.attributedText?.string,
            let secondDescription = secondLabel.attributedText?.string,
            let thirdDescription = thirdLabel.attributedText?.string,
            let fourthDescription = fourthLabel.attributedText?.string else {
                print("Could not retrieve events and descriptions")
                
                return []
        }
        orderedEventStrings = [firstDescription, secondDescription, thirdDescription, fourthDescription]
        return orderedEventStrings
    }
    
    func createTapRecognizer(label: UILabel) {
        // Add a tap recognizer to get the event selected by user at the end of the round
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(selectedLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapAction)
    }
    
    @objc func selectedLabel(_ sender: AnyObject) {
        // Get event selected and return the appropriate webView for that event for more information
        guard let gestureRecognizer = sender as? UITapGestureRecognizer,
            let label = gestureRecognizer.view as? UILabel,
            let selectedEvent = label.attributedText?.string
            else {
                print("No event found for webview")
                return
        }
        
        for event in gameManager.eventPool {
            if event.attributedDescriptionWithDate().string == selectedEvent {
                selectedURL = event.url
                performSegue(withIdentifier: "showWeb", sender: nil)
            }
        }
    }
    
    @objc func checkAnswers() {
        
        // Check the order of events the user has chosen against the correct order
        let userSortedEvents = getEventOrder()
        
        // Do needed round teardown
        endRound()
        appendDatesOfEvents()
        
        // Get if the user is correct or not and then display approrpate results
        guard let isCorrect = gameManager.checkRound(userSortedEvents: userSortedEvents) else {
            print("Could not check answer")
            return
        }
        
        if isCorrect {
            gameManager.playCorrectAnswerSound()
            roundSuccessButton.setBackgroundImage(UIImage(named: "next_round_success"), for: .normal)
            gameManager.roundsCorrect += 1
            roundSuccessButton.isHidden = false
        } else {
            gameManager.playIncorrectAnswerSound()
            roundSuccessButton.setBackgroundImage(UIImage(named: "next_round_fail"), for: .normal)
            roundSuccessButton.isHidden = false
        }
    }
    
    func appendDatesOfEvents() {
        // Append the date to the end of the event descriptions so user knows what they got wrong
        guard let firstDescription = firstLabel.attributedText?.string,
            let secondDescription = secondLabel.attributedText?.string,
            let thirdDescription = thirdLabel.attributedText?.string,
            let fourthDescription = fourthLabel.attributedText?.string else {
                print("Error retrieving events and descriptions")
                return
        }
        
        firstLabel.attributedText = gameManager.getDateString(eventDescription: firstDescription)
        secondLabel.attributedText = gameManager.getDateString(eventDescription: secondDescription)
        thirdLabel.attributedText = gameManager.getDateString(eventDescription: thirdDescription)
        fourthLabel.attributedText = gameManager.getDateString(eventDescription: fourthDescription)
    }
    
    @objc func displayCountdown() {
        // Update countdown label every second to update user of time left
        // Checking if countdown is at 10 and if so make sure it shows the right formatting
        if countdownSeconds > 10 {
            countdownSeconds -= 1
            timerLabel.text = "0:\(countdownSeconds)"
        } else {
            countdownSeconds -= 1
            timerLabel.text = "0:0\(countdownSeconds)"
        }
    }

}
