//
//  DreamsViewController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamsViewController: UITableViewController {
    
    private var dreamsData : [Dream] = .init()
    
    private func fetchData() -> () {
        self.dreamsData = PersistanceLayer.coreData.fetch(type: Dream.self, dateOrderAscending: false)
    }
    
    private func initialConfiguration() -> () {
        self.fetchData()
        self.tableView.register(UINib(nibName: "DreamCell", bundle: nil), forCellReuseIdentifier: "dreamCell")
    }
    
    public func add(dream : Dream) -> () {
        #warning("TODO: Add more logic here.")
        
        self.dreamsData.insert(dream, at: 0)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() -> () {
        super.viewDidLoad()
        self.initialConfiguration()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dreamsData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hello date"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell") as! DreamCell
        
        cell.display(title: self.dreamsData[indexPath.row].title)
        cell.display(date: self.dreamsData[indexPath.row].date.format(to: "dd.MM.yyyy"))
        
        return cell
    }
}
