//
//  TaskCardView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct TaskDoneCardView: View {
    
    let task: TaskModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10) {
                Rectangle()
                    .fill(.black)
                    .frame(width: 3)
                        
                
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.title)
                            .font(.title2.bold())
                        Text(task.description)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    
                    Text(task.date.formatted(date: .omitted, time: .shortened))

                }
            }
            .padding()
            .hLeading()
            .background(
                Color("Black")
                    .cornerRadius(25)
            
            )
        }
        .hLeading()
        .background(.gray)

    }
}

struct TaskDoneCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        var sampleTask = TaskModel(title: "sample task", description: "let me test this", date: Date(), descriptionVisibility: true, isComplete: false)
        
        TaskDoneCardView(task: sampleTask)
    }
}
