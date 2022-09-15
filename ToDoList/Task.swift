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
    @Persisted var detail: String = ""
    @Persisted var date: Date = Date()
    @Persisted var detailVisibility: Bool = true
    @Persisted var isCompleted: Bool = false
    
//    init(_ title: String) {
//        self.title = title
////        detail = ""
////        date = Date()
////        detailVisibility = true
////        isCompleted = false
//    }
//
//    init(_ title: String, _ detail: String, _ date: Date, _ detailVisibility: Bool, _ isCompleted: Bool) {
//        self.title = title
//        self.detail = detail
//        self.date = date
//        self.detailVisibility = detailVisibility
//        self.isCompleted = isCompleted
//    }
}
