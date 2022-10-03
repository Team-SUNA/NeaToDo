//
//  TaskInCalendarView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import SwiftUI
import RealmSwift

struct TaskInCalendarView: View {
    @Binding var currentDate: Date
    @State private var selectedTask: Task? = nil
    @EnvironmentObject var realmManager: RealmManager
    var tasks: [Task] { return realmManager.tasks.filter({ task in
        return isSameDay(date1: task.taskDate, date2: currentDate)
    })}
    
    var body: some View {
        if !tasks.isEmpty {
            let notDoneTask = tasks.filter({ task in return !task.isCompleted})
            if !notDoneTask.isEmpty {
//                ScrollView {
                List {
                    ForEach(notDoneTask, id: \.self) { task in
                        HStack {
                            Capsule()
                                .fill(Color.black)
                                .frame(width: 5, height: 30)
                            Text(task.taskTitle)
                                .font(.system(size: 20.0, weight: .semibold))
                            Spacer()
                            // for custom timing
                            Text(task.taskDate, style: .time)
                                .font(.system(size: 15.0))
                        }
                        .background(.white)
                        .onTapGesture {
                            selectedTask = task
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .swipeActions {
                            Button(role: .destructive) {
                                realmManager.deleteTask(id: task.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .sheet(item: $selectedTask) {
                        UpdateModalView(task: $0)
                            .environmentObject(realmManager)
                    }
                }
            } else {
                Text("WELL DONE")
            }
        } else {
            Text("NO TASK TO DO")
        }
    }
}
