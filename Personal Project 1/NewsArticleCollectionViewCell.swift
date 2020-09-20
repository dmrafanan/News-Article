//
//  NewsArticleCollectionViewCell.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/10/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class NewsArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: CustomImageView!
    
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            
        }
    }
}

let cache = NSCache<NSURL, AnyObject>()

class CustomImageView:UIImageView {
    private var imageURL:URL?
    
    func fetchImage(from url:URL){
        imageURL = url
        image = nil
        if let imageFromCache = cache.object(forKey: url as NSURL){
            image = imageFromCache as? UIImage

        }else{

            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error,data == nil{
                    print(error.localizedDescription)
                    return
                }

                if url == self.imageURL{
                    DispatchQueue.main.async {
                        cache.setObject(UIImage(data: data!)!, forKey: url as NSURL)
                        self.image = UIImage(data: data!)
                    }
                }
            }.resume()
        }
    }
}
