//
//  MyCommunitiesViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import RealmSwift


/// Контроллер отвечающий за группы
class MyCommunitiesViewController: UITableViewController {

    private var groups: [RGroup] = []
    private var vkServices = VKServices()
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveGroupsData()
        self.tableViewConfig()
    }
    //MARK: - TableView datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomGroupCell.reuseId, for: indexPath) as? CustomGroupCell
            , let photo = groups[indexPath.row].photo else { return UITableViewCell() }
    
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
        cell.groupNameLabel.text = groups[indexPath.row].name
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
    
    /// Функция достает группы из БД и дает контроллеру

    private func saveGroupsData() {
        do {
            self.vkServices.getGroups()
            let realm = try Realm()
            let resultGroups = realm.objects(RGroup.self).filter("isMember != 0")
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
            self.groups = Array(resultGroups)
        } catch {
            print(error)
        }
    }
    
    private func tableViewConfig() {
        self.tableView.register(UINib(nibName: "CustomGroupCell", bundle: nil), forCellReuseIdentifier: CustomGroupCell.reuseId)
        self.tableView.dataSource = self
    }

    /// Функция по добавлению группы в свой список (не работает)
    ///
    /// - Parameter segue: сега контроллера по поиску групп (не этого)
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let controller = segue.source as! SearchComViewController
            if  let indexPath = controller.tableView.indexPathForSelectedRow {
                let groupToAdd = controller.searchGroups[indexPath.row]
                if !self.groups.contains(groupToAdd) {
                    self.groups.append(groupToAdd)
                }
            }
        }
    }
}


