//
//  MyCommunitiesViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import RealmSwift

final class MyCommunitiesViewController: UITableViewController {

    private var groups: [RGroup] = []
    private let vkServices = VKServices()
    private var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveGroupsData()
        self.tableViewConfig()
    }
    //MARK: - TableView datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomGroupCell.reuseId, for: indexPath) as? CustomGroupCell
            , let photo = self.groups[indexPath.row].photo else { return UITableViewCell() }
        
        cell.groupNameLabel.text = self.groups[indexPath.row].name
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }    
    }

    private func saveGroupsData() {
        do {
            self.vkServices.getGroups()
            let realm = try Realm()
            let resultGroups = realm.objects(RGroup.self).filter("isMember != 0")
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
        guard let searchComVC = segue.source as? SearchComViewController,
              let indexPath = searchComVC.tableView.indexPathForSelectedRow else { return }
        
        let newGroup = searchComVC.searchGroups[indexPath.row]
        if !self.groups.contains(newGroup) {
            self.groups.append(newGroup)
        }
        self.tableView.reloadData()
    }
}


