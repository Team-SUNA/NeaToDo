//
//  CalendarView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI
import RealmSwift


let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height


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
                .padding(.bottom, 40)
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
