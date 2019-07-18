//
//  MyFriendsViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var friendsSectionIndex: [Character] = []
    var friendsIndexDictionary: [Character: [Friend]] = [:]
    var searchActive = false
    var friends: [Friend] = []
    let vkServices = VKServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkServices.getFriends { (resultFriends) in
            guard let subFriends = resultFriends else { return }
            self.friends = subFriends
            self.updateFriendsIndex(friends: self.friends)
            self.updateFriendsNamesDictionary(friends: self.friends)
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }

        tableView.register(UINib(nibName: "CustomFriendCell", bundle: nil), forCellReuseIdentifier: CustomFriendsCell.reuseId)
        print(self.friends)
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSectionIndex.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let char = friendsSectionIndex[section]
        let rowsCount: Int  = friendsIndexDictionary[char]?.count ?? 0
        return rowsCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(friendsSectionIndex[section])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomFriendsCell.reuseId, for: indexPath) as? CustomFriendsCell
            else { return UITableViewCell() }
        
        let char = friendsSectionIndex[indexPath.section]
        let avatarURL = URL(string: friendsIndexDictionary[char]?[indexPath.row].photo ?? "https://1001freedownloads.s3.amazonaws.com/vector/thumb/75167/1366695174.png")
        let friendsName = friendsIndexDictionary[char]?[indexPath.row].name ?? "Unknown"
        cell.nameLabel.text = friendsName
        cell.avatarImage.load(url : avatarURL!)    // ЗДЕСЬ ССАНЫЙ ФОРСАНВРАП, ИМЕЙ В ВИДУ
        tableView.separatorStyle = .none
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
    
    @objc func hideKeyboard() {
        searchActive = false
        searchBar.endEditing(true)
    }
    
    //MARK: Prepare datasource
    
    func updateFriendsNamesDictionary(friends: [Friend]) {
        self.friendsIndexDictionary = SectionIndexManager.getFriendIndexDictionary(array: friends)
    }
    
    func updateFriendsIndex(friends: [Friend]) {
        self.friendsSectionIndex = SectionIndexManager.getOrderedIndexArray(array: friends)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotosSegue",
            let photosViewController = segue.destination as? PhotosViewController {
            if let selection = self.tableView.indexPathForSelectedRow {
                let char = friendsSectionIndex[selection.section]
                let friendName = friendsIndexDictionary[char]?[selection.row].name
                photosViewController.friendName = friendName!
                let id = friendsIndexDictionary[char]?[selection.row].id
                photosViewController.friendId = id!
            }
        }
    }
}
