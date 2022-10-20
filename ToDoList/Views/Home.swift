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
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack {
                    let notDone = tasks.filter("taskDate == %@", currentDate).filter("isCompleted == false")
                    let isDone = tasks.filter("taskDate == %@", currentDate).filter("isCompleted == true")
                    HeaderView(selectedDate: $currentDate)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    if !notDone.isEmpty
                    {
                        List {
                            ForEach(notDone, id: \.id) { task in
                                if !task.isInvalidated {
                                    TaskCardView(task: task)
                                        .listRowSeparator(.hidden)
                                        .onTapGesture { selectedTask = task }
                                }
                            }
                            .onDelete(perform: $tasks.remove )
                            ForEach(isDone, id: \.id) { task in
                                if !task.isInvalidated {
                                    TaskCardView(task: task)
                                        .listRowSeparator(.hidden)
                                        .onTapGesture { selectedTask = task }
                                }
                            }
                            .onDelete(perform: $tasks.remove )
                        }
                        .sheet(item: $selectedTask) {
                            UpdateModalView(task: $0)
                        }
                        .background(.white)
                        .onAppear() {
                            UITableView.appearance().backgroundColor = UIColor.clear
                            UITableViewCell.appearance().backgroundColor = UIColor.clear
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(UIColor.systemGroupedBackground))
                        //                        .listStyle(.plain)

                    } else {
                        NoTaskView()
                            .frame(alignment: .center)
                        Spacer()
                    }
                    Spacer()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing: NavigationLink(destination: CalendarView(currentDate: $currentDate)
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
}
