//
//  MyCommunitiesViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class MyCommunitiesViewController: UITableViewController {

    var groups: [Group] = []
    var vkServices = VKServices()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        vkServices.getGroups { (gotGroups) in
            guard let mygroups = gotGroups else { return }
            self.groups = mygroups
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
        tableView.register(UINib(nibName: "CustomGroupCell", bundle: nil), forCellReuseIdentifier: CustomGroupCell.reuseId)
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomGroupCell.reuseId, for: indexPath) as? CustomGroupCell else { return UITableViewCell() }
        let avatarName = URL(string: groups[indexPath.row].photo)
        cell.groupNameLabel.text = groups[indexPath.row].name
        cell.groupAvatarImage.load(url: avatarName!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let controller = segue.source as! SearchComViewController
            if  let indexPath = controller.tableView.indexPathForSelectedRow {
                let groupToAdd = controller.searchGroups[indexPath.row]
                if !groups.contains(groupToAdd) {
                    groups.append(groupToAdd)
                }
            }
        }
    }
}


