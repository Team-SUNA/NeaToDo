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
                    .fill(.black)
                    .frame(width: 3)
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text(task.taskTitle)
                            .font(.title2.bold())
                        if task.descriptionVisibility && !task.taskDescription.isEmpty {
                            Text(task.taskDescription)
                                .foregroundStyle(.secondary)
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
        .background(Color(#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)))
    }
}

struct TaskDoneCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        let sampleTask = Task(value: ["test"])
        
        TaskDoneCardView(task: sampleTask)
    }
}
