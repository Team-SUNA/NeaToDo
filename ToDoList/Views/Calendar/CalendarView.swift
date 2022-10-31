//
//  CalendarView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI
import RealmSwift

struct CalendarView: View {
    @State var currentMonth: Int
    @Binding var currentDate: Date
    @Binding var maintainCalendar : Bool

    init(currentDate: Binding<Date>, maintainCalendar: Binding<Bool>) {
        self._currentMonth = State<Int>(initialValue: getMonthDiff(currentDate.wrappedValue))
        self._currentDate = currentDate
        self._maintainCalendar = maintainCalendar
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                CalendarHeaderView(currentDate: $currentDate, currentMonth: $currentMonth)
                    .padding()
                WeekdaysView()
                DaysView(currentDate: $currentDate, oneMonth: extractDate(currentMonth), maintainCalendar: self.$maintainCalendar)
                    .padding()
                TaskInCalendarView(currentDate: $currentDate, currentMonth: $currentMonth)
                    .padding()
                //                Spacer()
            }
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

