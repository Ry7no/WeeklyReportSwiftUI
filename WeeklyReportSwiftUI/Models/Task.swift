//
//  Task.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import Foundation
import SwiftUI

struct Task: Identifiable, Hashable {
    
    var id = UUID().uuidString

    var taskCategory: String
    var taskTitle: String
    var taskDescription: String
    var taskProgress: Double
    var taskStartDate: Date
    var taskEndDate: Date
    var taskMoodLevel: Int
    
}

struct DateValue: Identifiable, Equatable {
    
    static func == (lhs: DateValue, rhs: DateValue) -> Bool {
        return lhs.day == rhs.day
    }
    
    var id = UUID().uuidString
    var day: Int = 0
    var date: Date
    var tasks: [Task] = []
}

struct IconInfo {
    var imageName: String
    var imageString: String
    var imageColor: Color
}
