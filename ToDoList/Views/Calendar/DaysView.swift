//
//  DaysView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/20.
//

import SwiftUI

struct DaysView: View {
    @Binding var currentDate: Date
    @Binding var currentMonth: Int
    @EnvironmentObject var realmManager: RealmManager
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(extractDate(currentMonth)) { value in
                DayView(value: value)
                    .onTapGesture {
                        currentDate = value.date
                    }
            }
        }
        
    }
    
    @ViewBuilder
    func DayView(value: DateValue) -> some View {
        let tasks = realmManager.tasks.filter({ task in
            return isSameDay(date1: task.taskDate, date2: value.date)
        })
        
        VStack {
            if value.day != -1 {
                ZStack {
                    Circle()
                        .fill(Color(#colorLiteral(red: 0.3254901961, green: 0.1058823529, blue: 0.5764705882, alpha: 1)))
                        .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        .frame(width: 40, height: 40, alignment: .top)
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                    //                        .frame(maxWidth: .infinity)
                }
                
                if !tasks.isEmpty {
                    Circle()
                        .fill(isAllDone(tasks) ? Color(#colorLiteral(red: 0, green: 0.4931138158, blue: 0.01805076376, alpha: 1)) : Color(#colorLiteral(red: 0.8214151263, green: 0, blue: 0.2262543738, alpha: 1)))
                        .frame(width: 8, height: 8, alignment: .top)
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
    
    func extractDate(_ currentMonth: Int) -> [DateValue] {
        let calendar = Calendar.current
        // get current month date
        let currentMonth = getCurrentMonth(currentMonth)
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            // get day
            let day = calendar.component(.day, from: date)
            return DateValue(day: day, date: date)
        }
        // add offset days to get exact weekday
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        return days
    }
    
}

