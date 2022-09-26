//
//  Task.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var taskTitle: String
    @Persisted var taskDescription: String = ""
    @Persisted var taskDate: Date = Date()
    @Persisted var descriptionVisibility: Bool = true
    @Persisted var isCompleted: Bool = false
}
