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
    @EnvironmentObject var realmManager: RealmManager

    var body: some View {
        List {
            if let tasks = realmManager.tasks.filter { task in
                return isSameDay(date1: task.date, date2: currentDate) && !task.isCompleted
            } {
                ForEach(tasks) { task in
                    HStack {
                        Capsule()
                            .fill(Color.black)
                            .frame(width: 5, height: 30)
                        Text(task.title)
                            .font(.system(size: 20.0, weight: .semibold))
                        Spacer()
                        // for custom timing
                        Text(task.date
                            .addingTimeInterval(CGFloat
                                .random(in: 0...5000)), style: .time)
                        .font(.system(size: 15.0))
                        
                    }
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowSeparator(.hidden)

                }
            } else {
                Text("hihi")
                    .listRowSeparator(.hidden)
            }
        }
        .frame(height: 230)
        .onAppear() {
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }
}

struct TaskInCalendarView_Previews: PreviewProvider {
    @State static var date = Date() 
    
    static var previews: some View {
        TaskInCalendarView(currentDate: $date)
            .environmentObject(RealmManager())
    }
}
