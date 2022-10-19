//
//  Home.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI
import RealmSwift

struct Home: View {
    @EnvironmentObject var realmManager: RealmManager
    @State private var showModal = false
    @State private var selectedTask: Task? = nil
    @Namespace var animation // TODO: 애니메이션 좀 과한 느낌... 줄이거나 없애면 어떨까여
    @State var currentDate: Date = Date()
    //    @State private var notDone = [Task]()
    //    @State private var isDone = [Task]()
        var tasks: [Task] {
                return realmManager.tasks.filter({ return isSameDay(date1: $0.taskDate, date2: currentDate)})
            }


    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    HeaderView(selectedDate: $currentDate)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    //                        .frame(width: geo.size.width, height: geo.size.height * 0.24)
                    //                        .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.1)
                        .environmentObject(realmManager)
                    if !tasks.isEmpty
                    {
                        var notDone = tasks.filter({ return !$0.isCompleted})
//                        let isDone = tasks.filter({ return $0.isCompleted})
                        List {
//                            Section {
                                ForEach(notDone, id: \.id) { task in
                                    if !task.isInvalidated {
                                        TaskCardView(task: task)
                                            .listRowSeparator(.hidden)
                                            .onTapGesture {
                                                selectedTask = task
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button {
                                                    realmManager.updateTask(id: task.id, task.taskTitle, task.taskDescription, task.taskDate, task.descriptionVisibility, true)}  label: {
                                                        Label("Done", systemImage: "checkmark")
                                                    }
                                                    .tint(.green)
                                            }
                                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                                Button(role: .destructive) {
                                                                                                        notDone.removeAll(where: {$0.id == task.id})
                                                    realmManager.deleteTask(id: task.id)
                                                } label: {
                                                    Label("Delete", systemImage: "trash")
                                                }
                                            }
                                    }

                                }
                                //                                .onDelete { indexSet in
                                //                                    realmManager.deleteTask(id: notDone[indexSet.first!].id)
                                //                                }
//                            }
//                            Section {
//                                ForEach(isDone, id: \.id) { task in
//                                    //                                ForEach(realmManager.tasks.filter({ return isSameDay(date1: $0.taskDate, date2: currentDate)}).filter({ return $0.isCompleted}), id: \.id) { task in
//                                    if !task.isInvalidated {
//                                        TaskDoneCardView(task: task)
//                                            .listRowSeparator(.hidden)
//                                            .swipeActions(edge: .leading) {
//                                                Button {
//                                                    realmManager.updateTask(id: task.id, task.taskTitle, task.taskDescription, task.taskDate, task.descriptionVisibility, false)} label: {
//                                                        Label("Not Done", systemImage: "xmark")
//                                                    }
//                                                    .tint(.yellow)
//                                            }
//                                            .onTapGesture {
//                                                selectedTask = task
//                                            }
//                                            .swipeActions(edge: .trailing) {
//                                                Button(role: .destructive) {
//                                                    //                                                    isDone.removeAll(where: {$0.id == task.id})
//                                                    realmManager.deleteTask(id: task.id)
//                                                } label: {
//                                                    Label("Delete", systemImage: "trash")
//                                                }
//                                            }
//                                    }
//
//                                }
//                                //                                .onDelete { indexSet in
//                                //                                    realmManager.deleteTask(id: isDone[indexSet.first!].id)
//                                //                                }
//                            }
                        }
                        .sheet(item: $selectedTask) {
                            UpdateModalView(task: $0)
                                .environmentObject(realmManager)
                        }
                        //                        .frame(minHeight: 500)
                        .background(Color.clear)
                        .onAppear() {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                        .listRowSeparator(.hidden)
                        .listStyle(.plain)
                    } else {
                        NoTaskView()
                            .frame(alignment: .center)
                        Spacer()
                    }
                    Spacer()
                }
                //                .navigationTitle("TEAM SUNA")
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: CalendarView(currentDate: $currentDate)
                    .environmentObject(realmManager)) {
                        Image(systemName: "calendar")
                    })
            }
            
        }
        //        .navigationViewStyle(.stack)
        // TODO: 이거였다고.....?
        //        .environmentObject(realmManager)
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
                    .environmentObject(realmManager)
            }
        }
    }
}
//
//struct Home_Previews: PreviewProvider {
//    static var previews: some View {
//        Home()
//    }
//}

