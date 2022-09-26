//
//  CalendarViewUtil.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/26.
//

import Foundation
import RealmSwift

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
