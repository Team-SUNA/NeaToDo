//
//  ModalView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/29.
//

import SwiftUI
import RealmSwift

struct UpdateModalView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realmManager: RealmManager

    // MARK: Task values
    let id: ObjectId
    @State var taskTitle: String
    @State var taskDescription: String
    @State var taskDate: Date
    @State var descriptionVisibility: Bool
    @State var isCompleted: Bool

    init(task: Task) {
        id = task.id
        _taskTitle = State(initialValue: task.taskTitle)
        _taskDescription = State(initialValue: task.taskDescription)
        _taskDate = State(initialValue: task.taskDate)
        _isCompleted = State(initialValue: task.isCompleted)
        _descriptionVisibility = State(initialValue: task.descriptionVisibility)
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("title", text: $taskTitle)
                        TextField("description", text: $taskDescription)
                        HStack {
                            Text("time")
//                            Spacer()
                            DatePicker("", selection: $taskDate)
//                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                    }
                    Section {
                        Toggle("Done", isOn: $isCompleted)
                        Toggle("display description", isOn: $descriptionVisibility)
                    } header: {
                        Text("option")
                    }
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("save") {
                            realmManager.updateTask(id: id, taskTitle, taskDescription, taskDate, descriptionVisibility, isCompleted)
                            dismiss()
                        }
                        .disabled(taskTitle == "")
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
