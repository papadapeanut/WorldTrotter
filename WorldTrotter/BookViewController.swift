//
//  BookViewController.swift
//  WorldTrotter
//
//  Created by Jason Moore on 6/4/17.
//  Copyright © 2017 Jason Moore. All rights reserved.
//

import UIKit
import WebKit

class BookViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myURLRequest:URLRequest = URLRequest(url: myURL!)
        webView.loadRequest(myURLRequest)
    }
}
