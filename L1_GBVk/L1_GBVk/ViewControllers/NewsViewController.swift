//
//  NewsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    var news: [Feed] = []
    var vkServices = VKServices()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewDidLoad()
        self.getFeedData()
        
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.reuseId, for: indexPath) as? CustomNewsCell else { return UITableViewCell() }
        
        let photo = news[indexPath.row].photoUrl
        
        cell.newsText.text = self.news[indexPath.row].text
        cell.comments.commentsCount = self.news[indexPath.row].commentCount
        cell.likes.likesCount = self.news[indexPath.row].likesCount
        cell.shares.sharesCount = self.news[indexPath.row].repostCount
        cell.indexPath = indexPath
        let operationQueue = OperationQueue()
        let operation = LoadImageOperation()
        operation.url = URL(string: photo)
        operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.newsImage.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func getFeedData() {
        self.vkServices.getNews(count: 50) { resultFeed in
            guard let feed = resultFeed else { return }
            self.news = feed
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configureViewDidLoad() {
        self.tableView.register(UINib(nibName: "CustomFeedCell", bundle: nil), forCellReuseIdentifier: CustomNewsCell.reuseId)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
