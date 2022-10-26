//
//  NoTaskView.swift
//  ToDoList
//
//  Created by Suji Lee on 2022/09/04.
//

import SwiftUI

struct NoTaskView: View {
    var body: some View {
        Text("NO TASKS !")
            .font(.system(size: 20))
            .fontWeight(.light)
            .offset(y: 100)
    }
}

struct NoTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NoTaskView()
    }
}
