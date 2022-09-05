//
//  ItemModel.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/05/14.
//

import Foundation

//Immutable Struct
//멤버 필드가 다 let임


// Total Task meta view
struct TaskMetaData: Identifiable {
    var id = UUID().uuidString
    var task: [TaskModel]
    var taskDate: Date
}

var tasks: [TaskMetaData] = [
    TaskMetaData(task: [TaskModel(title: "test1", description: "descrip1"),
                        TaskModel(title: "test2", description: "descrip11"),
                        TaskModel(title: "test3", description: "descrip12"),
                        TaskModel(title: "test4", description: "descrip12"),
                        TaskModel(title: "test5", description: "descrip12"),
                        TaskModel(title: "test6", description: "descrip12")],
                 taskDate: getSampleDate(offset: 0)),
//    TaskMetaData(task: [Task(title: "test11", description: "descrip11")], taskDate: getSampleDate(offset: 0)),
//    TaskMetaData(task: [Task(title: "test12", description: "descrip12")], taskDate: getSampleDate(offset: 0)),
    TaskMetaData(task: [TaskModel(title: "test1", description: "descrip1")], taskDate: getSampleDate(offset: -3)),
    TaskMetaData(task: [TaskModel(title: "test2", description: "descrip2")], taskDate: getSampleDate(offset: -8)),
    TaskMetaData(task: [TaskModel(title: "test3", description: "descrip3")], taskDate: getSampleDate(offset: 10)),
    TaskMetaData(task: [TaskModel(title: "test4", description: "descrip4")], taskDate: getSampleDate(offset: -22)),
    TaskMetaData(task: [TaskModel(title: "test5", description: "descrip5")], taskDate: getSampleDate(offset: 15)),
    TaskMetaData(task: [TaskModel(title: "test6", description: "descrip6")], taskDate: getSampleDate(offset: -20)),
]

// sample date for testing
func getSampleDate(offset: Int) -> Date {
    let calendar = Calendar.current
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    return date ?? Date()
}



struct TaskModel: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var title: String
    var description: String = ""
    var date: Date = Date()
    var descriptionVisibility: Bool = true
    var isComplete: Bool = false

    
    //모델 안의 이 펑션이 아니면 모델의 필드를 변경할 수 없음
    
    //필드 isComplete을 업데이트하는 함수
    func updateCompletion() -> TaskModel {
        return TaskModel(id: id, title: title, description: description, date: date, descriptionVisibility: descriptionVisibility, isComplete: !isComplete)
    }
    
    //필드 descriptionVisibility를 업데이트하는 함수
    func updateDescriptionVisibility() -> TaskModel {
        return TaskModel(id: id, title: title, description: description, date: date, descriptionVisibility: !descriptionVisibility, isComplete: isComplete)
    }
    
}
