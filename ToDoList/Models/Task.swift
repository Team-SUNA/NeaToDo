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
    @Persisted var descriptionVisibility: Bool = true // false가 기본값인게 맞나...?
    @Persisted var isCompleted: Bool = false
}
