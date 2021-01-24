//
//  BookmarkedArticlesVC.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Oct/1/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit
import CoreData

class BookmarkedArticlesVC: UIViewController, UITableViewDataSource, UITableViewDelegate,NewsArticleProtocol {
    
    var articles = [Article]()
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let SQLStore = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.persistentStores.first{
        $0.type == NSSQLiteStoreType
    }!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticlesFromPersistentStore()
        tableView.reloadData()
    }
    
    func fetchArticlesFromPersistentStore() {
        let request:NSFetchRequest<Article> = Article.fetchRequest()
        articles = try! context.fetch(request)
    }
    
    
    //MARK:UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.newsArticleTableViewCell) as! NewsArticleTableViewCell
        cell.configureCell(for: article)
        return cell
    }
    
    
    //MARK:UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldPerformSegue(withIdentifier: Identifier.webViewSegue, sender: indexPath.row){
            performSegue(withIdentifier: Identifier.webViewSegue, sender: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(articles[indexPath.row])
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            try? context.save()
        }
    }
    
    // MARK: - Navigation

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let index = sender as? Int,let urlString = articles[index].url, let _ = URL(string: urlString){
            return true
        }else{
            context.delete(articles[sender as! Int])
            try? context.save()
            tableView.reloadData()
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewVC = segue.destination as? ArticleWebViewVC{
            popWebViewVC(on: tabBarController!)
            let index = sender as! Int
            let urlString = articles[index].url!
            let url = URL(string: urlString)
            webViewVC.url = url
            webViewVC.isBookmarked = true
            webViewVC.updateBookmark = { [self] in
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
