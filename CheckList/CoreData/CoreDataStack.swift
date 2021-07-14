//
//  CoreDataStack.swift
//  CheckList
//
//  Created by pioner on 21.05.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CheckList")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("No Descriptions found")
        }
        
        description.setOption(true as NSObject, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        NotificationCenter.default.addObserver(self, selector: #selector(processUpdate), name: .NSPersistentStoreRemoteChange, object: nil)
        
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext (context: NSManagedObjectContext? = nil) {
        let cont = context ?? persistentContainer.viewContext
        if cont.hasChanges {
            do {
                try cont.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc
    func processUpdate(notification: NSNotification) {
        operationQueue.addOperation {
            
            let context = self.persistentContainer.newBackgroundContext()
            context.performAndWait {
                
                DispatchQueue.main.async {
                    ViewModel.shared.renumeratePositionTask(context: context)
                    ViewModel.shared.renumeratePositionList(context: context)
                    ViewModel.shared.checkListActiveMoreOne(context: context)
                    
                    ViewModel.shared.updateViewLists()
                    ViewModel.shared.updateViewListActive()
                    ViewModel.shared.updateViewTasks()
                }
            }
            
        }
    }
    
    
    lazy var operationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}
