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
            // Days
            DaysView(currentDate: $currentDate, currentMonth: $currentMonth, realmManager: _realmManager)
            // tasklist
            TaskInCalendarView(currentDate: $currentDate, realmManager: _realmManager)
                .padding()
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth(currentMonth)
        }
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

func getCurrentMonth(_ currentMonth: Int) -> Date {
    let calendar = Calendar.current
    // get current month date
    guard let currentMonth = calendar.date(byAdding: .month, value: currentMonth, to: Date()) else {
        return Date()
    }
    return currentMonth
}


struct CalendarView_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        CalendarView(currentDate: $date)
            .environmentObject(RealmManager())
    }
}
