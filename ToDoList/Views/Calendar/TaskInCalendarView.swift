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
    var tasks: [Task] { if realmManager.tasks.isEmpty { return [Task]() } else {return realmManager.tasks.filter({ task in
        return isSameDay(date1: task.taskDate, date2: currentDate)
    })}}
    
    var body: some View {
        if !tasks.isEmpty {
            let notDoneTask = tasks.filter({ return !$0.isCompleted})
            if !notDoneTask.isEmpty {
                List {
                    ForEach(notDoneTask, id: \.self) { task in
                        if !task.isInvalidated {
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
                            .listRowSeparator(.hidden)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    realmManager.deleteTask(id: task.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
//                        HStack {
//                            Capsule()
//                                .fill(Color.black)
//                                .frame(width: 5, height: 30)
//                            Text(task.taskTitle)
//                                .font(.system(size: 20.0, weight: .semibold))
//                            Spacer()
//                            // for custom timing
//                            Text(task.taskDate, style: .time)
//                                .font(.system(size: 15.0))
//                        }
//                        .background(.white)
//                        .onTapGesture {
//                            selectedTask = task
//                        }
//                        .listRowSeparator(.hidden)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                            Button(role: .destructive) {
//                                realmManager.deleteTask(id: task.id)
//                            } label: {
//                                Label("Delete", systemImage: "trash")
//                            }
//                        }
                    }
//                    .onDelete { indexSet in
//                        realmManager.deleteTask(id: notDoneTask[indexSet.first!].id)
//                    }
                    .frame(alignment: .leading)
                    .sheet(item: $selectedTask) {
                        UpdateModalView(task: $0)
                            .environmentObject(realmManager)
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
