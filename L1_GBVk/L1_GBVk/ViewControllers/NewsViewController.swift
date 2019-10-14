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
    var sourceGroups: [Groups] = []
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
        cell.likes.likesCount = self.news[indexPath.row].likesCount
        cell.comments.commentsCount = self.news[indexPath.row].commentCount
        cell.shares.sharesCount = self.news[indexPath.row].repostCount
        cell.indexPath = indexPath
        let operationQueue = OperationQueue()
        let operation = LoadImageOperation()
        operation.url = URL(string: photo)
        operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.newsImage.image = image
            } else {
                print("not the right picture")
            }
        }
        getGroupInfo(source_id: news[indexPath.row].source_id) { inprocessGroup in
            guard let group = inprocessGroup else { return }
            cell.name.text = group.name
            let photoUrl = URL(string: group.photoUrl)
            let GroupOperation = LoadImageOperation()
            GroupOperation.url = photoUrl
            operationQueue.addOperation(GroupOperation)
            GroupOperation.completion = { image in
                cell.userphoto.image = image
                }
            }
        return cell
    }
    
    
    /*
     if let model = self.models[indexPath.row]
     if model.uiimage != nil {
     guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UIImageCollectionViewCell else { return UICollectionViewCell() }
     
     cell.image = model.uiimage
     return cell
     } else {
     guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? UIImageCollectionViewCell else { return UICollectionViewCell() }
     cell.title = model.title
     return cell
     }
     }
     */
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    func getFeedData() {
        self.vkServices.getNews(count: 50) { resultFeed, resultGroups in
            guard let feed = resultFeed,
            let groups = resultGroups
            else { return }
            self.news = feed
            self.sourceGroups = groups
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func getGroupInfo(source_id: Int, completion: @escaping ((Groups?)->())) {
        for group in self.sourceGroups {
            if group.id == -(source_id) {
                completion(group)
            } else {
                print("Skipping through group #\(group.name)")
            }
        }
    }
    
    func configureViewDidLoad() {
        self.tableView.register(UINib(nibName: "CustomFeedCell", bundle: nil), forCellReuseIdentifier: CustomNewsCell.reuseId)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 600
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}
