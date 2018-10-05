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
        
        firstLabel.attributedText = attributedString(from: gameManager.events.eventsArray[0].eventDescription)
        secondLabel.attributedText = attributedString(from: gameManager.events.eventsArray[1].eventDescription)
        thirdLabel.attributedText = attributedString(from: gameManager.events.eventsArray[2].eventDescription)
        fourthLabel.attributedText = attributedString(from: gameManager.events.eventsArray[3].eventDescription)
    }
    
    
    func attributedString(from string: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 20
        paragraphStyle.headIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        return NSMutableAttributedString(string: string, attributes: attributes)
    }

}
