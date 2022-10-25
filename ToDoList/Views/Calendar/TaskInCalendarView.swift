//
//  TaskInCalendarView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import SwiftUI
import RealmSwift

struct TaskInCalendarView: View {
    @ObservedResults(Task.self) var tasks
    @Binding var currentDate: Date
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        let todayTask = tasks.filter{ isSameDay(date1: $0.taskDate, date2: currentDate) }
        let notDoneTask = Array(todayTask.filter{ $0.isCompleted == false })
        if !todayTask.isEmpty {
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
                                Text(task.taskDate, style: .time)
                                    .font(.system(size: 15.0))
                            }
                            .background(.white)
                            .onTapGesture {
                                selectedTask = task
                            }
                            .listRowSeparator(.hidden)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .swipeActions(edge: .trailing) {
                                Button {
                                    deleteRow(task: task)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .frame(alignment: .leading)
                    .sheet(item: $selectedTask) { item in
                        ModalView(taskDate: $currentDate, taskToEdit: item)
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

    private func deleteRow(task: Task){
        do {
            let realm = try Realm()

            guard let objectToDelete = realm.object(ofType: Task.self, forPrimaryKey: task.id) else { return }
            try realm.write {
                realm.delete(objectToDelete)
            }
        }
        catch {
            print(error)
        }
    }
    
}
