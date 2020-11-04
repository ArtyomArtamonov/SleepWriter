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
}

extension DreamsViewController {
    
    private func targetedPreview(with configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? DreamCell
        else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return .init(view: cell.mainView, parameters: parameters)
    }
    
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
    
    override func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.targetedPreview(with: configuration)
    }
    
    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return self.targetedPreview(with: configuration)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let identifier = indexPath as NSCopying
        
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { (_) -> UIMenu? in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                // Delete logic or function call here...
                PersistanceLayer.coreData.delete(object: self.dreamsData[indexPath.row])
                self.dreamsData.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}
