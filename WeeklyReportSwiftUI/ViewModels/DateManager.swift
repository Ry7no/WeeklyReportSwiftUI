//
//  DateManager.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import Foundation

class DateManager {
    
    static let shared: DateManager = DateManager()
    
    private init() {}
    
    func string12ToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        guard let date = dateFormatter.date(from: dateStr) else { return Date() }
        return date
    }
    
    func dateToString12(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToStringNoSecondFull(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToStringNoSecond(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToTimeString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func setToNineAM(for date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: calendar.date(from: components)!)
    }
    
    func addOneDay(to date: Date) -> Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: date)
    }
    
    func minusOneDay(to date: Date) -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: date)
    }
    
    func addHoursToDate(startDate: Date, hoursToAdd: Double) -> Date {
        return Calendar.current.date(byAdding: .minute, value: Int(hoursToAdd * 60), to: startDate)!
    }

    func formatDateToMonthYear(date: Date) -> String? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        
        guard let month = components.month, let year = components.year else {
            return "日期轉換失敗。"
        }
        
        let months = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        let monthString = months[month - 1]
        
        return "\(monthString) \(year)"
    }
    
    func hoursBetween(date1: Date, date2: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: date1, to: date2)
        
        guard let minutes = components.minute else {
            return 0.0
        }
        
//        let hours = Double(minutes) / 60.0
        let roundedHours = Double(minutes / 60)
        let remainder = Double(minutes % 60)
        
        return remainder >= 30 ? roundedHours + 0.5 : roundedHours
    }
    
    func hoursBetweenVer1(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: date1, to: date2)
        return components.hour ?? 0
    }

}
