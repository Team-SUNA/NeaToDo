//
//  HeaderView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct HeaderView: View {
    
    @EnvironmentObject var realmManager: RealmManager
    @Namespace var animation
    
    //저장 프로퍼티
    private let calendar: Calendar = Calendar(identifier: .gregorian)
    //저장 프로퍼티를 이용하는 연산 프로퍼티들
    private var monthDayFormatter: DateFormatter  { return DateFormatter(dateFormat: "MMMM", calendar: calendar) }
    private var dayFormatter: DateFormatter { DateFormatter(dateFormat: "d", calendar: calendar) }
    private var weekDayFormatter: DateFormatter { DateFormatter(dateFormat: "EEE", calendar: calendar) }
    @Binding var selectedDate: Date
//    private static var now = Date()
    
//    init(calendar: Calendar, selectedDate: Date) {
//        self.calendar = calendar
//        self.monthDayFormatter = DateFormatter(dateFormat: "MMMM", calendar: calendar)
//        self.dayFormatter = DateFormatter(dateFormat: "d", calendar: calendar)
//        self.weekDayFormatter = DateFormatter(dateFormat: "EEE", calendar: calendar)
//
//    }
    
    var body: some View {
        

        
        GeometryReader { geo in
            VStack {
            CalendarWeekListView(
                calendar: calendar,
                date: $selectedDate,
                content: { date in
                    let tasks = realmManager.tasks.isEmpty ? [Task]() : realmManager.tasks.filter({ task in
                        return isSameDay(date1: task.taskDate, date2: date)
                    })
                    
                    Button(action: { selectedDate = date}) {
                        VStack {
                            Text(weekDayFormatter.string(from: date))
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .padding(.bottom, 5)
                                .frame(width: geo.size.width * 1, height: geo.size.height * 0.02)
                            Text(dayFormatter.string(from: date))
                                .foregroundColor(isSameDay(date1: selectedDate, date2: date) ? .white : calendar.isDateInToday(date) ? .blue : .gray)
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
//                            if tasks.isEmpty {
//                                Circle().fill(.white)
//                            } else {
//                                Circle().fill(.purple)
//                            }
                            Circle()
//                                .fill(.white)
                                .fill(!tasks.isEmpty ? .purple : isSameDay(date1: selectedDate, date2: date) ? .black : .white)
                                .frame(width: 8, height: 8)
//                                .opacity(isSameDay(date1: selectedDate, date2: date) ? 1 : 0)
                        }
                        .foregroundStyle(isSameDay(date1: selectedDate, date2: date) ? .primary : .secondary)
                        .foregroundColor(isSameDay(date1: selectedDate, date2: date) ? .white : .black)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                        //  .foregroundColor(
                        // calendar.isDate(date, inSameDayAs: selectedDate) ? Color.black : calendar.isDateInToday(date) ? .blue : .gray
                        //
                        .frame(width: geo.size.width * 0.07, height: geo.size.height * 0.1)
                        .offset(x: -2, y: 0)
                        .background(
                            ZStack {
                                if isSameDay(date1: selectedDate, date2: date) {
                                    Capsule()
                                        .fill(.black)
                                        .frame(width: 45, height: 100)
                                        .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                }
                            }
                                .offset(x: -2, y: 0)
                        )
//                        .contentShape(Capsule())
//                        .frame(width: geo.size.width * 0.07, height: geo.size.height * 0.1)
                    }
                    .frame(width: geo.size.width * 0.07, height: geo.size.height * 0.1)
                },
                header: { date in
                        Text(weekDayFormatter.string(from: date))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(.clear)
                },
                title: { date in
                    HStack {
                        Text(monthDayFormatter.string(from: selectedDate))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                    .padding(.bottom, 6)
                },
                weekSwitcher: { date in
                    Button {
                        withAnimation {
                            guard let newDate = calendar.date(
                                byAdding: .weekOfMonth,
                                value: -1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            
                            selectedDate = newDate
                        }
                    } label: {
                        Label(
                            title: { Text("Previous") },
                            icon: { Image(systemName: "chevron.left")}
                        )
                        .labelStyle(IconOnlyLabelStyle())
                        .padding(.horizontal)
                    }
                    
                    Button {
                        withAnimation {
                            guard let newDate = calendar.date(
                                byAdding: .weekOfMonth,
                                value: 1,
                                to: selectedDate
                            ) else {
                                return
                            }
                            
                            selectedDate = newDate
                        }
                    } label: {
                        Label(
                            title: { Text("Next") },
                            icon: { Image(systemName: "chevron.right")}
                        )
                        .labelStyle(IconOnlyLabelStyle())
                        .padding(.horizontal)
                    }
                })
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 180)
    }
}

struct CalendarWeekListView<Day: View, Header: View, Title: View, WeekSwitcher: View>: View {
    private var calendar: Calendar
    @Binding private var date: Date
    private let content: (Date) -> Day
    private let header: (Date) -> Header
    private let title: (Date) -> Title
    private let weekSwitcher: (Date) -> WeekSwitcher
    
    private let daysInWeek = 7
    
    init(
        calendar: Calendar,
        date: Binding<Date>,
        @ViewBuilder content: @escaping (Date) -> Day,
        @ViewBuilder header: @escaping (Date) -> Header,
        @ViewBuilder title: @escaping (Date) -> Title,
        @ViewBuilder weekSwitcher: @escaping (Date) -> WeekSwitcher
    ) {
        self.calendar = calendar
        self._date = date
        self.content = content
        self.header = header
        self.title = title
        self.weekSwitcher = weekSwitcher
    }
    
    var body: some View {
        let month = date.startOfMonth(using: calendar)
        let days = makeDays()
        
        VStack {
            HStack {
                self.title(month)
                self.weekSwitcher(month)
            }
            HStack(spacing: 30) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
            }
            HStack(spacing: 30) {
                ForEach(days, id: \.self) { date in
                    content(date)
                }
            }
        }
    }
}

private extension CalendarWeekListView {
    func makeDays() -> [Date] {
        guard let firstWeek = calendar.dateInterval(of: .weekOfMonth, for: date),
              let lastWeek = calendar.dateInterval(of: .weekOfMonth, for: firstWeek.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: firstWeek.start, end: lastWeek.end)
        
        return calendar.generateDays(for: dateInterval)
    }
}

private extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        
        enumerateDates(startingAfter: dateInterval.start,
                       matching: components,
                       matchingPolicy: .nextTime) {
            date, _, stop in
            guard let date = date else { return }
            
            guard date < dateInterval.end else {
                stop = true
                return
            }
            dates.append(date)
        }
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(for: dateInterval, matching: dateComponents([.hour, .minute, .second], from: dateInterval.start))
    }
}

private extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}

private extension DateFormatter {
    convenience init(dateFormat: String, calendar: Calendar) {
        self.init()
        self.dateFormat = dateFormat
        self.calendar = calendar
        self.locale = Locale(identifier: "js_JP")
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//
//    @ObservedObject var headerViewUtil: HeaderViewUtil
//    @Namespace var animation
//    @Binding var currentDate: Date
//
//
//    var body: some View {
//
//        // MARK: Current Week View
//        GeometryReader { geo in
//            HStack(spacing: 10) {
//                ForEach(headerViewUtil.currentWeek, id: \.self) { day in
//                    VStack {
//
//                        Text(headerViewUtil.extractDate(date: day, format: "EEE"))
//                            .font(.system(size: 15))
//                            .fontWeight(.semibold)
//                        Text(headerViewUtil.extractDate(date: day, format: "dd"))
//                            .font(.system(size: 15))
//                            .fontWeight(.semibold)
//
//                        Circle()
//                            .fill(.white)
//                            .frame(width: 8, height: 8)
//                            .opacity(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? 1 : 0)
//                    }
//                    // MARK: Foreground Style
//                    .foregroundStyle(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? .primary : .secondary)
//
//                    .foregroundColor(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? .white : .black)
//                    // MARK: Capsule Shape
//                    //저 요일을을 가로로 꽉차게 펼치는 작업
//
////                    .frame(width: 42, height: 90)
//                    .frame(width: geo.size.width * 0.11, height: geo.size.height * 1.1)
//                    .background(
//
//                        ZStack {
//                            // MARK: Matched Geometry Effect
//                            //Week day가 변경되었을시 애니메이션 효과
//                            if isSameDay(date1: headerViewUtil.currentDay, date2: day) {
//                                Capsule()
//                                    .fill(.black)
//                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
//                            }
//                        }
//                    )
//                    .contentShape(Capsule())
//                    .onTapGesture {
//                        //Updating Current Day
//                        withAnimation {
//                            headerViewUtil.currentDay = day
//                            currentDate = day
//                        }
//                    }
//                }
//            }
//            .frame(width: geo.size.width)
////            .padding(.horizontal)
//        }
//
//    }
}
