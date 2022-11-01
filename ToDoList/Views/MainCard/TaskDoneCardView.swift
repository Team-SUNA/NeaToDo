//
//  TaskCardView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.ㅌ
//

import SwiftUI
import RealmSwift

struct TaskDoneCardView: View {
    
    let task: Task
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
                Rectangle()
//                    .fill(.black)
                .fill(Color.accentGreen)
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
                .offset(x: 0, y: 8)
            }
            .padding()
            .hLeading()
        }
        .hLeading()
        .background(Color.cardColor)
    }
}
