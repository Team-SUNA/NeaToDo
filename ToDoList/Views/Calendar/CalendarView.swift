//
//  CalendarView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI
import RealmSwift

struct CalendarView: View {
    @Binding var currentDate: Date
    @State var currentMonth: Int = 0
    
    var body: some View {
//        Text("test")
        VStack {
            CalendarHeaderView(currentDate: $currentDate, currentMonth: $currentMonth)
                .padding()
            WeekdaysView()
            DaysView(currentDate: $currentDate, oneMonth: extractDate(currentMonth))
                .padding(.bottom, 30)
            TaskInCalendarView(currentDate: $currentDate)
                .padding()
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth(currentMonth)
        }
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
