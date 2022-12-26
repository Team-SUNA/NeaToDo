//
//  FirstScreen.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/12/09.
//

import SwiftUI

var totalPages = 4

struct FirstScreen: View {
    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        if currentPage == 5 {
            Home()
                .navigationViewStyle(StackNavigationViewStyle())
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
                ScreenView(image: "one")
                    .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "two")
                    .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "three")
                    .transition(.scale)
            }
            if currentPage == 4 {
                ScreenView(image: "four")
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
                        .padding(0)
                    )
            })
            .offset(y: 10)
            .padding(.bottom, 10)
            ,alignment: .bottom
        )
    }
}

struct ScreenView: View {
    
    var image: String

    
    @AppStorage("currentPage") var currentPage = 1
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                //show it only for the first page
                if currentPage != 1 {
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
                            .background(Color.purple.opacity(0.4))
                            .cornerRadius(10)
                            .ignoresSafeArea()
                            .offset(y: -15)
                    })
                }
                Spacer()
                Button(action: {
                    withAnimation(.easeInOut) {
                        currentPage = 5
                    }
                }, label: {
                    Text("skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .ignoresSafeArea()
                        .offset(y: -15)
                })
            }
            .foregroundColor(.black)
            .padding()
//            Spacer(minLength: 0)
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .ignoresSafeArea()
                .offset(x:0, y: -50)
            //minimum spacing when phone is reducing
        }
    }
}

struct FirstScreen_Previews: PreviewProvider {
    static var previews: some View {
        FirstScreen()
    }
}
