//
//  ContentView.swift
//  WeeklyReportSwiftUI
//
//  Created by Ryan@work on 2022/6/21.
//

import SwiftUI
import PDFKit
import MessageUI


struct ContentView: View {
    
    @ObservedObject var reportViewModel = ReportViewModel()
//    陳俊宏-工作週報_111-06-13_to_111-06-17
    @State var data: Data?
    @State private var isShowingPDFSheet = false
    @State private var isShowingEditSheet = false

    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView: Bool = false
    @State var fileName = "陳俊宏-工作週報_111-06-13_to_111-06-17"
    @State var isShowAlert = false
    
    init(){
        
        let dateStr = "2022/\(UserDefaults.standard.string(forKey: "startMonth") ?? "6")/\(UserDefaults.standard.string(forKey: "startDay") ?? "13")"
        let startDateString = dateToString(date: stringToDate(dateStr: dateStr))
        let endDateString = dateToString(date: Calendar.current.date(byAdding: .day, value: 4, to: stringToDate(dateStr: dateStr))!)
        let startDateFile = dateToStringFileName(date: stringToDate(dateStr: dateStr))
        let endDateFile = dateToStringFileName(date: Calendar.current.date(byAdding: .day, value: 4, to: stringToDate(dateStr: dateStr))!)
        
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
        
        
    }
    
    var body: some View {
        
        VStack {
            
            alertButton
            
            VStack(alignment: .leading, spacing: 0) {
                
                nameTextView
                titleTextView
                weekTextView

                HStack {
                    Text("主管\n交辦\n任務")
                        .font(.caption.bold())
                        .frame(maxWidth: 22.5, maxHeight: 60)// 46.5
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                    
                    Text("\(UserDefaults.standard.string(forKey: "missions") ?? "")")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                }
                .padding(0)
                .background(Color.white)
                
                HStack {
                    Text("本\n週\n工\n作\n細\n部\n摘\n要")
                        .font(.caption.bold())
                        .frame(maxWidth: 22.5, maxHeight: 288)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                    
                    VStack (spacing: 0){
                        Text("一、\(UserManager.shared.mondayString ?? "06/13")\n早：\(UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "")")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            .padding(5)
                            .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                        
                        Text("二、\(UserManager.shared.tuesdayString ?? "06/14")\n早：\(UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "")")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            .padding(5)
                            .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                        
                        Text("三、\(UserManager.shared.wednesdayString ?? "06/15")\n早：\(UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "")")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            .padding(5)
                            .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                        
                        Text("四、\(UserManager.shared.thursdayString ?? "06/16")\n早：\(UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "")")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            .padding(5)
                            .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                        
                        Text("五、\(UserManager.shared.fridayString ?? "06/17")\n早：\(UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "")")
                            .font(.caption2)
                            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                            .padding(5)
                            .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                    }
                }
                .padding(0)
                .background(Color.white)
                
                HStack {
                    Text("本週\n工作\n摘要")
                        .font(.caption.bold())
                        .frame(maxWidth: 22.5, maxHeight: 60)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                    
                    Text("\(UserDefaults.standard.string(forKey: "thisWeekPlan") ?? "本週計畫")")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                }
                .padding(0)
                .background(Color.white)
                
                HStack {
                    Text("次週\n工作\n計畫")
                        .font(.caption.bold())
                        .frame(maxWidth: 22.5, maxHeight: 60)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                    
                    Text("\(UserDefaults.standard.string(forKey: "nextWeekPlan") ?? "下週計畫")")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                }
                .padding(0)
                .background(Color.white)
                
                HStack {
                    Text("建議\n以及\n需要\n協助\n事項")
                        .font(.caption.bold())
                        .frame(maxWidth: 22.5, maxHeight: 80)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                    
                    Text("\(UserDefaults.standard.string(forKey: "suggestion") ?? "無")")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
                        .padding(6)
                        .overlay(Rectangle().stroke(lineWidth: 1))
                        .offset(x: -8)
                }
                .padding(0)
                .background(Color.white)
            }
            .padding()
            .offset(x: 4)
            .padding()
        }
    }
}

extension ContentView {
    
    private var alertButton: some View {
        
        Button {
            
            isShowAlert = true
            
        } label: {
            Text("工作週報")
                .foregroundColor(.black)
                .bold()
        }
        .alert("選擇動作", isPresented: $isShowAlert, actions: {
            
            Button("編輯ＰＤＦ", role: .destructive) {
                isShowingEditSheet.toggle()
            }

//            Button("生成ＰＤＦ") {
//                fileName = "\(UserDefaults.standard.string(forKey: "userName") ?? "姓名")-工作週報_\(UserManager.shared.startDateFile ?? "111-06-13")_to_\(UserManager.shared.endDateFile ?? "111-06-17")"
//                UserDefaults.standard.set(fileName ,forKey: "outputFileName")
//                print(UserDefaults.standard.string(forKey: "outputFileName")!)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                    reportViewModel.exportViewToPDF()
//                }
//            }
            
            Button("預覽ＰＤＦ") {
                fileName = "\(UserDefaults.standard.string(forKey: "userName") ?? "姓名")-工作週報_\(UserManager.shared.startDateFile ?? "111-06-13")_to_\(UserManager.shared.endDateFile ?? "111-06-17")"
                UserDefaults.standard.set(fileName ,forKey: "outputFileName")
                print(UserDefaults.standard.string(forKey: "outputFileName")!)
                
                DispatchQueue.main.async {
                    
                    reportViewModel.exportViewToPDF()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isShowingPDFSheet.toggle()
                    }
                }
            }
            
            Button("寄送ＰＤＦ") {
                isShowingMailView.toggle()
            }
            
            Button("取消", role: .cancel) {
            }
        })
        .sheet(isPresented: $isShowingEditSheet) {
            EditView()
        }
        
        .sheet(isPresented: $isShowingPDFSheet) {
            PDFKitRepresentedView(reportViewModel.outputFileURL)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result, fileName: self.$fileName)
        }
    }
    
    private var nameTextView: some View {
        
        HStack {
            
            Text("姓名")
                .font(.caption.bold())
                .frame(maxWidth: 22.5, maxHeight: 16) // 14.5
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
            
            Text("\(UserDefaults.standard.string(forKey: "userName") ?? "")")
                .font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var titleTextView: some View {
        
        HStack {
            
            Text("職稱")
                .font(.caption.bold())
                .frame(maxWidth: 22.5, maxHeight: 16)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
            
            Text("\(UserDefaults.standard.string(forKey: "userTitle") ?? "")")
                .font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var weekTextView: some View {
        
        HStack {
            
            Text("期間")
                .font(.caption.bold())
                .frame(maxWidth: 22.5, maxHeight: 16)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
            
            Text("\(UserManager.shared.startDateString ?? "111/06/13") ~ \(UserManager.shared.endDateString ?? "111/06/17")")
                .font(.caption2)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    func stringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
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
    
    func dateToStringMMDD(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        let string = dateFormatter.string(from: date)
        return string
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var fileName: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let urlString = "<privateurl>"
        let url = URL(string: urlString)

        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["\(UserDefaults.standard.string(forKey: "userEmail")!)"])
        vc.setMessageBody("\(UserDefaults.standard.string(forKey: "outputFileName")!)", isHTML: true)
        vc.setSubject("\(UserDefaults.standard.string(forKey: "outputFileName")!)")
    
        
        let docDirectory = getDocumentsDirectory()
        let filePath = docDirectory.appendingPathComponent("\(UserDefaults.standard.string(forKey: "outputFileName")!).pdf")

        if let fileData = NSData(contentsOf: filePath) {
                 print("File data loaded.")
                 vc.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "\(UserDefaults.standard.string(forKey: "outputFileName")!).pdf")
         }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(userName: <#T##Binding<String>#>)
//            .environmentObject(ReportViewModel())
//    }
//}

//            Button(".") {
//                showingSheet.toggle()
//            }
//            .sheet(isPresented: $showingSheet) {
//                PDFKitRepresentedView(reportViewModel.outputFileURL)
//            }
            
//            Button {
//                reportViewModel.exportHtmlToPdf("1233333", title: "11")
//            } label: {
//                Text("Button HTML")
//                    .bold()
//            }
//
//            Spacer()
//
//            Button("Show HTML Sheet") {
//                showingSheet2.toggle()
//            }
//            .sheet(isPresented: $showingSheet2) {
//                PDFKitRepresentedView(reportViewModel.outputHtmlURL!)
//            }
