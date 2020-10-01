//
//  ArticleWebViewVC.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/26/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit
import WebKit

class ArticleWebViewVC: UIViewController,WKNavigationDelegate {
    
    @IBOutlet var webView:WKWebView!
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    var url:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBarButtonItem.target = self
        webView.navigationDelegate = self
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        // Do any additional setup after loading the view.
    }

}
