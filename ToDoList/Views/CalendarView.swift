//
//  CalendarView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI

struct CalendarView: View {
    @Binding var currentDate: Date
    // month update on arrow button click
    @State var currentMonth: Int = 0

    
    var body: some View {
        VStack(spacing: 20) {
            // Days
            let days: [String] =
            ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
            
            HStack(spacing: 20) {
                Text(extraDate()[0])
                    .font(.system(size: 20))
                Spacer()
                Text(extraDate()[1].uppercased())
                    .font(.system(size: 40, weight: .bold))
                Spacer(minLength: 0)
                Button {
                    currentMonth -= 1
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button {
                    currentMonth += 1
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            // DayView
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    if day == "SUN" {
                        dayText(text: day).foregroundColor(.red)
                    } else if day == "SAT" {
                        dayText(text: day).foregroundColor(.blue)
                    } else {
                        dayText(text: day)
                    }
                }
            }
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
            Spacer()
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    if let task = tasks.first(where: { task in
                        return isSameDay(date1: task.taskDate, date2: currentDate)
                    }) {
                        ForEach(task.task) { task in
                            HStack {
                                Capsule()
                                    .fill(Color.black)
                                    .frame(width: 5, height: 30)
                                Text(task.title)
                                    .font(.system(size: 20.0, weight: .semibold))
                                Spacer()
                                // for custom timing
                                Text(task.date
                                    .addingTimeInterval(CGFloat
                                        .random(in: 0...5000)), style: .time)
                                .font(.system(size: 15.0))
                                
                            }
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        Text("hihi")
                    }
                }
                .padding()
            }
            .frame(height: 230)
        }
        .onChange(of: currentMonth) { newValue in
            // update month
            currentDate = getCurrentMonth()
        }
    }
    
    func dayText(text: String) -> some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
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
                if let _ = tasks.first(where:  { task in
                    return isSameDay(date1: task.taskDate, date2: value.date)
                }) {
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
    
    // check dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // extract year month for display
    func extraDate() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")
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
