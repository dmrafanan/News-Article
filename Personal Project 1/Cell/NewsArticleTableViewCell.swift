//
//  NewsArticleCollectionViewCell.swift
//  Personal Project 1
//
//Created by Daniel Marco S. Rafanan on Sep/10/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class NewsArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: CustomImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    func configureCell(for article:Article){
        self.titleLabel.text = removeSourceFromTitle(article.title ?? "")
        self.sourceLabel.text = article.source?.name
        self.descriptionLabel.text = article.articleDescription
        if let urlString = article.urlToImage, let url = URL(string: urlString){
            self.articleImageView.fetchImage(from: url)
        }
        if let publishedAt = article.publishedAt{
            dateLabel.text = "⏰ \(publishDateToTimeElapsed(string: publishedAt))"
        }
    }
    func publishDateToTimeElapsed(string:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: string){
            let hoursElapsed = Int(floor(((date.timeIntervalSinceNow/60)/60) * -1))
            let daysElapsed = hoursElapsed/24
            let monthsElapsed = daysElapsed/30
            let yearsElapsed = monthsElapsed/12
            //Hours
            if (hoursElapsed < 24){
                if hoursElapsed == 0{
                    return "An hour ago"
                }else{
                    return "\(hoursElapsed) hours ago"
                }
                //Days
            }else if (daysElapsed < 30){
                if ( daysElapsed == 1 ){
                    return "A day ago"
                }else{
                    return "\(hoursElapsed) days ago"
                }
                //Months
            }else if(monthsElapsed<12){
                if ( monthsElapsed == 1){
                    return "A month ago"
                }else{
                    return "\(monthsElapsed) months ago"
                }
                //Years
            }else{
                if yearsElapsed == 1{
                    return "A year ago"
                }else{
                    return "More than a year ago"
                }
            }
        }
        return ""
    }
    
    func removeSourceFromTitle(_ title:String)->String{
        //Remove everything after and including " - "
        //Corona virus reaches all time high - CNN News
        //Corona virus reaches all time high
        var newTitle = title
        if let dashIndex = newTitle.lastIndex(of: "-"), newTitle[newTitle.index(before: dashIndex)] == " ",newTitle[newTitle.index(after: dashIndex)] == " "{
            newTitle.removeSubrange(newTitle.lastIndex(of: "-")!..<newTitle.endIndex)
        }
        return newTitle
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
            image = UIImage(named: "no image available")
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error,data == nil{
                    print(error.localizedDescription)
                    self.image = UIImage(named: "no image available")
                    return
                }
                guard let image = UIImage(data: data!) else {return}
                if url == self.imageURL{
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data!)
                    }
                }
                cache.setObject(image, forKey: url as NSURL)
            }.resume()
        }
    }
}
