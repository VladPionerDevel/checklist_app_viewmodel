//
//  CoreDataTask.swift
//  CheckList
//
//  Created by pioner on 25.05.2021.
//

import Foundation
import CoreData

class CoreDataTask {
    
    static let shared = CoreDataTask()
    
    private init() {}
    
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    func getAllFromList(listActive: TaskList) -> [Task] {
        let set = listActive.task as? Set<Task> ?? []
        
        return set.sorted {
            $0.position < $1.position
        }
    }
    
    func add(name: String, list: TaskList, isCheck: Bool = false) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: Task.self), into: context) as? Task
        guard let ent = entity else {return}
        ent.name = name
        ent.isCheck = isCheck
        ent.list = list
        ent.position = getLastPosition(list: list) + 1
        
        saveContext()
    }
    
    func delete(task: Task){
        context.delete(task)
        saveContext()
    }
    
    func getLastPosition(list: TaskList) -> Int64 {
        let tasks = getAllFromList(listActive: list)
        guard tasks.count != 0 else {return 0}
        
        guard let lastTask = tasks.last else {return 0}
        
        return lastTask.position
    }
    
    func moveTask(from source: IndexSet, to destination: Int, list: TaskList){
        let tasks = getAllFromList(listActive: list)

        var sourceInt: Int = 0
        let _ = source.map {
            let t = tasks[$0]
            sourceInt = tasks.firstIndex {$0 === t}!
        }

        if sourceInt < destination {
            let dest1 = destination - 1
            tasks[sourceInt].position = tasks[dest1].position
            for i in sourceInt...dest1 {
                if i != sourceInt {
                    tasks[i].position -= 1
                }
            }
        } else {
            tasks[sourceInt].position = tasks[destination].position
            for i in destination...sourceInt {
                if i != sourceInt {
                    tasks[i].position += 1
                }
            }
        }

        saveContext()
    }
    
    func renumeratePositionTask(list: TaskList, context: NSManagedObjectContext? = nil){
        let tasks = getAllFromList(listActive: list)
        tasks.enumerated().forEach { index, item in
            if item.position != Int64(index) {
                item.position = Int64(index)
            }
        }
        
        saveContext(context: context)
    }
    
//    func moveTask(from source: IndexSet, to destination: Int, list: TaskList){
//        let tasks = getAllFromList(listActive: list)
//
//        let source = source.first!
//
//        if source < destination {
//            var startIndex = source + 1
//            let endIndex = destination - 1
//            var startOrder = tasks[source].position
//            while startIndex <= endIndex {
//                tasks[startIndex].position = startOrder
//                startOrder = startOrder + 1
//                startIndex = startIndex + 1
//            }
//
//            tasks[source].position = startOrder
//
//        } else if destination < source {
//            var startIndex = destination
//            let endIndex = source - 1
//            var startOrder = tasks[destination].position + 1
//            let newOrder = tasks[destination].position
//            while startIndex <= endIndex {
//                tasks[startIndex].position = startOrder
//                startOrder = startOrder + 1
//                startIndex = startIndex + 1
//            }
//            tasks[source].position = newOrder
//        }
//
//        saveContext()
//    }
    
    func toggleTaskCheck(task: Task) {
        task.isCheck.toggle()
        saveContext()
    }
    
    func editTask(task: Task, name: String){
        guard name != "" else { return }
        task.name = name
        saveContext()
    }
    
    func  saveContext(context: NSManagedObjectContext? = nil)  {
        CoreDataStack.shared.saveContext(context: context)
    }
}
