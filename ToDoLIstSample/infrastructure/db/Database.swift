//
//  Database.swift
//  ToDoLIstSample
//
//  Created by Masafumi Abe on 2020/09/17.
//

import CoreData

class Database {
    
    private (set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoLIstSample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        get { persistentContainer.viewContext }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func insert<T : NSManagedObject>(mappter: (T) throws -> ()) rethrows  {
        let dto = T.init(context: context)
        try mappter(dto)
        saveContext()
    }
    
    func update<T : NSManagedObject>(at predicate: NSPredicate, block: (T) throws -> ()) rethrows {
        let req = NSFetchRequest<T>(entityName: String(describing: T.self))
        req.predicate = predicate
        
        if let dto: T = fetch(by: predicate) {
            try block(dto)
            saveContext()
        }
        
    }
    
    func delete<T : NSManagedObject>(at predicate: NSPredicate, type: T.Type)  {
        if let dto: T = fetch(by: predicate) {
            context.delete(dto)
            saveContext()
        }
    }
    
    func fetch<T : NSManagedObject>(by predicate: NSPredicate) -> T? {
        let req = NSFetchRequest<T>(entityName: String(describing: T.self))
        req.predicate = predicate
        req.fetchLimit = 1
        do {
            let dtos = try context.fetch(req)
            if !dtos.isEmpty {
                return  dtos[0]
            }
            return nil
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
    func fetchAll<T : NSManagedObject>(limit: Int = 0, offset: Int = 0) -> [T] {
       fetchAll(by: nil, limit: limit, offset: offset)
    }
    
    func fetchAll<T : NSManagedObject>(by predicate: NSPredicate?, limit: Int = 0, offset: Int = 0) -> [T] {
        let req = NSFetchRequest<T>(entityName: String(describing: T.self))
        req.fetchOffset = offset
        req.predicate = predicate
        
        if limit != 0 {
            req.fetchLimit = limit
        }
        
        do {
            return try context.fetch(req)
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
}
