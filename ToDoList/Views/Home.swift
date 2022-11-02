//
//  Home.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI
import RealmSwift

struct Home: View {
    @State private var showModal = false
    @State private var selectedTask: Task? = nil
    @Namespace var animation // TODO: 애니메이션 좀 과한 느낌... 줄이거나 없애면 어떨까여
    @State var currentDate = Date()
    
    @ObservedResults(Task.self) var tasks
    
    
    @State var maintainCalendar : Bool = false

    
    var body: some View {
        let todayTasks = tasks.filter{ isSameDay(date1: $0.taskDate, date2: currentDate) }
        let notDone = Array(todayTasks.filter{ $0.isCompleted == false })
        let isDone =  Array(todayTasks.filter{ $0.isCompleted == true })
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HeaderView(selectedDate: $currentDate)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    if !todayTasks.isEmpty {
                        List {
//                            Text("TO DO")
//                                .font(.system(size: 23, weight: .bold))
//                                .listRowSeparator(.hidden)
//                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                            Section {
                                ForEach(notDone.sorted(by: { $0.taskDate < $1.taskDate }), id: \.id) { task in
                                    if !task.isInvalidated {
                                        TaskCardView(task: task)
                                            .listRowSeparator(.hidden)
                                            .onTapGesture { selectedTask = task }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    updateIsCompleted(task)
                                                } label: {
                                                    Label("Done", systemImage: "checkmark")
                                                }
                                                .tint(.green)
                                            }
                                            .swipeActions(edge: .trailing) {
                                                Button {
                                                    deleteRow(task: task)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            }
                                    }
                                }
                            }
                            Spacer()
                                .listRowSeparator(.hidden)
//                            Text("Done")
//                                .font(.system(size: 23, weight: .bold))
//                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
//                                .listRowSeparator(.hidden)
                            Section {
                                ForEach(isDone.sorted(by: { $0.taskDate < $1.taskDate }), id: \.id) { task in
                                    if !task.isInvalidated {
                                        TaskDoneCardView(task: task)
                                            .listRowSeparator(.hidden)
                                            .onTapGesture { selectedTask = task }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    updateIsCompleted(task)
                                                } label: {
                                                    Label("Not Done", systemImage: "xmark")
                                                }
                                                .tint(.yellow)
                                            }
                                            .swipeActions(edge: .trailing) {
                                                Button {
                                                    deleteRow(task: task)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                                .tint(.red)
                                            }
                                    }
                                }
                            }
                        }
                        .sheet(item: $selectedTask) { item in
                            ModalView(taskDate: $currentDate, taskToEdit: item)
                        }
                        .background(Color.reverseTextColor)
                        .onAppear() {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        .listStyle(.plain)
                        
                    } else {
                        NoTaskView()
                            .frame(alignment: .center)
                        Spacer()
                    }
                    Spacer()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(
                    destination: CalendarView(currentDate: $currentDate, maintainCalendar: self.$maintainCalendar),
                    isActive: self.$maintainCalendar
                ) {
                    Image(systemName: "calendar")
                })
            }
        }
        .safeAreaInset(edge: .bottom, alignment: .center) {
            Button {
                showModal = true
            } label: {
                Image(systemName: "plus.circle")
                    .foregroundColor(Color(#colorLiteral(red: 0.3254901961, green: 0.1058823529, blue: 0.5764705882, alpha: 1)))
                    .font(.largeTitle)
            }
            .sheet(isPresented: $showModal) {
                ModalView(taskDate: $currentDate)
            }
        }
    }
    
    private func updateIsCompleted(_ task: Task) {
        do {
            let realm = try Realm()
            
            guard let objectToUpdate = realm.object(ofType: Task.self, forPrimaryKey: task.id) else { return }
            try realm.write {
                objectToUpdate.isCompleted = !objectToUpdate.isCompleted
            }
        }
        catch {
            print(error)
        }
    }
    
    private func deleteRow(task: Task){
        do {
            let realm = try Realm()
            
            guard let objectToDelete = realm.object(ofType: Task.self, forPrimaryKey: task.id) else { return }
            try realm.write {
                realm.delete(objectToDelete)
            }
        }
        catch {
            print(error)
        }
    }
}
