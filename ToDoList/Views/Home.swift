//
//  Home.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct Home: View {
    @StateObject var realmManager = RealmManager()
    @State private var showModal = false
    @Namespace var animation
    @State var currentDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
//                if let filtered = taskViewModel.filteredTasks {
//                    if filtered.isEmpty {
//                        NoTaskView()
//                    }
//                    else {
//                        List {
//                            Section {
//                                ForEach(filtered) { task in
//                                    if !task.isComplete {
//                                        TaskCardView(task: task)
//                                            .swipeActions(edge: .leading) {
//                                                Button (action: { taskViewModel.updateTaskCompletion(task: task) }) {
//                                                    Label("Done", systemImage: "checkmark")
//                                                }
//                                                .tint(.green)
//                                            }
//
//                                            .onTapGesture {
//                                                self.showModal = true
//                                            }
//                                            .swipeActions {
//                                                Button(role: .destructive) {
//                                                    withAnimation(.linear(duration: 0.4)) {
//                                                        //taskViewModel.deleteTask(indexSet: )
//                                                        print("delete")
//                                                    }
//                                                } label: {
//                                                    Label("Delete", systemImage: "trash")
//                                                }
//                                            }
//                                    }
//                                }
//
//                                .sheet(isPresented: self.$showModal) {
//                                    ModalView()
//                                        .environmentObject(realmManager)
//                                }
//                            }
//
//                            Section {
//                                ForEach(filtered) { task in
//                                    if task.isComplete {
//                                        TaskDoneCardView(task: task)
//                                            .onChange(of: taskViewModel.currentDay) { newValue in
//                                                taskViewModel.filterTodayTasks()
//                                            }
//                                            .onTapGesture {
//                                                self.showModal = true
//                                            }
//                                            .swipeActions {
//                                                Button(role: .destructive) {
//                                                    withAnimation(.linear(duration: 0.4)) {
//                                                        //taskViewModel.deleteTask(indexSet: )
//                                                        print("delete")
//                                                    }
//                                                } label: {
//                                                    Label("Delete", systemImage: "trash")
//                                                }
//                                            }
//                                    }
//                                }
//                                .sheet(isPresented: self.$showModal) {
//                                    ModalView()
//                                        .environmentObject(realmManager)
//                                }
//
//                            }
//                        }
//                        .frame(minHeight: 500)
//                        .background(Color.yellow)
//                    }
//                }
//                Spacer()
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
        Home()
    }
}

