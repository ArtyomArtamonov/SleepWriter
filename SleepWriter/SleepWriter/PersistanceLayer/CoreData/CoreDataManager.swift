//
//  CoreDataManager.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import CoreData

protocol CoreDataManagerProtocol {
    var context : NSManagedObjectContext { get }
    
    func delete(object : NSManagedObject) -> ()
    func save() -> ()
    
    func fetch<T : NSManagedObject>(type objectType : T.Type, dateOrderAscending : Bool) -> [T]
    func fetch<T : NSManagedObject>(type objectType : T.Type) -> [T]
}

final class CoreDataManager : CoreDataManagerProtocol {
    
    private var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SleepWriter")
        
        container.loadPersistentStores { (container, error) in
            if let error = error {
                print("Error while initializing persistentContainer: \(error.localizedDescription)")
            }
        }
        
        return container
    }()
    
    public lazy var context : NSManagedObjectContext = self.persistentContainer.viewContext
    
    public func fetch<T : NSManagedObject>(type objectType : T.Type, dateOrderAscending : Bool) -> [T] {
        let name : String = .init(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: dateOrderAscending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let result = try self.context.fetch(fetchRequest) as? [T]
            return result ?? .init()
        } catch {
            print("Error while fetching the data: \(error.localizedDescription)")
            return .init()
        }
    }
    
    public func fetch<T : NSManagedObject>(type objectType : T.Type) -> [T] {
        let name : String = .init(describing: objectType)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        do {
            let result = try self.context.fetch(fetchRequest) as? [T]
            return result ?? .init()
        } catch {
            print("Error while fetching the data: \(error.localizedDescription)")
            return .init()
        }
    }
    
    public func save() -> () {
        if self.context.hasChanges {
            do { try self.context.save() }
            catch { print("Error while saving the data: \(error.localizedDescription)") }
        }
    }
    
    public func delete(object : NSManagedObject) -> () {
        self.context.delete(object)
        self.save()
    }
}
