//
//  SQLiteDatabase.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import Foundation
import SQLite

class SQLiteDatabase {
    
    static let shared = SQLiteDatabase()
    
    var dbTaskTable: Connection?
    
    private init() {

        do {

            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrlPain = documentDirectory.appendingPathComponent("dbTaskTable").appendingPathExtension("sqlite3")

            dbTaskTable = try Connection(fileUrlPain.path)
            
        } catch {
            print("Creating dbTaskTable Error: \(error.localizedDescription)")
        }
    }
    
    func creatTables() {
        SQLiteCommands.createTaskTable()
    }
    
    func deleteTaskTable() {
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrlModel = documentDirectory.appendingPathComponent("dbTaskTable").appendingPathExtension("sqlite3")
            
            try FileManager.default.removeItem(at: fileUrlModel)
            
        } catch {
            print("Deleting dbTaskTable Error: \(error.localizedDescription)")
        }
    }


}
