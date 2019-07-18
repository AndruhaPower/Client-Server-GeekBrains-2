//
//  SearchComViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class SearchComViewController: UITableViewController {

    var searchGroups: [Group] = []
    var vkServices = VKServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск групп"
        vkServices.getSearchGroups { (gotGroups) in
            guard let sGroups = gotGroups else { return }
            self.searchGroups = sGroups
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        tableView.register(UINib(nibName: "CustomGroupCell", bundle: nil), forCellReuseIdentifier: CustomGroupCell.reuseId)
        tableView.dataSource = self
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomGroupCell.reuseId, for: indexPath) as? CustomGroupCell else { return UITableViewCell() }

        let avatarName = URL(string: searchGroups[indexPath.row].photo)
        cell.groupNameLabel.text = searchGroups[indexPath.row].name
        cell.groupAvatarImage.load(url: avatarName!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    // MARK: - Navigation
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let controller = segue.source as? SearchComViewController,
            let indexPath = controller.tableView.indexPathForSelectedRow {
            let newgroup = controller.searchGroups[indexPath.row]
            
            searchGroups.append(newgroup)
            let newIndexPath = IndexPath(item: searchGroups.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
