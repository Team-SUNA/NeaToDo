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
            DaysView(currentDate: $currentDate, currentMonth: $currentMonth)
                .padding(.bottom, 40)
            TaskInCalendarView(currentDate: $currentDate)
                .padding()
            Spacer()
        }
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth(currentMonth)
        }
    }
}
