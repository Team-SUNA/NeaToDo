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
    
    var body: some View {

        // MARK: Current Week View
            HStack(spacing: 10) {
                ForEach(headerViewUtil.currentWeek, id: \.self) { day in
                    VStack {

                        Text(headerViewUtil.extractDate(date: day, format: "EEE"))
                            .font(.system(size: 14))
                            .fontWeight(.semibold)
                        Text(headerViewUtil.extractDate(date: day, format: "dd"))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)

                        Circle()
                            .fill(.white)
                            .frame(width: 8, height: 8)
                            .opacity(headerViewUtil.isToday(date: day) ? 1 : 0)
                    }
                    // MARK: Foreground Style
                    .foregroundStyle(headerViewUtil.isToday(date: day) ? .primary : .secondary)

                    .foregroundColor(headerViewUtil.isToday(date: day) ? .white : .black)
                    // MARK: Capsule Shape
                    //저 요일을을 가로로 꽉차게 펼치는 작업
                    .frame(width: 42, height: 90)
                    .background(

                        ZStack {
                            // MARK: Matched Geometry Effect
                            //Week day가 변경되었을시 애니메이션 효과
                            if headerViewUtil.isToday(date: day) {
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
                        }
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(headerViewUtil: HeaderViewUtil())
            .previewInterfaceOrientation(.portraitUpsideDown)
    }
}
