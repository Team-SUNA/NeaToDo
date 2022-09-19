//
//  Home.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI
import RealmSwift

struct Home: View {
    @StateObject var realmManager = RealmManager()
    
    @ObservedObject var headerViewUtil: HeaderViewUtil
    
    @State private var showModal = false
    @Namespace var animation
    @State var currentDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(headerViewUtil: headerViewUtil)
                if let tasks = realmManager.tasks.filter({ task in
                    return isSameDay(date1: task.taskDate, date2: currentDate) }),
                   let notDone = tasks.filter({task in return !task.isCompleted}),
                   let isDone = tasks.filter({task in return task.isCompleted})
                {
                    List {
                        Section {
                            ForEach(notDone) { task in
                                //                                                            if !task.isComplete {
                                TaskCardView(task: task)
                                    .onTapGesture {
                                        self.showModal = true
                                    }
                                    .swipeActions(edge: .leading) {
                                        Button (action: { realmManager.updateTask(id: task.id, completed: true)}) {
                                            Label("Done", systemImage: "checkmark")
                                        }
                                        .tint(.green)
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            withAnimation(.linear(duration: 0.4)) {
                                                //taskViewModel.deleteTask(indexSet: )
                                                print("delete")
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .sheet(isPresented: self.$showModal) {
                                        ModalView()
                                    }
                            }
                            .sheet(isPresented: self.$showModal) {
                                ModalView()  // TODO: update 하는 모달뷰로 바꿔야함
                            }
                        }
                        Section {
                            ForEach(isDone) { task in
                                //                            if !task.isComplete {
                                TaskDoneCardView(task: task)
                                    .swipeActions(edge: .leading) {
                                        Button (action: { realmManager.updateTask(id: task.id, completed: false)}) {
                                            Label("Not Done", systemImage: "xmark")
                                        }
                                        .tint(.yellow)
                                    }
                                    .onTapGesture {
                                        self.showModal = true
                                    }
                                    .swipeActions {
                                        Button(role: .destructive) {
                                            withAnimation(.linear(duration: 0.4)) {
                                                //taskViewModel.deleteTask(indexSet: )
                                                print("delete")
                                            }
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                //                            }
                            }
                            .sheet(isPresented: self.$showModal) {
                                ModalView() // TODO: update 하는 모달뷰로 바꿔야함
                            }
                        }
                    }
                    .frame(minHeight: 500)
                    .background(Color.clear)
                } else {
                    NoTaskView()
                }
            }
            .navigationTitle("TEAM SUNA")
            .navigationBarItems(trailing: NavigationLink("Calendar", destination: CalendarView(currentDate: $currentDate)
                .environmentObject(realmManager)))
        }
        .environmentObject(realmManager)
        .safeAreaInset(edge: .bottom) {
            Button {
                self.showModal = true
            } label: {
                Text("+")
                    .foregroundColor(.purple)
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: self.$showModal) {
                ModalView()
                    .environmentObject(realmManager)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .background(.ultraThinMaterial)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(headerViewUtil: HeaderViewUtil())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

