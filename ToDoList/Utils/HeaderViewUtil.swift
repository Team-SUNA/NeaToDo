//
//  HeaderViewUtil.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/16.
//
import Foundation
import SwiftUI

class HeaderViewUtil: ObservableObject {
    
    @Published var tasks: [Task] = []

    init() {
        filterTodayTasks()
    }

    // MARK: Current Week Days
    //현재 주의 날짜(일~토)를 fetch해줄 코드를 짜봅시당
    @Published var currentWeek: [Date] = []

    // MARK: Current Day
    //현재(확인중인) 날짜를 저장하는 변수. 사용자가 다른 날짜를 선택하면 update 될 것임.
    @Published var currentDay: Date = Date()

    // MARK: Filtering Today Tasks
    //사용자가 선택한 날짜에 속한 Tasks들 필터링을 위한 변수
    @Published var filteredTasks: [Task]?
    

    // MARK: Filter Today Tasks
    func filterTodayTasks() {

        DispatchQueue.global(qos: .userInteractive).async {

            let calendar = Calendar.current

            let filtered = self.tasks.filter {
                return  calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }

            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
}
