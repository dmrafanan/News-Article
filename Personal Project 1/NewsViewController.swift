//
//   ViewController.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/7/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let newsArticleReusableString = "newsArticleReusableCell"
    private let headerDequeueIdentifier = "headerDequeueReusableCell"
    private let webViewSegueIdentifier = "ArticleWebViewVCSegue"
    
    private var newsapiURLString:String = "http://newsapi.org/v2/top-headlines?language=en&pageSize=100&apiKey=3e6efed2c0614492b40a7d7b716289b5"
    
    private var newsapiPHURLString = "http://newsapi.org/v2/top-headlines?country=ph&apiKey=3e6efed2c0614492b40a7d7b716289b5"
    
    var response:Response?
    
    var articles:[Article] {
        return response?.articles ?? [Article]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Exclude financial times?
        URLSession.shared.dataTask(with: URL(string: newsapiURLString)!) { data,_,error in
            guard let data = data,error == nil else {
                print(error?.localizedDescription ?? error)
                return
            }
            do{
                self.response = try JSONDecoder().decode(Response.self, from: data)
                print(self.response)
            }catch{
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsArticleReusableString, for: indexPath)
        
        if let cell = cell as? NewsArticleCollectionViewCell {
            if let titleString = articles[indexPath.row].title{
                cell.titleLabel.text = titleString
            }
            if let descriptionString = articles[indexPath.row].description{
                cell.descriptionLabel.text = descriptionString
            }
            if let urlString = articles[indexPath.row].urlToImage {
                
                if let url = URL(string: urlString){
                    cell.imageView.fetchImage(from: url)
                }
            }
        }
        return cell
    }
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: webViewSegueIdentifier, sender: indexPath.row)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let index = sender as? Int, let urlString = articles[index].url, let _ = URL(string: urlString){
            return true
        }
        return false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let webViewVC = segue.destination as? ArticleWebViewVC, let index = sender as? Int,let urlString = articles[index].url,let url = URL(string: urlString){
            webViewVC.url = url
        }
    }
}
