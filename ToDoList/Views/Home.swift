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
    @State private var selectedTask: Task? = nil
    @Namespace var animation // TODO: 애니메이션 좀 과한 느낌... 줄이거나 없애면 어떨까여
    @State var currentDate: Date = Date()
    var tasks: [Task] { return realmManager.tasks.filter({ task in
        return isSameDay(date1: task.taskDate, date2: headerViewUtil.currentDay)}) }
    // TODO: 설명. if let에서 실패하는 경우는 없는거같다(notaskview가 안나옴). 그냥 처음에 변수로 선언해주기
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(headerViewUtil: headerViewUtil)
                if !tasks.isEmpty
                {
                    let notDone = tasks.filter({task in return !task.isCompleted})
                    let isDone = tasks.filter({task in return task.isCompleted})
                    List { // TODO: section 없애도 기능을 제대로 되는데, 토글 필요할지 상의
                        //                        Section {
                        ForEach(notDone) { task in
                            TaskCardView(task: task)
                                .onTapGesture {
                                    selectedTask = task
                                }
                                .swipeActions(edge: .leading) {
                                    Button (action: { realmManager.updateTask(id: task.id, task.taskTitle, task.taskDescription, task.taskDate, task.descriptionVisibility, true)}) {
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
//                                .sheet(item: $selectedTask) {
//                                    // TODO: update 하는 모달뷰로 바꿔야함
//                                    UpdateModalView(task: $0)
//                                        .environmentObject(realmManager)
//                                }
                        }
                        ////                        Section {
                        ForEach(isDone) { task in
                            TaskDoneCardView(task: task)
                                .swipeActions(edge: .leading) {
                                    Button (action: { realmManager.updateTask(id: task.id, task.taskTitle, task.taskDescription, task.taskDate, task.descriptionVisibility, false)}) {
                                        Label("Not Done", systemImage: "xmark")
                                    }
                                    .tint(.yellow)
                                }
                                .onTapGesture {
                                    selectedTask = task
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
//                                .sheet(item: $selectedTask) {
//                                    // TODO: update 하는 모달뷰로 바꿔야함
//                                    UpdateModalView(task: $0)
//                                        .environmentObject(realmManager)
//
//                                }
                        }
                    }
                    .sheet(item: $selectedTask) {
                        // TODO: update 하는 모달뷰로 바꿔야함
                        UpdateModalView(task: $0)
                            .environmentObject(realmManager)
                    }
                    .frame(minHeight: 500)
                    .background(Color.clear)
                    .onAppear() {
                        UITableView.appearance().backgroundColor = UIColor.clear
                        UITableViewCell.appearance().backgroundColor = UIColor.clear
                    }
                } else {
                    NoTaskView()
                    Spacer()
                }
            }
            .navigationTitle("TEAM SUNA")
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink("Calendar", destination: CalendarView(currentDate: $currentDate)
                .environmentObject(realmManager)))
        }
        .environmentObject(realmManager)
        .safeAreaInset(edge: .bottom) {
            Button {
                showModal = true
            } label: {
                Text("+")
                    .foregroundColor(.purple)
                    .font(.system(size: 30))
                    .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: $showModal) {
                ModalView(taskDate: $currentDate)
                    .environmentObject(realmManager)
            }
            .padding(.horizontal)
            .padding(.top, 5)
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

