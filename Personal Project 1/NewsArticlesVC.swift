//
//   ViewController.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/7/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.

import UIKit
import SafariServices
import CoreData

class NewsArticlesVC: UIViewController,NewsArticleProtocol, UISearchControllerDelegate {
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var articlesIsSearched = false
    
    private var articles = [Article]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleNetworkingError()
        //TODO: Exclude financial times?
        endSearchBarEditingWhenTouch()
        NetworkManager.shared.fetchArticles(){[self] result in
            addArticlesWith(result: result)
        }
    }
    
    func addArticlesWith(result:Result<[Article], GetArticlesError>){
        switch result{
        case .success(let articlesFromResult):
            articles = articlesFromResult
            DispatchQueue.main.async { [self] in
                tableView.reloadData()
            }
        case .failure(_):
            handleNetworkingError()
        }
    }
    
    func endSearchBarEditingWhenTouch(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func addArticles(withParameters parameter:String){
        NetworkManager.shared.fetchArticles(){[self] result in
            switch result{
            case .success(let articlesFromResult):
                articles.append(contentsOf: articlesFromResult)
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            case .failure(_):
                handleNetworkingError()
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        if !articlesIsSearched{
            let position = scrollView.contentOffset.y
            if position + scrollView.frame.height > scrollView.contentSize.height - 100{
                tableView.tableFooterView?.isHidden = false
                if NetworkManager.shared.isFetching == false{
                    NetworkManager.shared.fetchArticles{ [self]  result in
                        DispatchQueue.main.async {
                            tableView.tableFooterView!.isHidden = true
                        }
                        switch result{
                        case .success(let moreArticles):
                            articles.append(contentsOf: moreArticles)
                            DispatchQueue.main.async {
                                tableView.reloadData()
                            }
                        case .failure(_):
                            handleNetworkingError()
                        }
                    }
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Identifier.webViewSegue {
            if let index = sender as? Int, let urlString = articles[index].url, let _ = URL(string: urlString){
                return true
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let webViewVC = segue.destination as? ArticleWebViewVC{
            popWebViewVC(on: tabBarController!)
            let index = sender as! Int
            let urlString = articles[index].url!
            let url = URL(string: urlString)!
            webViewVC.url = url
            ///Find if bookmarked
            let object = getArticles(from: container,with: urlString)
            if object.isEmpty{
                webViewVC.isBookmarked = false
            }else{
                webViewVC.isBookmarked = true
            }
            
            webViewVC.updateBookmark = {[self] in
                let article = getArticles(from: container,with: urlString)
                if !article.isEmpty{
                    context.delete(article.first!)
                }else{
                    articles[index].createCopy(on: container)
                }
                try? context.save()
            }
        }
    }
}

extension NewsArticlesVC:UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.newsArticleTableViewCell, for: indexPath) as! NewsArticleTableViewCell
        cell.configureCell(for: article)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
}

extension NewsArticlesVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldPerformSegue(withIdentifier: Identifier.webViewSegue, sender: indexPath.row){
            performSegue(withIdentifier: Identifier.webViewSegue, sender: indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsArticlesVC:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        articlesIsSearched = true
        if searchBar.text!.count == 0{
            articlesIsSearched = false
            NetworkManager.shared.fetchArticles{[self] result in
                self.addArticlesWith(result: result)
            }
        }else{
            let searchString = searchBar.text!.lowercased()
            let parameter = "&q=\(searchString)"
            articles = [Article]()
            tableView.reloadData()
            tableView.tableFooterView?.isHidden = false
            if NetworkManager.shared.isFetching == false{
                NetworkManager.shared.fetchArticles(withParameters: parameter){ [self]  result in
                    DispatchQueue.main.async {
                        tableView.tableFooterView?.isHidden = true
                    }
                    switch result{
                    case .success(let moreArticles):
                        articles = moreArticles
                        DispatchQueue.main.async {
                            tableView.reloadData()
                        }
                    case .failure(_):
                        handleNetworkingError()
                    }
                }
            }
            searchBar.endEditing(true)
        }
    }
}
