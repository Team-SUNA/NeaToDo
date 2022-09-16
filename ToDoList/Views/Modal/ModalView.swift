//
//  ModalView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/29.
//

import SwiftUI

struct ModalView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var realmManager: RealmManager
    
    //if let으로 초기화를 해서 모델이 하나 들어올 시 해당 모델의 값으로 변수들을 초기화, 그렇지 않다면 그냥 기본값으로 초기화
    
    
    // MARK: Task values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @State var taskDate: Date = Date()
    @State var isCompleted: Bool = false
    @State var descriptionVisibility: Bool = true
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("task", text: $taskTitle)
                        TextField("description", text: $taskDescription)
                        HStack {
                            Text("time")
                            Spacer()
                            DatePicker("", selection: $taskDate)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                    } header: {
                        Text("Task")
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

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}