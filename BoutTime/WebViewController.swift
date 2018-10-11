//
//  WebViewController.swift
//  BoutTime
//
//  Created by Joshua Borck on 10/7/18.
//  Copyright © 2018 Joshua Borck. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: Properties
    var url = ""
    
    // MARK: IBOutlers
    @IBOutlet weak var wkWebView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get url from url passed in from GameViewController
        guard let myUrl = URL(string: url) else {
            return
        }
        
        // Setup URL request
        let myRequest = URLRequest(url: myUrl)
        
        // Load webview of selected event
        wkWebView.load(myRequest)
    }

    @IBAction func dismissWebView(_ sender: UIButton) {
        // Dismiss view when the button is hit
        dismiss(animated: true, completion: nil)
    }
}
