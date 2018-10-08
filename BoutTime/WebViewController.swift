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
    
    var url = ""
    
    @IBOutlet weak var wkWebView: WKWebView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let myUrl = URL(string: url) else {
            return
        }
        
        let myRequest = URLRequest(url: myUrl)
        wkWebView.load(myRequest)
    }

    @IBAction func dismissWebView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
