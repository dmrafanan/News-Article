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
        
    var isBookmarked:Bool!{
        didSet{
            if leftBarButtonItem != nil{
                if isBookmarked{
                    leftBarButtonItem.image = UIImage(systemName: "bookmark.fill")
                }else{
                    leftBarButtonItem.image = UIImage(systemName: "bookmark")
                }
            }
        }
    }
    
    var updateBookmark: (()->Void)!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.navigationDelegate = self
        
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
        leftBarButtonItem.target = self
        leftBarButtonItem.action = #selector(bookmarkArticle)
    }

    @objc func bookmarkArticle(){
        isBookmarked = !isBookmarked
        updateBookmark()
    }
}
