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
    @State private var showModal = false
    @EnvironmentObject var realmManager: RealmManager
    var tasks: [Task] { return realmManager.tasks.filter({ task in
        return isSameDay(date1: task.taskDate, date2: currentDate) && !task.isCompleted
    })}
    

    var body: some View {
        if !tasks.isEmpty {
            ScrollView {
                ForEach(tasks) { task in
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
                    .background(.white) // 클릭위해서
                    .onTapGesture {
                        showModal = true
                    }
                    .sheet(isPresented: $showModal) {
                        ModalView() // TODO: update 하는 모달뷰로 바꿔야함
                    }
                    .frame(maxWidth: .infinity, maxHeight: 30, alignment: .leading)
                }
            }
        }
        else { // TODO: 아예 없는 날이랑, 있는데 다 한 날이랑 구분해서 문구 쓸지?
            Text("NO TASK TO DO")
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
