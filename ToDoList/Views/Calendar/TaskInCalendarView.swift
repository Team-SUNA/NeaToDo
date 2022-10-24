//
//  TaskInCalendarView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import SwiftUI
import RealmSwift

struct TaskInCalendarView: View {
    @ObservedResults(Task.self, filter: NSPredicate(format: "isCompleted == false")) var notDoneTask
    @Binding var currentDate: Date
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        if true {
            if !notDoneTask.filter("taskDate == %@", currentDate).isEmpty {
                List {
                    ForEach(notDoneTask.filter("taskDate == %@", currentDate), id: \.self) { task in
                        if !task.isInvalidated {
                            HStack {
                                Capsule()
                                    .fill(Color.black)
                                    .frame(width: 5, height: 30)
                                Text(task.taskTitle)
                                    .font(.system(size: 20.0, weight: .semibold))
                                Spacer()
                                Text(task.taskDate, style: .time)
                                    .font(.system(size: 15.0))
                            }
                            .background(.white)
                            .onTapGesture {
                                selectedTask = task
                            }
                            .listRowSeparator(.hidden)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .onDelete(perform: $notDoneTask.remove)
                    .frame(alignment: .leading)
                    .sheet(item: $selectedTask) { _ in 
                        ModalView(taskDate: $currentDate, taskToEdit: selectedTask)
                    }
                }
                .listStyle(.plain)

            } else {
                Text("WELL DONE")
            }
        } else {
            Text("NO TASK TO DO")
        }
    }
}
