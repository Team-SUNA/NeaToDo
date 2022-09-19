//
//  CalendarView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI
import RealmSwift

struct CalendarView: View {
    @EnvironmentObject var realmManager: RealmManager
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack {
            // year, month, chevron
            CalendarHeaderView(currentDate: $currentDate, currentMonth: $currentMonth)
                .padding()
            // WeekdayView
            WeekdaysView()
            // Dates
            // lazy grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(extractDate()) { value in
                    DayView(value: value)
                        .onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            // tasklist
            TaskInCalendarView(currentDate: $currentDate, realmManager: _realmManager)
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func DayView(value: DateValue) -> some View {
        VStack {
            if value.day != -1 {
                ZStack {
                    Circle()
                        .fill(.pink)
                        .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        .frame(width: 40, height: 40, alignment: .top)
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                    //                        .frame(maxWidth: .infinity)
                }
                if let _ = realmManager.tasks.first(where:  { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                })
                {
                    Circle()
                        .fill(.green) // TODO: 전부 끝내면 회색, 할거 남았으면 연두색. 함수로 만들기
                        .frame(width: 8, height: 8, alignment: .top)
                } else {
                    Spacer()
                }
            }
        }
        .padding(.vertical, 8)
        .frame(height: 50, alignment: .top)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        // get current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        
        return currentMonth
    }
    
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        // get current month date
        let currentMonth = getCurrentMonth()
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

// extending date to get current month dates
extension Date {
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        // get start Date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: self)!
        // get date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(date1, inSameDayAs: date2)
}

struct CalendarView_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        CalendarView(currentDate: $date)
            .environmentObject(RealmManager())
    }
}
