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
            let config = Realm.Configuration(schemaVersion: 3)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
        } catch {
            print("Error opening Realm: \(error)")
        }
    }

    func addTask(_ taskTitle: String, _ taskDescription: String, _ taskDate: Date, _ descriptionVisibility: Bool, _ isCompleted: Bool) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let newTask = Task(value: ["taskTitle": taskTitle, "taskDescription": taskDescription,
                                               "taskDate": taskDate, "descriptionVisibility": descriptionVisibility, "isCompleted": isCompleted])
                    localRealm.add(newTask)
                    getTasks()
                }
            } catch {
                print("Error add task to Realm: \(error)")
            }
        }
    }

    func getTasks() {
        if let localRealm = localRealm {
            tasks = Array(localRealm.objects(Task.self))
        }
    }

    func updateTask(id: ObjectId, _ taskTitle: String, _ taskDescription: String, _ taskDate: Date, _ descriptionVisibility: Bool, _ isCompleted: Bool) {
        if let localRealm = localRealm {
            do {
                if let taskToUpdate = localRealm.objects(Task.self).filter("id = %@", id).first {
                    try localRealm.write {
                        taskToUpdate.taskTitle = taskTitle
                        taskToUpdate.taskDescription = taskDescription
                        taskToUpdate.taskDate = taskDate
                        taskToUpdate.descriptionVisibility = descriptionVisibility
                        taskToUpdate.isCompleted = isCompleted
                        getTasks()
                    }
                }
            } catch {
                print("Error update task \(id) to Realm: \(error)")
            }
        }
    }

    func deleteTask(id: ObjectId) {
        if let localRealm = localRealm {
            do {
                let taskToDelete = localRealm.objects(Task.self).filter("id = %@", id)
                guard !taskToDelete.isEmpty else { return }
                try localRealm.write {
                    localRealm.delete(taskToDelete.first!)
                    getTasks()
                }
            } catch {
                print("--------------------------------Error deleting task \(error)")
            }
        }
    }

    // 날짜 받아서 task 보내주는 함수 만들기
    func taskForToday(currentDate: Date) -> [Task] {
        return tasks.filter({ return isSameDay(date1: $0.taskDate, date2: currentDate)})
    }

}
