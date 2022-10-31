//
//  HeaderView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import SwiftUI

struct CalendarHeaderView: View {
    @Binding var currentDate: Date
    @Binding var currentMonth: Int
    var dateText: [String] { return extractDateText(currentDate) }
    
    var body: some View {
        HStack(spacing: 20) {
            Text(dateText[0])
                .font(.system(size: 20))
            Spacer()
            Button(action: {
                currentDate = Date()
                currentMonth = 0
            }) {
                Text(dateText[1].uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.textColor)
                    .padding()
            }
            Spacer(minLength: 0)
            Button {
                currentMonth -= 1
            } label: {
                Image(systemName: "chevron.left")
            }
            Button {
                currentMonth += 1
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal)
    }
    
    func extractDateText(_ currentDate: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMM"
        formatter.locale = Locale(identifier: "en")
        // TODO: 달을 넘어가면 날이 같은게 이상해서... 화면만 바뀌고 날짜는 마지막으로 터치했던 날로 유지되게 함. 어떤게 좋을지 상의.
        // 아... 이렇게 했더니 달은 바뀌는데 아래 태스크는 똑같이 유지되는 현상 발생. 어떻게 할지 상의...
//        let date = formatter.string(from: currentDate)
        let date = formatter.string(from: Calendar.current.date(byAdding: .month, value: currentMonth, to: Date())!)
        return date.components(separatedBy: " ")
    }
}
