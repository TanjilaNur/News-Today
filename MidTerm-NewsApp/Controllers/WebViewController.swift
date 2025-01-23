//
//  WebViewController.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 17/1/23.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: url)!))
    }

}

