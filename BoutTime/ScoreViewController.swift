//
//  ScoreViewController.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/7/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Properties
    var score = 0
    var mainViewController: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display the score
        scoreLabel.text = "\(score)/6"

    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Return to GameViewController and start game over
        guard let mainVC = mainViewController else {
            dismiss(animated: true, completion: nil)
            return
        }
        mainVC.gameManager.startOver()
        mainVC.startRound()
        dismiss(animated: true, completion: nil)
    }
    
    
}
