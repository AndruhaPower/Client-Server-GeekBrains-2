//
//  NewsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    var news: [NewsViewModel] = []
    var vkServices = VKServices()
    var numberOfRowsInSection = 4
    var expandedCells = [IndexPath: Bool]()
    let operationQueue = OperationQueue()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewDidLoad()
        
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
//        case 1:
//            let news = self.news[indexPath.section]
//            guard let text = news.text else { return 0 }
//            let textSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: 17), maxWidth: tableView.bounds.width)
//            let expandedState = expandedCells[indexPath] ?? false
//            if expandedState {
//                return textSize.height
//            } else {
//                return min(textSize.height, 100)
//            }
        case 2:
            let tableWidth = tableView.bounds.width
            let news = self.news[indexPath.section]
            let cellHeight = tableWidth / news.ratio
            return cellHeight
        case 3:
            return 40
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func getLabelSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let textblock = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textblock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        let width = rect.width.rounded(.up)
        let height = rect.height.rounded(.up)
        return CGSize(width: width, height: height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFriendsCell.reuseId, for: indexPath) as? CustomFriendsCell,
                  indexPath.section <= self.news.count - 1 else { return UITableViewCell() }
            
            cell.indexPath = indexPath
            let photo = self.news[indexPath.section].avatarPhotoUrl
            let operation = LoadImageOperation()
            operation.url = URL(string: photo)
            self.operationQueue.addOperation(operation)
            operation.completion = { image in
                if cell.indexPath == indexPath {
                    cell.avatarImage.image = image
                } else {
                    print("indexPath for Avatar Image is wrong")
                }
            }
            cell.nameLabel.text = news[indexPath.section].name
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { return UITableViewCell() }
            cell.newsText.text = self.news[indexPath.section].text
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as? MediaCell,
                  self.news[indexPath.section].ratio != 0 else { return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0 )) }
            
            cell.indexPath = indexPath
            let photo = news[indexPath.section].photoUrl
            if photo.count != 0 {
                let operation = LoadImageOperation()
                operation.url = URL(string: photo)
                self.operationQueue.addOperation(operation)
                operation.completion = { image in
                    if cell.indexPath == indexPath {
                        cell.newsImage.image = image
                    } else {
                        print("indexPath for News Image is wrong")
                    }
                }
            } else {
                cell.frame = .zero
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ControlsCell.reuseIdentifier, for: indexPath) as? ControlsCell else { return UITableViewCell() }
            
            let item = self.news[indexPath.section]
            cell.stackView.likes.updateLikesCount(likes: item.likesCount)
            cell.stackView.comments.updateCommentsCount(comments: item.commentCount)
            cell.stackView.shares.updateSharesCount(comments: item.repostCount)
            cell.viewsControl.updateViewsCount(comments: item.viewsCount)
            
            return cell
        default:
            
            return UITableViewCell()
        }
    }
    
    @objc func refreshNews(_ sender: Any) {
        let firstPostDate = self.news.first?.date ?? Date().timeIntervalSince1970
        self.vkServices.getNews(startTime: firstPostDate) { newPosts in
            guard let posts = newPosts,
                    posts.count > 0,
                    posts.first?.date != self.news.first?.date
                else { self.tableView.refreshControl?.endRefreshing(); return }
            self.news = posts + self.news
            let indexSet = IndexSet(integersIn: 0..<posts.count)
            self.tableView.insertSections(indexSet, with: .automatic)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func configureViewDidLoad() {
        
        self.tableView.register(UINib(nibName: "CustomFriendCell", bundle: nil), forCellReuseIdentifier: CustomFriendsCell.reuseId)
        self.tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: TextCell.reuseIdentifier)
        self.tableView.register(MediaCell.self, forCellReuseIdentifier: "custom")
        self.tableView.register(UINib(nibName: "ControlsCell", bundle: nil), forCellReuseIdentifier: ControlsCell.reuseIdentifier)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.tableView.refreshControl?.tintColor = .red
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        self.tableView.separatorColor = .clear
        self.vkServices.getNews { news in
            guard let news = news else { return }
            self.news = news
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       self.tableView.separatorStyle = .singleLine
    }
}
