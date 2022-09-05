//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/05/18.
//

import Foundation
import SwiftUI

class TaskViewModel: ObservableObject {
    
    @Published var tasks: [TaskModel] = [] {
        didSet {
            saveTasks()
        }
    }
    
    let tasksKey: String = "tasks_list"

    init() {
        getTasks()
        fetchCurrentWeek()
    }
    
    
    //CREATE
    func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }
    
    func addTask(title: String, description: String, date: Date, descriptionVisibility: Bool, isComplete: Bool) {
        let newTask = TaskModel(title: title, description: description, date: date, descriptionVisibility: true, isComplete: false)
        tasks.append(newTask)
    }
    
    
    //READ
    func getTasks() {
        guard
            let data = UserDefaults.standard.data(forKey: tasksKey),
            let savedTasks = try? JSONDecoder().decode([TaskModel].self, from: data)
        else { return }
        self.tasks = savedTasks
    }
    
    //UPDATE
    func updateTask(task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task.updateCompletion()
        }
    }
    
    //DELETE
    func deleteTask(indexSet: IndexSet) {
        tasks.remove(atOffsets: indexSet)
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: 날짜와 관련된 변수와 함수들
    
    // MARK: Current Week Days
    //현재 주의 날짜(일~토)를 fetch해줄 코드를 짜봅시당
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    //현재(확인중인) 날짜를 저장하는 변수. 사용자가 다른 날짜를 선택하면 update 될 것임.
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Tasks
    //사용자가 선택한 날짜에 속한 Tasks들 필터링을 위한 변수
    @Published var filteredTasks: [TaskModel]?
    
    
    // MARK: Checking if current Date is Today
    //앱이 시작되는 순간 오늘 날짜를 하이라이트해야하므로 오늘을 식별하는 함수를 하나 생성
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        
        return  calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Extracting Date
    //date를 String으로 리턴해줄  간단한 함수
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func fetchCurrentWeek() {
        
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
        
    }
    
}
