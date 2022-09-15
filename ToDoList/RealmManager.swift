//
//  RealmManager.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var localRealm: Realm?
    @Published private(set) var tasks: [Task] = []
    
    init() {
        openRealm()
        getTasks()
    }
    
    func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 2)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }
    
    func addTask(_ title: String, _ detail: String, _ date: Date, _ detailVisible: Bool, _ isCompleted: Bool) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newTask = Task(value: ["title": title, "detail": detail, "date": date, "detailVisibility": detailVisible, "isCompleted": isCompleted])
                    // TODO: 시간 멋대로 찍힘
                    localRealm.add(newTask)
                    // here!!
                    getTasks()
                }
            } catch {
                print("Error add task to Realm: \(error)")
            }
        }
    }
    
    func getTasks() {
        if let localRealm = localRealm {
            let allTasks = localRealm.objects(Task.self)
            tasks = []
            allTasks.forEach { task in
                tasks.append(task)
            }
            
        }
    }
    
    func updateTask(id: ObjectId, completed: Bool) {
        if let localRealm = localRealm {
            do {
                let taskToUpdate = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !taskToUpdate.isEmpty else { return }
                try localRealm.write {
                    taskToUpdate[0].isCompleted = completed
                    getTasks()
                }
            } catch {
                print("Error update task \(id) to Realm: \(error)")
            }
        }
    }
    
    func deleteTask(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let taskToDelete = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
                guard !taskToDelete.isEmpty else { return }
                try localRealm.write {
                    localRealm.delete(taskToDelete)
                    getTasks()
                }
                
            } catch {
                print("Error deleting task \(error)")
            }
        }
    }
    
    
}
