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
    @State var title: String = ""
    @State var detail: String = ""
    @State var date: Date = Date()
    @State var isCompleted: Bool = false
    @State var detailVisible: Bool = true
    
    var body: some View {
        
        NavigationView {
            VStack {
                List {
                    Section {
                        TextField("task", text: $title)
                        TextField("description", text: $detail)
                        HStack {
                            Text("time")
                            Spacer()
                            DatePicker("", selection: $date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                        }
                    } header: {
                        Text("Task")
                    }
                    Section {
                        Toggle("Done", isOn: $isCompleted)
                        Toggle("display description", isOn: $detailVisible)
                    } header: {
                        Text("option")
                    }
                }
                .listStyle(.grouped)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("save") {
                            realmManager.addTask(title, detail, date, detailVisible, isCompleted)
                            dismiss()
                        }
                        .disabled(title == "")
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
