//
//  ScoreViewController.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/7/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    var score = 0
    var mainViewController: GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "\(score)/6"

    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        guard let mainVC = mainViewController else {
            dismiss(animated: true, completion: nil)
            return
        }
        mainVC.gameManager.startOver()
        mainVC.beginRound()
        dismiss(animated: true, completion: nil)
    }
    
    
}
