//
//  Helpers.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Nov/24/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire

protocol NewsArticleProtocol{}

extension NewsArticleProtocol where Self:UIViewController{
  
    func getArticles(from container:NSPersistentContainer,with urlString:String? = nil) -> [Article]{
        let request : NSFetchRequest<Article> = Article.fetchRequest()
        if let _ = urlString {
            let predicate = NSPredicate(format: "url = %@", urlString!)
            request.predicate = predicate
        }
        return (try? container.viewContext.fetch(request)) ?? []
    }
    
    func popWebViewVC(on tabBarVC:UITabBarController){
        for vc in tabBarVC.viewControllers! {
            let navigationVC = vc as! UINavigationController
            if navigationVC.topViewController is ArticleWebViewVC{
                navigationVC.popViewController(animated: true)
            }
        }
    }
    
    func handleNetworkingError(){
        let action = UIAlertController(title: "Network Error", message: "Please Ensure you are connected to the internet", preferredStyle: .alert)
        action.addAction(.init(title: "Dismiss", style: .cancel){ _ in
            action.dismiss(animated: true, completion: nil)
        })
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.startListening{ status in
            switch status{
            case .notReachable:
                self.present(action, animated: true, completion: nil)
            default:
            break
            }
        }

    }
    
}

enum Identifier{
    static let newsArticleTableViewCell = "newsArticleTableViewReusableCell"
    static let headerDequeue  = "headerDequeueReusableCell"
    static let webViewSegue   = "ArticleWebViewVCSegue"
    static let settingsToDarkModeChoicesSegue = "SettingsToDarkModeChoices"
    static let looadingSupplementaryCell = "loadingFooterSupplementary"
    static let rightDetailCell = "RightDetailCell"
    static let basicCell = "BasicCell"
    static let nightModeChoiceCell = "nightModeChoicesReuseIdentifier"
}

enum BaseURL{
    
}

private let newsVCArticleWebViewSegueIdentifier = "ArticleWebViewVCSegue"
private let newsArticleReusableString = "newsArticleReusableCell"
private let headerDequeueIdentifier   = "headerDequeueReusableCell"
private let webViewSegueIdentifier    = "ArticleWebViewVCSegue"
