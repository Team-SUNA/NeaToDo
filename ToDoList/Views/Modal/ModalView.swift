//
//  ModalView.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/29.
//

import SwiftUI
import RealmSwift

struct ModalView: View {
    @ObservedResults(Task.self) var tasks
    var taskToEdit: Task?
    @Environment(\.dismiss) private var dismiss

    // MARK: Task values
    @State var taskTitle: String = ""
    @State var taskDescription: String = ""
    @Binding var taskDate: Date
    @State var descriptionVisibility: Bool = true
    @State var isCompleted: Bool = false
    
    enum Field: Hashable {
      case taskTitle, taskDescription
    }
    
    @FocusState private var focusField: Field?


    init(taskDate: Binding<Date>, taskToEdit: Task? = nil) {
        self.taskToEdit = taskToEdit
        self._taskDate = taskDate

        if let taskToEdit = self.taskToEdit {
            _taskTitle = State(initialValue: taskToEdit.taskTitle)
            _taskDescription = State(initialValue: taskToEdit.taskDescription)
            _descriptionVisibility = State(initialValue: taskToEdit.descriptionVisibility)
            _isCompleted = State(initialValue: taskToEdit.isCompleted)
        }
    }
    


    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("title", text: $taskTitle)
                            .focused($focusField, equals: .taskTitle)
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
                        Button ("save") {
                            if let _ = taskToEdit {
                                update()
                            } else {
                                save()
                            }
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
            .onAppear {
                focusField = .taskTitle
            }
        }
    }

    private func save() {
        let task = Task()
        task.taskTitle = taskTitle
        task.taskDescription = taskDescription
        task.taskDate = taskDate
        task.descriptionVisibility = descriptionVisibility
        task.isCompleted = isCompleted
        $tasks.append(task)
    }

    private func update() {
        if let taskToEdit = taskToEdit {
            do {
                let realm = try Realm()

                guard let objectToUpdate = realm.object(ofType: Task.self, forPrimaryKey: taskToEdit.id) else { return }
                try realm.write {
                    objectToUpdate.taskTitle = taskTitle
                    objectToUpdate.taskDescription = taskDescription
                    objectToUpdate.taskDate = taskDate
                    objectToUpdate.descriptionVisibility = descriptionVisibility
                    objectToUpdate.isCompleted = isCompleted
                }
            }
            catch {
                print(error)
            }
        }
    }
}
