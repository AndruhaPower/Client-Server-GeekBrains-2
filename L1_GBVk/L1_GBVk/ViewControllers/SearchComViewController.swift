//
//  SearchComViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import RealmSwift

/// Контроллер отвечающий за поиск групп
class SearchComViewController: UITableViewController {

    var searchGroups: [RGroup] = []
    var vkServices = VKServices()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveGroupsData()
        self.tableViewConfig()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomGroupCell.reuseId, for: indexPath) as? CustomGroupCell
            , let photo = searchGroups[indexPath.row].photo else { return UITableViewCell() }
        
        cell.indexPath = indexPath
        let operationQueue = OperationQueue()
        let operation = LoadImageOperation()
        operation.url = URL(string: photo)
        operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.groupAvatarImage.image = image
            }
        }
        cell.groupNameLabel.text = searchGroups[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func saveGroupsData() {
        do {
            self.vkServices.getSearchGroups()
            let realm = try Realm()
            let resultGroups = realm.objects(RGroup.self).filter("isMember != 1")
            self.token = resultGroups.observe { [weak self] (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    self?.tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    self?.tableView.insertRows(at: insertions.map({ IndexPath(row:  $0, section: 0)}), with: .automatic)
                    self?.tableView.deleteRows(at: deletions.map({IndexPath(row:  $0, section: 0)}), with: .automatic)
                    self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                case .error(let error):
                    print(error)
                }
            }
            self.searchGroups = Array(resultGroups)
        } catch {
            print(error)
        }
    }
    
    private func tableViewConfig() {
        self.title = "Поиск групп"
        self.tableView.register(UINib(nibName: "CustomGroupCell", bundle: nil), forCellReuseIdentifier: CustomGroupCell.reuseId)
        self.tableView.dataSource = self
    }
    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if let controller = segue.source as? SearchComViewController,
            let indexPath = controller.tableView.indexPathForSelectedRow {
//            let newgroup = controller.searchGroups[indexPath.row]
            let newIndexPath = IndexPath(item: searchGroups.count-1, section: 0)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
