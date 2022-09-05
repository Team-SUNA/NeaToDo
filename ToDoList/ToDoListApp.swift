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
            NavigationView {
                Home()
            }
            .navigationViewStyle(StackNavigationViewStyle())
            //NavigationView안의 모든 다른 뷰들도 listViewModel에 접근할 수 있다
            .environmentObject(taskViewModel)
        }
    }
}

