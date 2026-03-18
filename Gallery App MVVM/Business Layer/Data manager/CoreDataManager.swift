//  CoreDataManager.swift

import CoreData
import Foundation

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Gallery_App_MVVM")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("FATAL ERROR: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("ERROR: \(error)")
        }
    }
}
