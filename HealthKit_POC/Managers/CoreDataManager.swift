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
    func saveDiaryEntry(info: [String : String], images: Data?, isFavorite: Bool = false) throws {
        let entry = DiaryEntry(context: managedObjectContext)
        
        info.forEach { (key, value) in
            entry.setValue(value, forKey: key)
        }
        
        entry.setValue(Date(), forKey: "date")
        entry.setValue(images, forKey: "images")
        try saveContext()
        print("Saved Entries")
    }
    
    func saveDiaryEntry(entry: any FoodEntry) throws {
        let entry = DiaryEntry(context: managedObjectContext)
        let imageData = entry.uiImages.count > 0 ? entry.uiImages.encodeImagesToData() : nil

        entry.setValue(entry.date, forKey: "date")
        entry.setValue(entry.protein, forKey: "protein")
        entry.setValue(entry.fats, forKey: "fats")
        entry.setValue(entry.carbs, forKey: "carbs")
        entry.setValue(imageData, forKey: "images")
        try saveContext()
        print("Saved Entries from favorites")
    }
    
    func getAllDiaryEntries() -> [any FoodEntry] {
        let fetchRequest: NSFetchRequest<DiaryEntry> = NSFetchRequest(entityName: "DiaryEntry")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest)
            
            var entries = [DiaryEntryData]()
            
            for result in fetchedResults {
                entries.append(.init(entry: result))
            }
            print("Core Data Entries: \(entries.count)")
            return entries
        } catch {
            return []
        }
    }
    
    func saveFavorites(info: [String : String], images: Data?) throws {
        let entry = FavoritesEntry(context: managedObjectContext)

        info.forEach { (key, value) in
            entry.setValue(value, forKey: key)
        }
        
        entry.setValue(Date(), forKey: "date")
        entry.setValue(images, forKey: "images")
        try saveContext()
        print("Saved Entries")
    }
    
    func getAllFavorites() -> [any FoodEntry] {
        let fetchRequest: NSFetchRequest<FavoritesEntry> = NSFetchRequest(entityName: "FavoritesEntry")

        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let fetchedResults = try managedObjectContext.fetch(fetchRequest)
            
            var entries = [DiaryEntryData]()
            
            for result in fetchedResults {
                entries.append(.init(entry: result))
            }
            print("Core Data Entries: \(entries.count)")
            return entries
        } catch {
            return []
        }
    }
    
    
}
