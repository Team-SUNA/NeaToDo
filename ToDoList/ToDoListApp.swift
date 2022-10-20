//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/05/08.
//

import SwiftUI

@main
struct ToDoListApp: App {

    let migrator = Migrator()
    @State var currentDate: Date = Date()

    var body: some Scene {
        WindowGroup {
            let _ = UserDefaults.standard.set(false, forKey: "_UIConstraintsBasedLayoutUnsatisfiable")
            Home(currentDate: $currentDate)
        }
    }
}


