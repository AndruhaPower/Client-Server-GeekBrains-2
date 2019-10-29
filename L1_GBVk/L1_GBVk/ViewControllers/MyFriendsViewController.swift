//
//  MyFriendsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import RealmSwift


/// Контроллер отвечающий за друзей
class MyFriendsViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
    private var friendsSectionIndex: [Character] = []
    private var friendsIndexDictionary: [Character: [RFriend]] = [:]
    private var searchActive = false
    private var friends: [RFriend] = []
    private let vkServices = VKServices()
    private var token: NotificationToken?
    private let operationQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveFriendsData()
        self.tableViewConfig()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.friendsSectionIndex.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = self.friendsSectionIndex[section]
        let rowsCount: Int  = self.friendsIndexDictionary[char]?.count ?? 0
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsSectionIndex[section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFriendsCell.reuseId, for: indexPath) as? CustomFriendsCell else { return UITableViewCell() }
        
        let char = self.friendsSectionIndex[indexPath.section]
        guard let photo = self.friendsIndexDictionary[char]?[indexPath.row].photo else { return UITableViewCell() }
        cell.indexPath = indexPath
        let operation = LoadImageOperation()
        operation.url = URL(string: photo)
        self.operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.avatarImage.image = image
            } else {
                print("very very wrong")
            }
        }
        let friendsName = self.friendsIndexDictionary[char]?[indexPath.row].name ?? "Unknown"
        cell.nameLabel.text = friendsName
        self.tableView.separatorStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "PhotosSegue", sender: nil)
    }
    
    //MARK: Setup searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateFriendsIndex(friends: friends)
        updateFriendsNamesDictionary(friends: friends)
        
        if (searchText.count == 0) {
            updateFriendsIndex(friends: friends)
            updateFriendsNamesDictionary(friends: friends)
            searchActive = false
            hideKeyboard()
        }
        tableView.reloadData()
    }
    
    @objc private func hideKeyboard() {
        searchActive = false
        searchBar.endEditing(true)
    }
    
    //MARK: Prepare datasource
    
    func updateFriendsNamesDictionary(friends: [RFriend]) {
        self.friendsIndexDictionary = SectionIndexManager.getFriendIndexDictionary(array: friends)
    }
    
    func updateFriendsIndex(friends: [RFriend]) {
        self.friendsSectionIndex = SectionIndexManager.getOrderedIndexArray(array: friends)
    }
    
    private func saveFriendsData() {
            self.vkServices.getFriends { [weak self] (isFinished) in
                do {
                    guard let self = self else { return }
                    let realm = try Realm()
                    let resultFriends = realm.objects(RFriend.self)
                    self.friends = Array(resultFriends)
                    self.updateFriendsIndex(friends: self.friends)
                    self.updateFriendsNamesDictionary(friends: self.friends)
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
    }
    
    private func tableViewConfig() {
        self.tableView.register(UINib(nibName: "CustomFriendCell", bundle: nil), forCellReuseIdentifier: CustomFriendsCell.reuseId)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.dataSource = self
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotosSegue",
            let photosViewController = segue.destination as? PhotosViewController {
            if let selection = self.tableView.indexPathForSelectedRow {
                let char = friendsSectionIndex[selection.section]
                let friendName = friendsIndexDictionary[char]?[selection.row].name
                photosViewController.title = friendName ?? "Unknown"
                let id = friendsIndexDictionary[char]?[selection.row].id
                photosViewController.friendId = id!
            }
        }
    }
}
