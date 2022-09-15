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
    
    var body: some View {
        HStack(spacing: 20) {
            Text(extractDateText(currentDate)[0])
                .font(.system(size: 20))
            Spacer()
            Text(extractDateText(currentDate)[1].uppercased())
                .font(.system(size: 40, weight: .bold))
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
}

func extractDateText(_ currentDate: Date) -> [String] {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY MMM"
    
    let date = formatter.string(from: currentDate)
    return date.components(separatedBy: " ")
}

struct CalendarHeaderView_Previews: PreviewProvider {
    @State static var date = Date()
    @State static var month = 0
    
    static var previews: some View {
        CalendarHeaderView(currentDate: $date, currentMonth: $month)
    }
}
