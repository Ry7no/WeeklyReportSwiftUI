//
//  WeeklyReportSwiftUIApp.swift
//  WeeklyReportSwiftUI
//
//  Created by Ryan@work on 2022/6/21.
//

import SwiftUI
import IQKeyboardManagerSwift

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      IQKeyboardManager.shared.enable = true
    return true
  }
}

@main
struct WeeklyReportSwiftUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        if (UIScreen.main.bounds.height / UIScreen.main.bounds.width) < 1.8 {
            UserDefaults.standard.set(true, forKey: "isWide")
        } else {
            UserDefaults.standard.set(false, forKey: "isWide")
        }
    }
    
    var body: some Scene {

        WindowGroup {
//            AddTaskView()
            HomeView()
//            EditReportView()
//            MainReportView()
                .environmentObject(TaskManager())
                .environmentObject(ReportViewModel())
                .preferredColorScheme(.light)
        }
    }
}
