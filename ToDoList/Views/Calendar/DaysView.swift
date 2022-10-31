//
//  DaysView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/20.
//

import SwiftUI
import RealmSwift

struct DaysView: View {
    @ObservedResults(Task.self) var tasks
    @Binding var currentDate: Date
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var oneMonth: [DateValue]
    
    @Binding var maintainCalendar : Bool
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(oneMonth) { value in
                DayView(value: value)
                    .gesture(TapGesture(count: 2).onEnded {
                        self.maintainCalendar = false
                    })
                    .simultaneousGesture(TapGesture().onEnded {
                        currentDate = value.date
                    })
            }
        }
    }

    func DayView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        .frame(width: 40, height: 40, alignment: .top)
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : isSameDay(date1: Date(), date2: value.date) ? .blue : .primary)
                }
                let todayTask = tasks.filter{ isSameDay(date1: $0.taskDate, date2: value.date) }
                if !todayTask.isEmpty {
                    Circle()
                        .fill(isAllDone(Array(todayTask)) ? Color.accentGreen : Color.accentYellow)
                        .frame(width: 8, height: 8, alignment: .top)
                        .padding(EdgeInsets(top: -13, leading: 0, bottom: 0, trailing: 0))
                        .offset(x: 1.2, y: 0)
                } else {
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 50, alignment: .top)
    }
    
    func isAllDone(_ tasks: [Task]) -> Bool {
        for task in tasks {
            if !task.isCompleted {
                return false
            }
        }
        return true
    }
}
