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
    
    @State var isRefresh: Bool = false
    
    @State var PDFUrl: URL?
    @State var isShowingShareSheet = false
   
    var isMini: Bool = false
    
    init(){
        reportViewModel.dateInitManager()
        
        switch UIDevice().type {
        case .iPhone12Mini, .iPhone13Mini: isMini = true
        default: isMini = false
        }
    }
    
    var body: some View {
        
        VStack {
            
            alertButton
                .background(.white)
            
            VStack(alignment: .leading, spacing: 0) {
                
                nameTextView
                titleTextView
                weekTextView
                missionsView

                workingStatusView
                
                workingPlanThisWeek
                workingPlanNextWeek
                workingSuggestion

            }
            .padding()
            .offset(x: 4)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

extension ContentView {
    
    private var alertButton: some View {
        
        Button {
            
            isShowAlert = true
            
        } label: {
            Text("工作週報")
                .font(.system(size: 16).bold())
                .foregroundColor(.black)
                .bold()
        }
        .alert("選擇動作", isPresented: $isShowAlert, actions: {
            
            Button("編輯ＰＤＦ", role: .destructive) {
                isShowingEditSheet.toggle()
            }
            
            Button("預覽ＰＤＦ") {
                
                reportViewModel.clearAllFile()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    reportViewModel.exportViewToPDF()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isShowingPDFSheet.toggle()
                    }
                }
            }
            
            Button("寄送ＰＤＦ") {
                
//                UserDefaults.standard.set("\(UserDefaults.standard.string(forKey: "userName") ?? "姓名")-工作週報_\(UserManager.shared.startDateFile ?? "111-06-13")_to_\(UserManager.shared.endDateFile ?? "111-06-17")", forKey: "outputFileName")
                
                reportViewModel.clearAllFile()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    reportViewModel.exportViewToPDF()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isShowingMailView.toggle()
                    }
                }
            }
            
            Button("分享ＰＤＦ"){
                
                let group = DispatchGroup()
                group.enter()
                reportViewModel.clearAllFile()
                group.leave()
                group.wait()
                group.enter()
                reportViewModel.exportViewToPDF()
                self.PDFUrl = reportViewModel.outputFileURL
                isShowingShareSheet.toggle()
   
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
        .sheet(isPresented: $isShowingShareSheet) {
            PDFUrl = nil
        } content: {
            if let PDFUrl = PDFUrl {
                ShareSheet(urls: [PDFUrl])
            }
        }
    }
    
    private var nameTextView: some View {
        
        HStack {
            
            Text("姓名")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 16) // 14.5
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "userName") ?? "")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var titleTextView: some View {
        
        HStack {
            
            Text("職稱")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 16)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "userTitle") ?? "")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var weekTextView: some View {
        
        HStack {
            
            Text("期間")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 16)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserManager.shared.startDateString ?? "111/06/13") ~ \(UserManager.shared.endDateString ?? "111/06/17")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 16, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
            
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var missionsView: some View {
        
        HStack {
            Text("主管\n交辦\n任務")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 60)// 46.5
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "missions") ?? "")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
        }
        .padding(0)
        .background(Color.white)
    }
    
    private var workingStatusView: some View {
        
        HStack {
            Text("本\n週\n工\n作\n細\n部\n摘\n要")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 288)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            VStack (spacing: 0){
                Text("一、\(UserManager.shared.mondayString ?? "06/13")\n早：\(UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(5)
                    .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
                
                Text("二、\(UserManager.shared.tuesdayString ?? "06/14")\n早：\(UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(5)
                    .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
                
                Text("三、\(UserManager.shared.wednesdayString ?? "06/15")\n早：\(UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(5)
                    .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
                
                Text("四、\(UserManager.shared.thursdayString ?? "06/16")\n早：\(UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(5)
                    .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
                
                Text("五、\(UserManager.shared.fridayString ?? "06/17")\n早：\(UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "")\n午：\(UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "")")
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
                    .padding(5)
                    .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
            }
        }
        .padding(0)
        .background(Color.white)
        
    }
    
    private var workingPlanThisWeek: some View {
        
        HStack {
            Text("本週\n工作\n摘要")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 60)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "thisWeekPlan") ?? "本週計畫")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
        }
        .padding(0)
        .background(Color.white)
        
    }
    
    private var workingPlanNextWeek: some View {
        
        HStack {
            Text("次週\n工作\n計畫")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 60)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "nextWeekPlan") ?? "下週計畫")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
        }
        .padding(0)
        .background(Color.white)
        
    }
    
    private var workingSuggestion: some View {
        
        HStack {
            Text("建議\n以及\n需要\n協助\n事項")
                .font(.system(size: 10.5).bold())
                .foregroundColor(.black)
                .frame(maxWidth: 25, maxHeight: 80)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
            
            Text("\(UserDefaults.standard.string(forKey: "suggestion") ?? "無")")
                .font(.system(size: 10))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: 80, alignment: .leading)
                .padding(6)
                .overlay(Rectangle().stroke(lineWidth: 1).foregroundColor(.black))
                .offset(x: -8)
        }
        .padding(0)
        .background(Color.white)
        
    }
}

// MARK: PDF Preview Sheet
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

// MARK: Mail Sheet
struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @ObservedObject var reportViewModel = ReportViewModel()
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var fileName: String
    
    @State var outputFileName = UserDefaults.standard.string(forKey: "outputFileName")!

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
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let urlString = "<privateurl>"
        let url = URL(string: urlString)
        let userToEmail = UserDefaults.standard.string(forKey: "userToEmail") ?? "defaultToUser@email.com"
        let userCcEmail = UserDefaults.standard.string(forKey: "userCcEmail") ?? ""
        let userBccEmail = UserDefaults.standard.string(forKey: "userBccEmail") ?? ""
        var userEmailTitle = outputFileName
        var userEmailContent = UserDefaults.standard.string(forKey: "userEmailContent")!
        var userEmailSignature = UserDefaults.standard.string(forKey: "userEmailSignature")!
        var userEmailAppendText = UserDefaults.standard.string(forKey: "userEmailAppendText") ?? ""

        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(["\(userToEmail)"])
        
        if userCcEmail != "" {
            vc.setCcRecipients(["\(userCcEmail)"])
        }
        
        if userBccEmail != "" {
            vc.setBccRecipients(["\(userBccEmail)"])
        }

        vc.setSubject("\(userEmailTitle)")
        vc.setMessageBody("\(userEmailContent)\n<hr>\n\(userEmailSignature)\(userEmailAppendText)", isHTML: true)
        vc.reloadInputViews()
    
        let docDirectory = getDocumentsDirectory()
        let filePath = docDirectory.appendingPathComponent("\(outputFileName).pdf")

        if let fileData = NSData(contentsOf: filePath) {
                 print("File data loaded.")
                 vc.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "\(outputFileName).pdf")
         }
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

// MARK: Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    
    var urls: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
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
