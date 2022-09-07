//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/05/08.
//

import SwiftUI

@main
struct ToDoListApp: App {
    
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    
    
    var body: some Scene {
        WindowGroup {
                Home()
                .environmentObject(taskViewModel)
        }
    }
}

