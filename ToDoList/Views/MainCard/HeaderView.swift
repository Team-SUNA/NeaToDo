//
//  HeaderView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct HeaderView: View {
    
    @ObservedObject var headerViewUtil: HeaderViewUtil
    @Namespace var animation
    @Binding var currentDate: Date

    
    var body: some View {

        // MARK: Current Week View
        GeometryReader { geo in
            HStack(spacing: 10) {
                ForEach(headerViewUtil.currentWeek, id: \.self) { day in
                    VStack {

                        Text(headerViewUtil.extractDate(date: day, format: "EEE"))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        Text(headerViewUtil.extractDate(date: day, format: "dd"))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)

                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? 1 : 0)
                    }
                    // MARK: Foreground Style
                    .foregroundStyle(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? .primary : .secondary)

                    .foregroundColor(isSameDay(date1: headerViewUtil.currentDay, date2: day) ? .white : .black)
                    // MARK: Capsule Shape
                    //저 요일을을 가로로 꽉차게 펼치는 작업
                    
//                    .frame(width: 42, height: 90)
                    .frame(width: geo.size.width * 0.11, height: geo.size.height * 1.1)
                    .background(

                        ZStack {
                            // MARK: Matched Geometry Effect
                            //Week day가 변경되었을시 애니메이션 효과
                            if isSameDay(date1: headerViewUtil.currentDay, date2: day) {
                                Capsule()
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                            }
                        }
                    )
                    .contentShape(Capsule())
                    .onTapGesture {
                        //Updating Current Day
                        withAnimation {
                            headerViewUtil.currentDay = day
                            currentDate = day
                        }
                    }
                }
            }
            .frame(width: .infinity, alignment: .center)
            .padding(.horizontal)
        }

    }
}

//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        HeaderView(headerViewUtil: HeaderViewUtil())
//            .previewInterfaceOrientation(.portraitUpsideDown)
//    }
//}
