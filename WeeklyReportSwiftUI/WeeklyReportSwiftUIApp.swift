//
//  WeeklyReportSwiftUIApp.swift
//  WeeklyReportSwiftUI
//
//  Created by Ryan@work on 2022/6/21.
//

import SwiftUI

@main
struct WeeklyReportSwiftUIApp: App {
    
    init() {
        if (UIScreen.main.bounds.height / UIScreen.main.bounds.width) < 1.8 {
            UserDefaults.standard.set(true, forKey: "isWide")
        } else {
            UserDefaults.standard.set(false, forKey: "isWide")
        }
    }
    
    var body: some Scene {

        WindowGroup {
            ContentView()
                .environmentObject(ReportViewModel())
        }
    }
}
