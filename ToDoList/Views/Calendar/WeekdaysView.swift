//
//  WeekDayView.swift
//  ToDoList
//
//  Created by 김나연 on 2022/09/13.
//

import SwiftUI

func dayText(text: String) -> some View {
    Text(text)
        .font(.callout)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
}

struct WeekdaysView: View {
    let days: [String] =
    ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    var body: some View {
        HStack {
            ForEach(days, id: \.self) { day in
                if day == "SUN" {
                    dayText(text: day).foregroundColor(.red)
                } else if day == "SAT" {
                    dayText(text: day).foregroundColor(Color(#colorLiteral(red: 0.4467597008, green: 0.1914927065, blue: 0.6714115143, alpha: 1)))
                } else {
                    dayText(text: day)
                }
            }
        }
    }
}
