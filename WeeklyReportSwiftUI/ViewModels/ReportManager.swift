//
//  ReportManager.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/13.
//

import SwiftUI
import Foundation
import PDFKit
import UIKit
import Foundation
import MessageUI
import CoreText
import QuartzCore

/*
class ReportManager: ObservableObject {
    
    static let shared: ReportManager = ReportManager()
    
    var interactionController = UIDocumentInteractionController()
    
    @State var outputFileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(UserDefaults.standard.string(forKey: "outputFileName") ?? "Swift").pdf")

    func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
            print("Clear all file")
        } catch {
            return
        }
    }
    
    func exportViewToPDF() {
        
        let pageSize = CGSize(width: 595.2, height: 841.8)
        
        //View to render on PDF
        let myUIHostingController = UIHostingController(rootView: MainReportView())
        myUIHostingController.view.frame = CGRect(origin: .zero, size: pageSize)
        
        
        //Render the view behind all other views
        guard let rootVC = UIApplication.shared.windows.first?.rootViewController else {
            print("ERROR: Could not find root ViewController.")
            return
        }
        rootVC.addChild(myUIHostingController)
        //at: 0 -> draws behind all other views
        //at: UIApplication.shared.windows.count -> draw in front
        rootVC.view.insertSubview(myUIHostingController.view, at: 0)
        
        //Render the PDF
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        DispatchQueue.main.async {
            do {
                try pdfRenderer.writePDF(to: self.outputFileURL, withActions: { (context) in
                    context.beginPage()
                    myUIHostingController.view.layer.render(in: context.cgContext)
                })
                print("wrote file to: \(self.outputFileURL.path)")
            } catch {
                print("Could not create PDF file: \(error.localizedDescription)")
            }
            
            //Remove rendered view
            myUIHostingController.removeFromParent()
            myUIHostingController.view.removeFromSuperview()
   
        }
    }
    
    func dateInitManager(initDate: Date) {

        let dateStr = initDate.toTaiwanDateString()
        print("@ dateStr: \(dateStr)")

        let startDateString = dateToString(date: stringToDateYYY(dateStr: dateStr))
        let endDateString = dateToString(date: Calendar.current.date(byAdding: .day, value: 4, to: stringToDateYYY(dateStr: dateStr))!)
        let startDateFile = dateToStringFileName(date: stringToDateYYY(dateStr: dateStr))
        let endDateFile = dateToStringFileName(date: Calendar.current.date(byAdding: .day, value: 4, to: stringToDateYYY(dateStr: dateStr))!)
        
        UserManager.shared.startDateString = startDateString
        UserManager.shared.endDateString = endDateString
        UserManager.shared.startDateFile = startDateFile
        UserManager.shared.endDateFile = endDateFile
        
        let monday = stringToDate(dateStr: dateStr)
        let tuesday = Calendar.current.date(byAdding: .day, value: 1, to: stringToDate(dateStr: dateStr))
        let wednesday = Calendar.current.date(byAdding: .day, value: 2, to: stringToDate(dateStr: dateStr))
        let thursday = Calendar.current.date(byAdding: .day, value: 3, to: stringToDate(dateStr: dateStr))
        let friday = Calendar.current.date(byAdding: .day, value: 4, to: stringToDate(dateStr: dateStr))
        let mondayString = dateToStringMMDD(date: monday)
        let tuesdayString = dateToStringMMDD(date: tuesday!)
        let wednesdayString = dateToStringMMDD(date: wednesday!)
        let thursdayString = dateToStringMMDD(date: thursday!)
        let fridayString = dateToStringMMDD(date: friday!)
        
        UserManager.shared.mondayString = mondayString
        UserManager.shared.tuesdayString = tuesdayString
        UserManager.shared.wednesdayString = wednesdayString
        UserManager.shared.thursdayString = thursdayString
        UserManager.shared.fridayString = fridayString

        UserDefaults.standard.set("\(UserDefaults.standard.string(forKey: "userName") ?? "姓名")-工作週報_\(UserManager.shared.startDateFile ?? "111-06-13")_to_\(UserManager.shared.endDateFile ?? "111-06-17")", forKey: "outputFileName")
        
        
    }
    
    func stringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: dateStr) else { return Date() }
        return date
    }
    
    func stringToDateYYY(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        guard let date = dateFormatter.date(from: dateStr) else { return Date() }
        return date
    }
    
    func dateToStringFileName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToStringYYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW") // 設定地區(台灣)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei") // 設定時區(台灣)
        dateFormatter.calendar = Calendar(identifier: Calendar.Identifier.republicOfChina)
        
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToStringYYYII(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        var int = Int(dateFormatter.string(from: date))
        var string = String((int ?? 2020) - 1911)
        
        return string
    }
    
    func dateToStringYYYY(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        
        let string = dateFormatter.string(from: date)
        return string
    }
    
    func dateToStringMMDD(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        let string = dateFormatter.string(from: date)
        return string
    }

}
*/
