//
//  DreamsViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

protocol DreamsViewControllerDelegate{
    func updateCells() -> Void
}

class DreamsViewController: UITableViewController, DreamsViewControllerDelegate {
    
    var mainVC : MainViewControllerProtocol?
    
    let cellId = "DreamTableViewCell"
    
    var dreamsData : [Dream] = []
    
    public func updateCells() {
        reloadDreams()
        self.tableView.reloadData()
    }
    
    private func reloadDreams(){
        if let data = try? JSONSerialization.loadJSON(withFilename: fileName){
            dreamsData = data as! [Dream]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .overCurrentContext
        
        self.view.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.register(DreamTableViewCell.self, forCellReuseIdentifier: cellId)
        
        
        
//        // Load info
//        // Write nil:
//        try? JSONSerialization.save(jsonObject: dreamsData, toFilename: fileName)
//        // End write nil
        reloadDreams()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dreamsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! DreamTableViewCell
        
        let dream : Dream = dreamsData[indexPath.row]
        
        cell.setCell(title: dream.title, text: floatTimeToDateString(since1970: dream.date))
        
        // Configure cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dream = dreamsData[indexPath.row]
        self.present(DreamReadViewController(dream: dream), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
