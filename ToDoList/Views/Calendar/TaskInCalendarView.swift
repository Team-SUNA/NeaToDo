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
    @Binding var currentMonth: Int
    @State private var selectedTask: Task? = nil
    
    var body: some View {
        let todayTask = tasks.filter{ getMonthDiff(currentDate) == currentMonth && isSameDay(date1: $0.taskDate, date2: currentDate) }
        let notDoneTask = Array(todayTask.filter{ $0.isCompleted == false })
        GeometryReader { geo in
            if !todayTask.isEmpty {
                if !notDoneTask.isEmpty {
                    List {
                        ForEach(notDoneTask, id: \.self) { task in
                            if !task.isInvalidated {
                                HStack {
                                    Rectangle()
                                        .fill(Color.black)
                                        .frame(width: 3, height: geo.size.height * 0.25)
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
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        updateIsCompleted(task)
                                    } label: {
                                        Label("Done", systemImage: "checkmark")
                                    }
                                    .tint(.green)
                                }
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
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(x: 0, y: geo.size.width * 0.07)
                        .font(.system(size: geo.size.width * 0.05))
                }
            } else {
                Text("NO TASK TO DO")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: 0, y: geo.size.width * 0.07)
                    .font(.system(size: geo.size.width * 0.05))
            }
        }

    }

    private func updateIsCompleted(_ task: Task) {
        do {
            let realm = try Realm()
            
            guard let objectToUpdate = realm.object(ofType: Task.self, forPrimaryKey: task.id) else { return }
            try realm.write {
                objectToUpdate.isCompleted = !objectToUpdate.isCompleted
            }
        }
        catch {
            print(error)
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
