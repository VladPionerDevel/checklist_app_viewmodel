//
//  ViewModel.swift
//  CheckList
//
//  Created by pioner on 24.05.2021.
//

import UIKit

class ViewModel: ObservableObject {
    
    let handlerList = CoreDataList()
    let handlerTask = CoreDataTask()
    
    var listActive: TaskList? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var lists: [TaskList] {
        willSet {
            objectWillChange.send()
        }
    }
    
    var tasks: [Task] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    let nameFirstList = "List"
    
    init() {
        self.lists = handlerList.getAll()
        self.listActive = handlerList.getListActive()
        self.tasks = getTasks()
        
        if self.lists.count == 0 {
            addListAndBecomeActive(name: nameFirstList)
        }
    }
    
    func addList(name: String,color: UIColor? = nil,state: Bool? = nil) -> TaskList? {
        guard name != "" else {return nil}
        
        let newList = handlerList.add(name: name,color: color)
        if let newList = newList, let state = state {
            changeStateActiveList(list: newList, state: state)
        }
        lists = handlerList.getAll()
        
        return newList ?? nil
    }
    
    func addListAndBecomeActive(name: String) {
        guard let newList = addList(name: name) else {return}
        self.setListActive(list: newList)
    }
    
    func deleteList(list: TaskList) {
        handlerList.delete(list: list)
        
        lists = handlerList.getAll()
        
        if listActive == list {
            if lists.count > 0 {
                listActive = lists.first
            } else {
                addListAndBecomeActive(name: nameFirstList)
                lists = handlerList.getAll()
            }
        }
    }
    
    func deleteList(at offset: IndexSet) {
        for index in offset {
            let list = lists[index]
            deleteList(list: list)
        }
    }
    
    func setListActive(list: TaskList) {
        handlerList.setListActive(listActiveted: list)
        self.listActive = handlerList.getListActive()
        self.tasks = getTasks()
    }
    
    func changeStateActiveList(list: TaskList, state: Bool) {
        guard list.isActive != state else { return }
        
        if state == true {
            self.setListActive(list: list)
        } else {
            guard let firstList = lists.first else { return }
            self.setListActive(list: firstList)
        }
    }
    
    func editList(list: TaskList, name: String, color: UIColor? = nil) {
        handlerList.editList(list: list, name: name, color: color)
        self.lists = handlerList.getAll()
    }
    
    
    func moveList (from source: IndexSet, to destination: Int) {
        handlerList.moveList(from: source, to: destination)
        self.lists = handlerList.getAll()
    }
    
    func addTask(name: String) {
        if name != "", let listActive = listActive {
            handlerTask.add(name: name, list: listActive)
            self.tasks = getTasks()
        }
    }
    
    func deleteTask(task: Task){
        handlerTask.delete(task: task)
        self.tasks = getTasks()
    }
    
    func deleteTask(at offset: IndexSet) {
        for index in offset {
            let task = tasks[index]
            deleteTask(task: task)
        }
    }
    
    func moveTask (from source: IndexSet, to destination: Int) {
        guard let list = listActive else { return}
        handlerTask.moveTask(from: source, to: destination, list: list)
        self.tasks = getTasks()
    }
    
    func getListsTask(list: TaskList) -> [Task] {
        return handlerTask.getAllFromList(listActive: list)
    }
    
    func toggleTaskCheck(task: Task) {
        handlerTask.toggleTaskCheck(task: task)
        self.tasks = getTasks()
    }
    
    func editTask(task: Task, name: String){
        handlerTask.editTask(task: task, name: name)
        self.tasks = getTasks()
    }
    
    func getCountPerformedTasks(list: TaskList) -> String {
        let tasks = getListsTask(list: list)
        guard tasks.count > 0 else {return "0"}
        let performed = tasks.filter{$0.isCheck}
        
        return "\(performed.count)/\(tasks.count)"
    }
    
    private func getTasks() -> [Task] {
        guard let listActive = self.listActive else {return []}
        
        return handlerTask.getAllFromList(listActive: listActive)
    }
}
