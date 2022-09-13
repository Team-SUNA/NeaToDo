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
    @Persisted var title: String
    @Persisted var details: String = ""
    @Persisted var date: Date = Date()
    @Persisted var descriptionVisibility: Bool = true
    @Persisted var isComplete: Bool = false
}
