//
//  Dream+CoreDataClass.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//
//

import Foundation
import CoreData

public class Dream: NSManagedObject {
    
    @NSManaged public var title: String
    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var lastOpened: Date
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dream> {
        return NSFetchRequest<Dream>(entityName: "Dream")
    }
    
    convenience init(title : String, text : String, date : Date, lastOpened : Date) {
        self.init(context: PersistanceLayer.coreData.context)
        
        self.title = title
        self.text = text
        self.date = date
        self.lastOpened = lastOpened
    }
}
