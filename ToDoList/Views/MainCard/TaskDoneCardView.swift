//
//  TaskCardView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI
import RealmSwift

struct TaskDoneCardView: View {
    
    let task: Task
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
                Rectangle()
//                    .fill(.black)
                .fill(Color(#colorLiteral(red: 0, green: 0.4931138158, blue: 0.01805076376, alpha: 1)))
                    .frame(width: 3)
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                            .foregroundColor(Color.textColor)
                        if task.descriptionVisibility && !task.taskDescription.isEmpty {
                            Text(task.taskDescription)
                                .foregroundStyle(.secondary)
                                .foregroundColor(Color.textColor)
                        }
                    }
                    .hLeading()
                    Text(task.taskDate.formatted(date: .omitted, time: .shortened))
                }
            }
            .padding()
            .hLeading()
        }
        .hLeading()
        .background(Color.cardColor)
    }
}
