//
//  DateValue.swift
//  NTDA
//
//  Created by 김나연 on 2022/08/23.
//
import SwiftUI

// date value model
struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
