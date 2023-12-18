//
//  CoreDataManager.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 11/6/23.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case error(Error)
}

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // pass the data model filename to NSPersistentContainer initializer
        persistentContainer = NSPersistentContainer(name: "DataModel")
        
        // load any persistent stores
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    private func saveContext() throws {
        do {
            try managedObjectContext.save()
        } catch {
            managedObjectContext.rollback()
            throw CoreDataError.error(error)
        }
    }
}

// Diary View Methods
extension CoreDataManager {
    func saveEntry(entityName: String, info: [String: Any]) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedObjectContext) else {
            throw NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Entity \(entityName) not found in context"])
        }
        
        let entry = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        info.forEach { (key, value) in
            entry.setValue(value, forKey: key)
        }
        
        try saveContext()
        print("Saved Entry!")
    }
    
    func saveDiaryEntry(info: [String: Any]) throws {
        let entry = DiaryEntry(context: managedObjectContext)
        info.forEach { (key, value) in
            entry.setValue(value, forKey: key)
        }
        
        try saveContext()
        print("Saved Entry!")
    }
    
    // fetch the entries with in a time frame
    func fetchAllEntries<T: NSManagedObject>(using predicate: NSPredicate? = nil) -> [T] {
        guard let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as? NSFetchRequest<T> else {
            return []
        }
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            // Perform the fetch request
            let results = try managedObjectContext.fetch(fetchRequest)
            return results
        } catch {
            print("Error fetching data: \(error)")
            return []
        }
        
    }
}
