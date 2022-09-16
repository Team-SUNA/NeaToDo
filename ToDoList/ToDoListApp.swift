//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/05/08.
//

import SwiftUI

@main
struct ToDoListApp: App {
    var body: some Scene {
        WindowGroup {
                Home(headerViewUtil: HeaderViewUtil())
        }
    }
}

