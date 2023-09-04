//
//  SQLiteCommands.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import Foundation
import SQLite
import SQLite3

class SQLiteCommands {
    /*
     var id = UUID().uuidString

     var taskCategory: String
     var taskTitle: String
     var taskDescription: String
     var taskStartDate: Date
     var taskEndDate: Date
     var taskMoodLevel: Int

     */
    
    // MARK: - [Task]
    
    static var TaskTable = Table("TaskTable")
    
    static let id = Expression<String>("id")
    
    static let taskCategory = Expression<String>("taskCategory")
    static let taskTitle = Expression<String>("taskTitle")
    static let taskDescription = Expression<String>("taskDescription")
    static let taskProgress = Expression<Double>("taskProgress")
    static let taskStartDate = Expression<Date>("taskStartDate")
    static let taskEndDate = Expression<Date>("taskEndDate")
    static let taskMoodLevel = Expression<Int>("taskMoodLevel")

    // [Task] CREATE TABLE
    static func createTaskTable() {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("dbTaskTable connection error")
            return
        }
        
        do {
            
            try db.run(TaskTable.create(ifNotExists: true) { task in
                task.column(id, primaryKey: true)
                task.column(taskCategory)
                task.column(taskTitle)
                task.column(taskDescription)
                task.column(taskProgress)
                task.column(taskStartDate)
                task.column(taskEndDate)
                task.column(taskMoodLevel)
            })
            
        } catch {
            print("dbTaskTable already exists: \(error.localizedDescription)")
        }
    }

    // [Task] ADD TASK
    static func addTask(model: Task) -> Bool? {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return nil
        }

        do {
            try db.run(TaskTable.insert(id <- model.id,
                                        taskCategory <- model.taskCategory,
                                        taskTitle <- model.taskTitle,
                                        taskDescription <- model.taskDescription,
                                        taskProgress <- model.taskProgress,
                                        taskStartDate <- model.taskStartDate,
                                        taskEndDate <- model.taskEndDate,
                                        taskMoodLevel <- model.taskMoodLevel
                                       ))
            return true
        } catch let error {
            print("Add failed: \(error.localizedDescription)")
            return false
        }
    }

    // [Task] GET TASK
    static func getAllTasks() -> [Task] {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return []
        }
        
        var sqlModels = [Task]()
        
        let allTaskTable = TaskTable.order(taskStartDate.asc)

        do {
            for model in try db.prepare(allTaskTable) {
                let idValue = model[id]
                let taskCategoryValue = model[taskCategory]
                let taskTitleValue = model[taskTitle]
                let taskDescriptionValue = model[taskDescription]
                let taskProgressValue = model[taskProgress]
                let taskStartDateValue = model[taskStartDate]
                let taskEndDateValue = model[taskEndDate]
                let taskMoodLevelValue = model[taskMoodLevel]
                
                let modelObj = Task(id: idValue, taskCategory: taskCategoryValue, taskTitle: taskTitleValue, taskDescription: taskDescriptionValue, taskProgress: taskProgressValue, taskStartDate: taskStartDateValue, taskEndDate: taskEndDateValue, taskMoodLevel: taskMoodLevelValue)
                
                sqlModels.append(modelObj)
                
            }
        } catch {
            print("Fetch data error: \(error.localizedDescription)")
        }
        return sqlModels
    }
    
    static func getTasksForWeek(of date: Date) -> [Task] {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return []
        }

        let startDate = date.startOfWeek.addingDays(1)
        let endDate = startDate.addingDays(5)
        
        print("@ startDate: \(DateManager.shared.dateToStringNoSecondFull(date: startDate))")
        print("@ endDate: \(DateManager.shared.dateToStringNoSecondFull(date: endDate))")

        // Use the new weekStartDate field for filtering
        let filteredTaskTable = TaskTable.filter(taskStartDate > startDate && taskEndDate < endDate).order(taskStartDate.asc)

        var tasks: [Task] = []

        do {
            for model in try db.prepare(filteredTaskTable) {
                let idValue = model[id]
                let taskCategoryValue = model[taskCategory]
                let taskTitleValue = model[taskTitle]
                let taskDescriptionValue = model[taskDescription]
                let taskProgressValue = model[taskProgress]
                let taskStartDateValue = model[taskStartDate]
                let taskEndDateValue = model[taskEndDate]
                let taskMoodLevelValue = model[taskMoodLevel]
                
                let modelObj = Task(id: idValue, taskCategory: taskCategoryValue, taskTitle: taskTitleValue, taskDescription: taskDescriptionValue, taskProgress: taskProgressValue, taskStartDate: taskStartDateValue, taskEndDate: taskEndDateValue, taskMoodLevel: taskMoodLevelValue)
                
                tasks.append(modelObj)
                
            }
        } catch {
            print("Fetch data error: \(error.localizedDescription)")
        }

        return tasks
    }

    
    // [Task] UPDATE TASK
    static func updateTask(taskValue: Task) -> Bool? {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return nil
        }
        
        let task = TaskTable.filter(id == taskValue.id).limit(1)
        
        do {
            try db.run(task.update(taskCategory <- taskValue.taskCategory,
                                   taskTitle <- taskValue.taskTitle,
                                   taskDescription <- taskValue.taskDescription,
                                   taskProgress <- taskValue.taskProgress,
                                   taskStartDate <- taskValue.taskStartDate,
                                   taskEndDate <- taskValue.taskEndDate,
                                   taskMoodLevel <- taskValue.taskMoodLevel))
            
            return true
        } catch let error {
            print("Updating failed: \(error.localizedDescription)")
            return false
        }
    }

    // [Task] DELETE TASK
    static func deleteTask(taskValue: Task) {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return
        }
        
        let model = TaskTable.filter(id == taskValue.id).limit(1)
        
        do {
            try db.run(model.delete())

        } catch let error {
            print("Updating failed: \(error.localizedDescription)")
        }
    }
    
    // [Task] DELETE ALL TASKS
    static func deleteAllTasks() {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return
        }
        
        do {
            try db.run(TaskTable.delete())
        } catch let error {
            print("Deleting all pains failed: \(error.localizedDescription)")
        }
    }

    // [Task] CLEAN TASK TABLE
    static func cleanPainTable() {
        guard let db = SQLiteDatabase.shared.dbTaskTable else {
            print("Datastore connection error")
            return
        }
        
        do {
            try db.scalar("DELETE FROM TaskTable")
        } catch {
            print("DELETE TaskTable ERROR: \(error.localizedDescription)")
        }
    }

}
