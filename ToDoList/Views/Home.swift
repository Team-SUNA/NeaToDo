//
//  Home.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showModal = false
    @Namespace var animation
    @State var currentDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(taskViewModel: taskViewModel)
                    ScrollView {
                    if taskViewModel.tasks.isEmpty {
                        NoTaskView()
                    } else {
                        List {
                            Section {
                                ForEach(taskViewModel.tasks) { task in
                                    TaskCardView(task: task)
                                        .onTapGesture {
                                            withAnimation(.linear) {
                                                taskViewModel
                                            }.updateTask(task: task)
                                        }
                                }
                                .onDelete(perform: taskViewModel.deleteTask)
                            }
                            
                            Section {
                                ForEach(taskViewModel.tasks) { task in
                                    if task.isComplete {
                                        TaskCardView(task: task)
                                            .onTapGesture {
                                                withAnimation(.linear) {
                                                    taskViewModel
                                                }.updateTask(task: task)
                                            }
                                    }
                                }
                                .onDelete(perform: taskViewModel.deleteTask)
                            }
                        }
                    }
                }

            }
            .navigationTitle("TO DO CARDS")
            .navigationBarItems(trailing: NavigationLink("Calendar", destination: CalendarView(currentDate: $currentDate)))

        }
        .environmentObject(TaskViewModel())
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
            .environmentObject(TaskViewModel())

    }
}

