//
//  CoreDataList.swift
//  CheckList
//
//  Created by pioner on 24.05.2021.
//

import Foundation
import CoreData
import UIKit

class CoreDataList {
    
    static let shared = CoreDataList()
    
    private init() {}
    
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    func getAll() -> [TaskList] {
        let fetch = NSFetchRequest<TaskList>(entityName: String(describing: TaskList.self))
        fetch.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        do {
            return try context.fetch(fetch)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func add(name: String, color: UIColor? = nil) -> TaskList? {
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: TaskList.self), into: context) as? TaskList
        guard let ent = entity else {return nil}
        ent.name = name
        ent.isActive = false
        if let color = color {
            ent.color = color.encode()
        }
        ent.position = getLastPosition() + 1
        
        saveContext()
        return ent
    }
    
    func delete(list: TaskList){
        context.delete(list)
        saveContext()
    }
    
    func getListActive() -> TaskList? {
        let lists = getAll()
        var listActive: TaskList? = nil
        
        for l in lists {
            if l.isActive {
                listActive = l
                break
            }
        }
        
        if listActive == nil && lists.count > 0 {
            listActive = lists.first
            lists.first?.isActive = true
            saveContext()
        }
        
        return listActive
    }
    
    func setListActive(listActiveted: TaskList){
        let lists = getAll()
        for list in lists {
            if list == listActiveted {
                list.isActive = true
            } else {
                list.isActive = false
            }
        }
        saveContext()
    }
    
    func getLastPosition() -> Int64 {
        let lists = getAll()
        guard lists.count != 0 else {return 0}
        
        guard let lastList = lists.last else {return 0}
        
        return lastList.position
    }
    
    func moveList(from source: IndexSet, to destination: Int){
        let lists = getAll()
        
        var sourceInt: Int = 0
        let _ = source.map {
            let t = lists[$0]
            sourceInt = lists.firstIndex {$0 === t}!
        }
        
        if sourceInt < destination {
            let dest1 = destination - 1
            lists[sourceInt].position = lists[dest1].position
            for i in sourceInt...dest1 {
                if i != sourceInt {
                    lists[i].position -= 1
                }
            }
        } else {
            lists[sourceInt].position = lists[destination].position
            for i in destination...sourceInt {
                if i != sourceInt {
                    lists[i].position += 1
                }
            }
        }
        
        saveContext()
    }
    
    func editList(list: TaskList, name: String, color: UIColor? = nil){
        guard name != "" else { return }
        list.name = name
        if let color = color {
            list.color = color.encode()
        }
        saveContext()
    }
    
    func renumeratePositionList(context: NSManagedObjectContext? = nil){
        let lists = getAll()
        lists.enumerated().forEach { index, item in
            if item.position != Int64(index) {
                item.position = Int64(index)
            }
        }
        
        saveContext(context: context)
    }
    
    func checkListActiveMoreOne(context: NSManagedObjectContext? = nil){
        let lists = getAll()
        var active = false
        lists.forEach { (list) in
            if !active {
                if list.isActive {
                    active = true
                }
            } else {
                if list.isActive {
                    list.isActive = false
                }
            }
        }
        
        saveContext(context: context)
    }
    
    func  saveContext(context: NSManagedObjectContext? = nil)  {
        CoreDataStack.shared.saveContext(context: context)
    }
    
    
    
}
