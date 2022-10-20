//
//  ModalView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/29.
//

import SwiftUI

struct ModalView: View {
//    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    // MARK: Task values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @Binding var taskDate: Date
    @State var descriptionVisibility: Bool = true
    @State var isCompleted: Bool = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("title", text: $taskTitle)
                        TextField("description", text: $taskDescription)
                        HStack {
                            Text("time")
                            Spacer()
                            DatePicker("", selection: $taskDate)
                                .datePickerStyle(.compact)
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
                            realmManager.addTask(taskTitle, taskDescription, taskDate, descriptionVisibility, isCompleted)
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
