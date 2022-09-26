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
        return isSameDay(date1: task.taskDate, date2: currentDate) && !task.isCompleted
    })}
    

    var body: some View {
        if !tasks.isEmpty {
            ScrollView {
                ForEach(tasks, id: \.self) { task in
                    HStack {
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 2.5, height: 30)
                            .padding(.trailing, 20)
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
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .sheet(item: $selectedTask) {
                    UpdateModalView(task: $0)
                                .environmentObject(realmManager)
                }
            }
        } else {
            Text("NO TASK TO DO")
        }
    }
}
