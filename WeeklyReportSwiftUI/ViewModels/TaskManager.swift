//
//  TaskManager.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import Foundation
import SwiftUI
import AVFoundation

class TaskManager: ObservableObject {
    
    static let shared: TaskManager = TaskManager()
    
    let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    let impactLight = UIImpactFeedbackGenerator(style: .light)
    let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    // AppStorage Site
    @AppStorage("asProjectArray") var asProjectArray: [String] = []
    @AppStorage("asMeetingArray") var asMeetingArray: [String] = []
    @AppStorage("asProgramArray") var asProgramArray: [String] = []
    @AppStorage("asDayOffArray") var asDayOffArray: [String] = []
    
    @AppStorage("asProjectItemArray") var asProjectItemArray: [String] = []
    @AppStorage("asMeetingItemArray") var asMeetingItemArray: [String] = []
    @AppStorage("asProgramItemArray") var asProgramItemArray: [String] = []
    @AppStorage("asDayOffItemArray") var asDayOffItemArray: [String] = []
    
    @Published var projectArray: [String] = ["專案一", "專案二", "專案三"]
    @Published var meetingArray: [String] = ["會議一", "會議二", "會議三"]
    @Published var programArray: [String] = ["程式一", "程式二", "程式三"]
    @Published var dayOffArray: [String] = ["特休假", "病假", "事假", "颱風假"]
    
    @Published var projectItemArray: [String] = ["進度追蹤", "文件整理", "問題統計", "系統展示"]
    @Published var meetingItemArray: [String] = ["與會", "製作會議紀錄", "系統展示"]
    @Published var programItemArray: [String] = ["修正邏輯問題", "修正UI介面", "修正bug", "修正閃退原因"]
    @Published var dayOffItemArray: [String] = ["回診", "預約看診", "私事處理", "家中有事處理"]
    
    @Published var selectedProjectItems: [String] = []
    @Published var selectedMeetingItems: [String] = []
    @Published var selectedProgramItems: [String] = []
    @Published var selectedDayOffItems: [String] = []
    
    @Published var otherDescription: String = ""
    
    @Published var currentDate: Date = Date()
    @Published var fetchedDateValues: [DateValue] = []
    @Published var selectedDateValue: DateValue = DateValue(day: 0, date: Date())
    
    let moodIconInfos: [Int: IconInfo] = [
        1: IconInfo(imageName: "1SoHappy", imageString: "開心", imageColor: Color.red),
        2: IconInfo(imageName: "2Happy", imageString: "笑死", imageColor: Color.orangeColor),
        3: IconInfo(imageName: "3OK", imageString: "不錯", imageColor: Color.SecondaryYellow),
        4: IconInfo(imageName: "4Normal", imageString: "好喔", imageColor: Color.greenColor),
        5: IconInfo(imageName: "5Angry", imageString: "怒怒", imageColor: Color.purpleBlueColor),
        6: IconInfo(imageName: "6Sad", imageString: "難過", imageColor: Color.navyColor),
        7: IconInfo(imageName: "7Shocked", imageString: "驚嚇", imageColor: Color.purpleColor)
    ]

    @Published var currentMonth: Int = 0
    
    @Published var fetchedSqlTasks: [Task] = []
    @Published var selectedWeekStartDate: Date = Date()
    @Published var fetchedSelectedWeekTasks: [Task] = []
    @Published var sortedWeekTasks: [[Task]] = [[]]
    @Published var sortedWeekTaskString: [[String]] = [[]]
    
    @Published var selectedTask: Task = Task(taskCategory: "", taskTitle: "", taskDescription: "", taskProgress: 0, taskStartDate: Date(),  taskEndDate: Date(), taskMoodLevel: 4)
    @Published var isEditing: Bool = false
    
    @Published var savedTaskStartDate: Date? = nil
    @Published var savedTaskEndDate: Date? = nil
    
    @Published var weekSlider: [[DateValue]] = []
    @Published var needUpdate: Bool = false
    
    @Published var isSaving: Bool = false
    
    @Published var showSelections: Bool = false
    
    @AppStorage("mondayMorningDetails") var mondayMorningDetails: String = ""
    @AppStorage("mondayAfternoonDetails") var mondayAfternoonDetails: String = ""
    @AppStorage("tuesdayMorningDetails") var tuesdayMorningDetails: String = ""
    @AppStorage("tuesdayAfternoonDetails") var tuesdayAfternoonDetails: String = ""
    @AppStorage("wednesdayMorningDetails") var wednesdayMorningDetails: String = ""
    @AppStorage("wednesdayAfternoonDetails") var wednesdayAfternoonDetails: String = ""
    @AppStorage("thursdayMorningDetails") var thursdayMorningDetails: String = ""
    @AppStorage("thursdayAfternoonDetails") var thursdayAfternoonDetails: String = ""
    @AppStorage("fridayMorningDetails") var fridayMorningDetails: String = ""
    @AppStorage("fridayAfternoonDetails") var fridayAfternoonDetails: String = ""
    
    @AppStorage("combineProject") var combineProject: Bool = true
    @AppStorage("combineMeeting") var combineMeeting: Bool = false
    @AppStorage("combineProgram") var combineProgram: Bool = true
    @AppStorage("combineDayOffs") var combineDayOffs: Bool = false
    
    init() {
        fetchedSqlTasks = SQLiteCommands.getAllTasks()
//        fetchedSelectedWeekTasks = SQLiteCommands.getTasksForWeek(of: Date())
        initAppStorageData()
        
        print("fetchedSqlTasks: \(fetchedSqlTasks.count)")

    }

    func initAppStorageData() {
        
        if asProjectArray == [] {
            asProjectArray = projectArray
        } else {
            projectArray = asProjectArray
        }
        
        if asMeetingArray == [] {
            asMeetingArray = meetingArray
        } else {
            meetingArray = asMeetingArray
        }
        
        if asProgramArray == [] {
            asProgramArray = programArray
        } else {
            programArray = asProgramArray
        }
        
        if asDayOffArray == [] {
            asDayOffArray = dayOffArray
        } else {
            dayOffArray = asDayOffArray
        }

        if asProjectItemArray == [] {
            asProjectItemArray = projectItemArray
        } else {
            projectItemArray = asProjectItemArray
        }
        
        if asMeetingItemArray == [] {
            asMeetingItemArray = meetingItemArray
        } else {
            meetingItemArray = asMeetingItemArray
        }
        
        if asProgramItemArray == [] {
            asProgramItemArray = programItemArray
        } else {
            programItemArray = asProgramItemArray
        }
        
        if asDayOffItemArray == [] {
            asDayOffItemArray = dayOffItemArray
        } else {
            dayOffItemArray = asDayOffItemArray
        }
        
    }
    
    func firstCharacter(of string: String) -> String? {
        return string.first.map(String.init)
    }
    
    func removeFirstCharacter(from string: String) -> String {
        guard string.count >= 3 else {
            return string // 或者根據你的需要返回一個錯誤或其他值
        }
        let index = string.index(string.startIndex, offsetBy: 1)
        return String(string[index...])
    }
    
    func getIconInfo(from intValue: Int) -> IconInfo? {
        return moodIconInfos[intValue]
    }

    func fetchCurrentWeek(_ date: Date = .init()) -> [DateValue] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)

        var week: [DateValue] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)

        guard let startOfWeek = weekForDate?.start else { return [] }

        (0..<7).forEach { index in
            if let weekday = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                let day = calendar.component(.day, from: weekday)

                // Filter pains that match the current weekday
                let tasksForDay = fetchedSqlTasks.filter {
                    calendar.isDate($0.taskStartDate, inSameDayAs: weekday)
                }
                 

                week.append(DateValue(day: day, date: weekday, tasks: tasksForDay))
            }
        }

        return week
    }

    
    func createNextWeek(_ lastDate: Date) -> [DateValue] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: lastDate)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchCurrentWeek(nextDate)
    }
    
    func createPreviousWeek(_ firstDate: Date) -> [DateValue] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: firstDate)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchCurrentWeek(previousDate)
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        return currentMonth
    }
    
    func extractChinessWeek(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_Hant_TW") // 使用繁體中文
        formatter.dateFormat = "EEEE"
        
        var result = formatter.string(from: date)
        result = result.replacingOccurrences(of: "星期", with: "週")
        
        return result
    }
    
    func extractDate(date: Date, format: String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    func firstDayOfCurrentMonth(from date: Date) -> Date? {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return nil
        }
        return calendar.date(byAdding: .month, value: 0, to: firstDayOfMonth)
    }
    
    func firstDayOfPreviousMonth(from date: Date) -> Date? {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return nil
        }
        return calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth)
    }
    
    func firstDayOfNextMonth(from date: Date) -> Date? {
        let calendar = Calendar.current
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return nil
        }
        return calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth)
    }
    
    func filterTasks(from allTasks: [Task], basedOn date: Date) -> [Task] {
        let startDate = date.startOfWeek.addingDays(1)
        let endDate = startDate.addingDays(5)

        return allTasks.filter { task in
            task.taskStartDate > startDate && task.taskEndDate < endDate
        }.sorted(by: { $0.taskStartDate < $1.taskStartDate })
    }
    
    
    func combine(strings: [String]) -> String {
        // 過濾掉空字串
        let filteredStrings = strings.filter { !$0.isEmpty }
        
        switch filteredStrings.count {
        case 0:
            return " "
        case 1:
            return filteredStrings[0]
        case 2:
            return filteredStrings.joined(separator: "及")
        default:
            let allButLast = filteredStrings.dropLast().joined(separator: "、")
            return "\(allButLast)及\(filteredStrings.last!)"
        }
    }
    
    func split(combinedString: String) -> [String] {
        let components = combinedString.components(separatedBy: "及")
        switch components.count {
        case 1:
            return components
        case 2:
            return components.first!.components(separatedBy: "、") + [components.last!]
        default:
            return combinedString.components(separatedBy: "、")
        }
    }
    
    func splitAndCombineTasks(for weekTasks: [Task]) -> [[Task]] {
        var dailyTasks: [[Task]] = Array(repeating: [], count: 5) // 五個空陣列對應於一週的五天
        
        for task in weekTasks {
            // 得到該任務所在週的天數 (0-4)
            guard let day = Calendar.current.dateComponents([.weekday], from: task.taskStartDate).weekday, day >= 2, day <= 6 else { continue }
            
            let taskIndex = day - 2
            
            // 查看是否已有相同的 taskCategory 和 taskTitle 的任務存在於該天
            if let existingTaskIndex = dailyTasks[taskIndex].firstIndex(where: {
                $0.taskCategory != "\(combineProject ? "" : "專案")" && $0.taskCategory != "\(combineMeeting ? "" : "會議")" && $0.taskCategory != "\(combineProgram ? "" : "程式")" && $0.taskCategory != "\(combineDayOffs ? "" : "休假")" && $0.taskCategory == task.taskCategory && $0.taskTitle == task.taskTitle
            }) {
                // 分解現有任務和新任務的 taskDescription
                let existingDescriptions = split(combinedString: dailyTasks[taskIndex][existingTaskIndex].taskDescription)
                let newDescriptions = split(combinedString: task.taskDescription)
                
                // 合併並移除重複項
                let combinedDescriptions = Array(Set(existingDescriptions + newDescriptions))
                
                // 更新該任務的 taskDescription
                dailyTasks[taskIndex][existingTaskIndex].taskDescription = combine(strings: combinedDescriptions)
            } else {
                dailyTasks[taskIndex].append(task)
            }
        }
        
        return dailyTasks
    }
    
    func generateDescriptionStrings(from tasksByDay: [[Task]]) -> [[String]] {
        return tasksByDay.map { tasksForOneDay in
            // 對於一天的任務，區分為上午和下午
            let morningTasks = tasksForOneDay.filter { task in
                guard let hour = Calendar.current.dateComponents([.hour], from: task.taskStartDate).hour else { return false }
                return hour < 12
            }
            
            let afternoonTasks = tasksForOneDay.filter { task in
                guard let hour = Calendar.current.dateComponents([.hour], from: task.taskStartDate).hour else { return false }
                return hour >= 12
            }
            
            // 根據每個任務生成描述字串
            let morningStrings = morningTasks.map { task in
                return "[\(task.taskTitle)] \(task.taskDescription)"
            }
            
            let afternoonStrings = afternoonTasks.map { task in
                return "[\(task.taskTitle)] \(task.taskDescription)"
            }
            
            // 使用 " / " 將描述字串組合起來
            return [morningStrings.joined(separator: " / "), afternoonStrings.joined(separator: " / ")]
        }
    }
    
    func saveDetailsToAppStorage(descriptionsForWeek: [[String]]) {
        guard descriptionsForWeek.count >= 5 else { return } // 確保有五天的描述
        
        mondayMorningDetails = descriptionsForWeek[0][0]
        mondayAfternoonDetails = descriptionsForWeek[0][1]
        
        tuesdayMorningDetails = descriptionsForWeek[1][0]
        tuesdayAfternoonDetails = descriptionsForWeek[1][1]
        
        wednesdayMorningDetails = descriptionsForWeek[2][0]
        wednesdayAfternoonDetails = descriptionsForWeek[2][1]
        
        thursdayMorningDetails = descriptionsForWeek[3][0]
        thursdayAfternoonDetails = descriptionsForWeek[3][1]
        
        fridayMorningDetails = descriptionsForWeek[4][0]
        fridayAfternoonDetails = descriptionsForWeek[4][1]
    }
    
    func delayedImpactOccurred(impactStyle: UIImpactFeedbackGenerator.FeedbackStyle, delaySec: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            UIImpactFeedbackGenerator(style: impactStyle).impactOccurred()
        }
    }
    
}
