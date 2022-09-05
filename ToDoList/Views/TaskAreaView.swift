//
//  TaskAreaView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct TaskAreaView: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        LazyVStack(spacing: 18) {
            if let tasks = taskViewModel.filteredTasks {
                if tasks.isEmpty {
                    Text("NO TASKS !")
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .offset(y: 100)
                } else {
                    ForEach(tasks) { task in
                        TaskCardView(task: task)
                    }
                }
            }
            else {
                // MARK: Progress View
                ProgressView()
                    .offset(y: 100)
            }
        }
        .padding()
        .padding(.top)
        // MARK: Updating Tasks
        .onChange(of: taskViewModel.currentDay) { newValue in
            taskViewModel.filterTodayTasks()
        }
        
    }
}

struct TaskAreaView_Previews: PreviewProvider {
    static var previews: some View {
        TaskAreaView()
    }
}
