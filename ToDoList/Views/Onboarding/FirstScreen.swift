//
//  FirstScreen.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/12/09.
//

import SwiftUI

var totalPages = 3

struct FirstScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        if currentPage == 4 {
            Home()
        } else {
            WalkThroughScreen()
        }

    }
}

//WalkThrough Screen
struct WalkThroughScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        //for slide animation
        ZStack {
            //changing between views
            if currentPage == 1 {
                ScreenView(image: "image1", title: "title1", detail: "", bgColor: Color("color1"))
                    .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "image2", title: "title2", detail: "", bgColor: Color("color2"))
                    .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "image3", title: "title3", detail: "", bgColor: Color("color3"))
                    .transition(.scale)
            }
        }
        .overlay(
            //button
            Button(action: {
                //changing views
                withAnimation(.easeInOut) {
                    //checking
                    if currentPage <= totalPages {
                        currentPage += 1
                    }
                }
            }, label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    //circular slider
                    .overlay(
                        ZStack {
                            Circle()
                                .stroke(Color.black.opacity(0.04), lineWidth: 4)
                            Circle()
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.black, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                        .padding(-15)
                    )
            })
            .padding(.bottom, 20)
            ,alignment: .bottom
        )
    }
}

struct ScreenView: View {
    
    var image: String
    var title: String
    var detail: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                //show it only for the first page
                if currentPage == 1 {
                    Text("Hello sweety")
                        .font(.title)
                        .fontWeight(.semibold)
                    //letter spacing
                        .kerning(1.4)
                } else {
                    //back button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentPage -= 1
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        currentPage = 4
                    }
                }, label: {
                    Text("skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            Spacer(minLength: 0)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
            //change with my own thing
            Text("description about this screen")
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.center)
            //minimum spacing when phone is reducing
            Spacer(minLength: 120)
        }
        .background(bgColor.cornerRadius(10).ignoresSafeArea())
    }
}

struct FirstScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen()
    }
}
