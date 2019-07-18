//
//  NewsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    var news: [NewsModel] = [
        NewsModel(newsText: "Apple News+ Guide: Everything You Need to Know", newsImagePath: "news1", newsLikes: 6532, newsComments: 423, newsShares: 123, newsViews: 54681),
        NewsModel(newsText: "Huawei Delays Launch of Foldable Smartphone, Being More 'Cautious' After Samsung's Galaxy Fold Issues", newsImagePath: "news2", newsLikes: 432, newsComments: 241, newsShares: 120, newsViews: 5023),
        NewsModel(newsText: "Google Confirms Pixel 4 Will Feature Square-Shaped Camera Bump", newsImagePath: "news3", newsLikes: 152, newsComments: 78, newsShares: 23, newsViews: 352),
        NewsModel(newsText: "Apple in Talks to Purchase Intel's German Modem Unit", newsImagePath: "news4", newsLikes: 4214, newsComments: 1231, newsShares: 349, newsViews: 106832)
        ]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomFeedCell", bundle: nil), forCellReuseIdentifier: CustomNewsCell.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.reuseId, for: indexPath) as? CustomNewsCell else { return UITableViewCell() }
        
        cell.newsText.text = news[indexPath.row].newsText
        let newsImageName = news[indexPath.row].newsImagePath
        let newsImage = UIImage(named: newsImageName)
        cell.newsImage?.image = newsImage
//        cell.imageView?.image = UIImage(named: news[indexPath.row].newsImagePath)
        cell.likes.likesCount = news[indexPath.row].newsLikes
        cell.comments.commentsCount = news[indexPath.row].newsComments
        cell.shares.sharesCount = news[indexPath.row].newsShares
        cell.views.viewsCount = news[indexPath.row].newsViews
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.reuseId, for: indexPath) as? CustomNewsCell else { return UITableViewCell }
        return 450
    }
}
