//
//  UserManager.swift
//  WeeklyReportSwiftUI
//
//  Created by Ryan@work on 2022/6/21.
//

import SwiftUI
import Foundation

class UserManager {
    
    static let shared = UserManager()
    
    var startDateString: String?
    var endDateString: String?
    var startDateFile: String?
    var endDateFile: String?
    var mondayString: String?
    var tuesdayString: String?
    var wednesdayString: String?
    var thursdayString: String?
    var fridayString: String?
    var outputFileName: String?
    
    private init() {}
}
