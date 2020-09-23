//
//   ViewController.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/7/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let newsArticleReusableString = "newsArticleReusableCell"
    let newsArticleDequeueIdentifier = "newsArticleReusableCell"
    let headerDequeueIdentifier = "headerDequeueReusableCell" 

    
    var newsapiURLString:String = "http://newsapi.org/v2/everything?q=apple&language=en&pageSize=100&sortBy=popularity&apiKey=3e6efed2c0614492b40a7d7b716289b5"
    
    var response:Response!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        URLSession.shared.dataTask(with: URL(string: newsapiURLString)!,completionHandler: { data,_,error in
            guard let data = data,error == nil else {
                print(error?.localizedDescription)
                return
            }
            do{
                self.response = try JSONDecoder().decode(Response.self, from: data)
            }catch{
                print(error)
               return
            }
            
            DispatchQueue.main.async {
                print(self.response.totalResults)
                self.collectionView.reloadData()

            }
            }).resume()
    }
    

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            
        }
    }
    

    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response?.articles?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsArticleReusableString, for: indexPath)
        
        if let cell = cell as? NewsArticleCollectionViewCell {
            if let titleString = response.articles?[indexPath.row].title{
                cell.titleLabel.text = titleString
            }
            if let descriptionString = response.articles?[indexPath.row].description{
                cell.descriptionLabel.text = descriptionString
            }
//            //imageView
//            cell.imageView.image = UIImage(named: "question mark")
            if let urlString = response.articles?[indexPath.row].urlToImage {

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
}

