//
//  NewsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class NewsViewController: UIViewController {
    
    var news: [NewsViewModel] = []
    var vkServices = VKServices()
    public weak var delegate: TextCellDelegate?
    var numberOfRowsInSection = 4
    var expandedCells = [IndexPath: Bool]()
    let operationQueue = OperationQueue()
    var isLoading: Bool = false
    private var nextFrom : String = ""
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return self.getHeightForTextCell(indexPath: indexPath)
        case 2:
            return self.getHeightForMediaCell(indexPath: indexPath)
        case 3:
            return 40
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            return self.setupHeaderCell(tableView: tableView, indexPath: indexPath)
        case 1:
            return self.setupTextCell(tableView: tableView, indexPath: indexPath)
        case 2:
            return self.setupMediaCell(tableView: tableView, indexPath: indexPath)
        case 3:
            return self.setupControlsCell(tableView: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: Methods for Setting tableViewData
    
    @objc func refreshNews(_ sender: Any) {
        let firstPostDate = self.news.first?.date ?? Date().timeIntervalSince1970
        self.vkServices.getNews(startTime: firstPostDate + 1) { newPosts, nextFrom in
            guard let posts = newPosts,
                    posts.count > 0
                else { self.tableView.refreshControl?.endRefreshing(); return }
            self.news = posts + self.news
            let indexSet = IndexSet(integersIn: 0..<posts.count)
            self.tableView.insertSections(indexSet, with: .automatic)
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
        self.tableView.prefetchDataSource = self
        self.tableView.allowsSelection = false
        self.configRefreshControl()
        
        self.tableView.separatorColor = .clear
        self.vkServices.getNews { news, nextFrom in
            guard let news = news,
                  let nextFrom = nextFrom else { return }
            self.news = news
            self.nextFrom = nextFrom
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
       self.tableView.separatorStyle = .singleLine
    }
    
    private func configRefreshControl() {
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление...")
        self.tableView.refreshControl?.tintColor = .darkGray
        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    private func getHeightForMediaCell(indexPath: IndexPath) -> CGFloat {
        let tableWidth = tableView.bounds.width
        let news = self.news[indexPath.section]
        var cellHeight: CGFloat = 0
        if news.attachments.count < 1 {
            return cellHeight
        } else if news.attachments.count == 1 {
            cellHeight = tableWidth / news.attachments[0].ratio
        } else if news.attachments.count > 1 {
            cellHeight = tableWidth / news.attachments[0].ratio
        }
        return cellHeight
    }
    
    private func getHeightForTextCell(indexPath: IndexPath) -> CGFloat {
        let news = self.news[indexPath.section]
        let text = news.text
        let textSize = self.getLabelSize(text: text, font: UIFont.systemFont(ofSize: 18), maxWidth: tableView.bounds.width)
        let expandedState = self.expandedCells[indexPath] ?? false
        if expandedState {
            return textSize.height
        } else {
            return min(textSize.height, 100)
        }
    }
    
    private func getLabelSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let textblock = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textblock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        let width = rect.width.rounded(.up)
        let height = rect.height.rounded(.up)
        return CGSize(width: width, height: height)
    }
    
    private func setupHeaderCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFriendsCell.reuseId, for: indexPath) as? CustomFriendsCell,
              indexPath.section <= self.news.count - 1 else { return UITableViewCell() }
        
        cell.indexPath = indexPath
        cell.nameLabel.text = news[indexPath.section].name
        let photo = self.news[indexPath.section].avatarPhotoUrl
        let operation = LoadImageOperation()
        operation.url = URL(string: photo)
        self.operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.avatarImage.image = image
            }
        }
        return cell
    }
    
    private func setupTextCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseIdentifier, for: indexPath) as? TextCell else { return UITableViewCell() }
        cell.delegate = self
        cell.newsText.text = self.news[indexPath.section].text
        return cell
    }
    
    private func setupMediaCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as? MediaCell,
            self.news[indexPath.section].attachments.count > 0,
            self.news[indexPath.section].attachments[0].ratio != 0 else { return UITableViewCell(frame: CGRect(x: 0, y: 0, width: 0, height: 0 )) }
        
        cell.indexPath = indexPath
        let photo = news[indexPath.section].attachments[0].url
        if photo.count != 0 {
            let operation = LoadImageOperation()
            operation.url = URL(string: photo)
            self.operationQueue.addOperation(operation)
            operation.completion = { image in
                if cell.indexPath == indexPath {
                    cell.newsImage.image = image
                }
            }
        } else {
            cell.frame = .zero
        }
        return cell
    }
    
    private func setupControlsCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ControlsCell.reuseIdentifier, for: indexPath) as? ControlsCell else { return UITableViewCell() }
        
        let item = self.news[indexPath.section]
        cell.stackView.likes.updateLikesCount(likes: item.likesCount)
        cell.stackView.comments.updateCommentsCount(comments: item.commentCount)
        cell.stackView.shares.updateSharesCount(comments: item.repostCount)
        cell.viewsControl.updateViewsCount(comments: item.viewsCount)

        return cell
    }
}

extension NewsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > self.news.count - 3,
            !self.isLoading {
            self.isLoading = true
            self.vkServices.getNews(startFrom: self.nextFrom) { [weak self] newPosts, nextFrom in
                guard let newPosts = newPosts else { return }
                self?.news.append(contentsOf: newPosts)
                self?.tableView.reloadData()
                self?.isLoading = false
            }
        }
    }
}

extension NewsViewController: TextCellDelegate {
    
    func textCellTapped(at cell: TextCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        var expandedState = expandedCells[indexPath] ?? false
        expandedState.toggle()
        self.expandedCells[indexPath] = expandedState
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
