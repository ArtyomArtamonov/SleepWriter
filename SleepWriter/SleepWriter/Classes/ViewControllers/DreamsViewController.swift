//
//  DreamsViewController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamSorter{
    
    public var dreamsData : [Dream] = [] {
        didSet{
            sort()
            #warning("Sort dreams by dates")
        }
    }
    
    private var dreamsSorted = [[Dream]]()
    
    public func getDreamsBySections() -> [[Dream]]{
        return dreamsSorted
    }
    
    public func add(dream : Dream) -> () {
        dreamsData.append(dream)
    }
    
    public func remove(dream : Dream) -> () {
        dreamsData.remove(at: dreamsData.firstIndex(of: dream)!)
    }
    
    public func remove(at indexPath: IndexPath) -> () {
        dreamsSorted[indexPath.section].remove(at: indexPath.row)
        if dreamsSorted[indexPath.section].isEmpty{
            dreamsSorted.remove(at: indexPath.section)
        }
    }
    
    init(dreams : [Dream]){
        dreamsData = dreams
        sort()
    }
    
    private func sort(){
        var dreamsBySections = [String : [Dream]]()
        dreamsSorted = [[Dream]]()
        
        for dream in dreamsData{
            if !dreamsBySections.keys.contains(getSection(for: dream)){
                dreamsBySections.updateValue([], forKey: getSection(for: dream))
            }
            if !dreamsBySections[getSection(for: dream)]!.contains(dream){
                dreamsBySections[getSection(for: dream)]!.append(dream)
            }
        }
        
        for dreams in dreamsBySections.values{
            self.dreamsSorted.append(dreams.sorted(by: {$0.date > $1.date}))
        }
        dreamsSorted.sort { dreams1, dreams2 in
            return dreams1[0].date > dreams2[0].date
        }
    }
    
    private func getSection(for dream : Dream) -> String{
        if getYear(from: dream.date) == getYear(from: Date()) {
            return getMonth(from: dream.date)
        }else{
            return getMonth(from: dream.date) + " " + getYear(from: dream.date)
        }
    }
    
    private func getMonth(from date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date)
    }
    
    private func getYear(from date : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter.string(from: date)
    }
}

class DreamsViewController: UITableViewController {
    
    private var dreamsData : [Dream] = .init(){
        didSet{
            sortData()
        }
    }
    private var dreamSorter : DreamSorter!
    private var dreamsBySections : [[Dream]]!
    public weak var delegate : MainViewControllerDelegate?
    
    private func fetchData() -> () {
        dreamsData = PersistanceLayer.coreData.fetch(type: Dream.self, dateOrderAscending: true)
    }
    
    private func updateDreamsArray(){
        dreamsBySections = dreamSorter.getDreamsBySections()
    }
    
    private func sortData() -> () {
        if let _ = self.dreamSorter{
            
        }else{
            dreamSorter = DreamSorter(dreams: dreamsData)
        }
        dreamSorter.dreamsData = dreamsData
        self.updateDreamsArray()
    }
    
    private func initialConfiguration() -> () {
        self.fetchData()
        self.tableView.register(UINib(nibName: "DreamCell", bundle: nil), forCellReuseIdentifier: "dreamCell")
    }
    
    public func add(dream : Dream) -> () {
        self.dreamSorter.add(dream: dream)
        self.updateDreamsArray()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() -> () {
        super.viewDidLoad()
        self.initialConfiguration()
    }
}

extension DreamsViewController{
    
    private func targetedPreview(with configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = self.tableView.cellForRow(at: indexPath) as? DreamCell
        else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        
        return .init(view: cell.mainView, parameters: parameters)
    }
    
    private func getSectionLabel(forDreams dreams : [Dream]) -> UILabel{
        let formatterM = DateFormatter()
        let formatterY = DateFormatter()
        formatterY.dateFormat = "YYYY"
        if formatterY.string(from: dreams[0].date) != formatterY.string(from: Date()){
            formatterM.dateFormat = "LLLL YYYY"
        }else{
            formatterM.dateFormat = "LLLL"
        }
        
        let month : String = formatterM.string(from: dreams[0].date)
        
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = month
        label.font = UIFont(name: "Rubik-Regular", size: 19)
        label.textColor = .white
        label.textAlignment = .center
        // Section logic
        return label
    }
    
    private func getDream(by indexPath : IndexPath) -> Dream{
        return self.dreamsBySections[indexPath.section][indexPath.row]
    }
    
    private func getDreamsCount(withOffset offset : Int) -> Int{
        return dreamsBySections[offset].count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDreamsCount(withOffset: section)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //#error("Delegate is nil")
        self.delegate?.showDetails(of: getDream(by: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getSectionLabel(forDreams: dreamsBySections[section])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dreamsBySections.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell") as! DreamCell
        
        cell.display(title: getDream(by: indexPath).title)
        cell.display(date: getDream(by: indexPath).date.format(to: "dd.MM.yyyy"))
        
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
                
                PersistanceLayer.coreData.delete(object: self.dreamsBySections[indexPath.section][indexPath.row])
                self.dreamSorter.remove(at : indexPath)
                self.updateDreamsArray()
                self.tableView.reloadData()
            }
            
            return UIMenu(title: "", children: [deleteAction])
        }
    }
}
