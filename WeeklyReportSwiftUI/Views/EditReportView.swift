//
//  EditReportView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/12.
//

import SwiftUI
import UIKit

struct EditReportView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var reportManager: ReportViewModel
    
    @AppStorage("isHiddenViews") var isHiddenViews: Bool = true
    @AppStorage("isAppended") var isAppended: Bool = false
    
    @State var userToEmail: String = ""
    @State var userCcEmail: String = ""
    @State var userBccEmail: String = ""
    @State var userEmailContent: String = ""
    @State var userEmailSignature: String = ""
    
    @State var userEmailAppendText: String = ""
    
    @State var userName: String = ""
    @State var userTitle: String = ""
    @State var missions: String = ""
    @State var mondayMorningDetails: String = ""
    @State var mondayAfternoonDetails: String = ""
    @State var tuesdayMorningDetails: String = ""
    @State var tuesdayAfternoonDetails: String = ""
    @State var wednesdayMorningDetails: String = ""
    @State var wednesdayAfternoonDetails: String = ""
    @State var thursdayMorningDetails: String = ""
    @State var thursdayAfternoonDetails: String = ""
    @State var fridayMorningDetails: String = ""
    @State var fridayAfternoonDetails: String = ""
    @State var thisWeekPlan: String = ""
    @State var nextWeekPlan: String = ""
    @State var suggestion: String = ""
    
    @State var isShowSaveAlert: Bool = false
    
    @AppStorage("userToEmail") var asUserToEmail: String = ""
    @AppStorage("userCcEmail") var asUserCcEmail: String = ""
    @AppStorage("userBccEmail") var asUserBccEmail: String = ""
    
    @AppStorage("outputFileName") var asOutputFileName: String = ""
    @AppStorage("userEmailContent") var asUserEmailContent: String = ""
    @AppStorage("userEmailSignature") var asUserEmailSignature: String = ""

    @AppStorage("userName") var asUserName: String = ""
    @AppStorage("userTitle") var asUserTitle: String = ""
    @AppStorage("missions") var asMissions: String = ""
    @AppStorage("thisWeekPlan") var asThisWeekPlan: String = ""
    @AppStorage("nextWeekPlan") var asNextWeekPlan: String = ""
    @AppStorage("suggestion") var asSuggestion: String = ""
    
    @AppStorage("mondayMorningDetails") var asMondayMorningDetails: String = ""
    @AppStorage("mondayAfternoonDetails") var asMondayAfternoonDetails: String = ""
    @AppStorage("tuesdayMorningDetails") var asTuesdayMorningDetails: String = ""
    @AppStorage("tuesdayAfternoonDetails") var asTuesdayAfternoonDetails: String = ""
    @AppStorage("wednesdayMorningDetails") var asWednesdayMorningDetails: String = ""
    @AppStorage("wednesdayAfternoonDetails") var asWednesdayAfternoonDetails: String = ""
    @AppStorage("thursdayMorningDetails") var asThursdayMorningDetails: String = ""
    @AppStorage("thursdayAfternoonDetails") var asThursdayAfternoonDetails: String = ""
    @AppStorage("fridayMorningDetails") var asFridayMorningDetails: String = ""
    @AppStorage("fridayAfternoonDetails") var asFridayAfternoonDetails: String = ""

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                HStack {
                    
                    Text("郵件內容：")
                        .font(.adaptive(size: 24).bold())
                        .foregroundColor(Color.homeGreenColor)
                        .padding()
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) {
                            taskManager.impactLight.impactOccurred()
                            isHiddenViews.toggle()
                        }
                    } label: {

                        Image(systemName: "chevron.down")
                            .rotationEffect(
                                withAnimation(.easeInOut){
                                    Angle(degrees: isHiddenViews ? 0 : 180)
                                }
                            )
                            .padding()
                            .font(.adaptive(size: 24))
                            .foregroundColor(Color.homeGreenColor)
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 20)
                        
                    }
                }
                
                Group {
                    
                    if isHiddenViews == false {
                        
                        CustomTextField(textTitle: "請輸入收件Email：", textPlaceHolder: "defaultToUser@email.com", textColor: Color.homeGreenColor, textContent: $userToEmail)
                        
                        CustomTextField(textTitle: "請輸入副本Email (不需要直接清空即可)：", textPlaceHolder: "defaultCcUser@email.com", textColor: Color.homeGreenColor, textContent: $userCcEmail)
                        
                        CustomTextField(textTitle: "請輸入密件副本Email (不需要直接清空即可)：", textPlaceHolder: "defaultBccUser@email.com", textColor: Color.homeGreenColor, textContent: $userBccEmail)
                        
                        CustomTextField(textTitle: "請輸入郵件標題 (預設為附檔名)：", textPlaceHolder: "", textColor: Color.homeGreenColor, textContent: $asOutputFileName)
                        
                        CustomTextEditor(textTitle: "請輸入郵件內容 (預設無, 換行請打<br />)：", textColor: Color.homeGreenColor, textContent: $userEmailContent)
                        
                        CustomTextEditor(textTitle: "請輸入簽名檔 (預設無, 換行請打<br />)：", textColor: Color.homeGreenColor, textContent: $userEmailSignature)

                        VStack(alignment: .leading, spacing: 8) {
                            
                            Text("請選擇是否在郵件中附上週報純文字：")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.adaptive(size: 12))
                                .foregroundColor(Color.homeGreenColor)
                            
                            Toggle("", isOn: $isAppended)
                                .labelsHidden()
                                .padding()
                                .offset(x: -15)
                                .tint(Color.homeGreenColor)
                        }
                        .padding([.horizontal, .bottom])

                    }
                }
                
                Divider()
                
                HStack {
                    
                    Text("週報內容：")
                        .font(.adaptive(size: 24).bold())
                        .foregroundColor(Color.PrimaryDark)
                        .padding()
                    
                    Spacer()
                    
                }
                
                Group {
                    
                    CustomTextField(textTitle: "請輸入姓名：", textPlaceHolder: "使用者姓名", textColor: Color.PrimaryDark, textContent: $userName)
                    
                    CustomTextField(textTitle: "請輸入職稱：", textPlaceHolder: "使用者職稱", textColor: Color.PrimaryDark, textContent: $userTitle)
                    
                    CustomTextEditor(textTitle: "請輸入主管交辦任務：", textColor: Color.PrimaryDark, textContent: $missions)
                    
                    Group {
                        
                        DayCustomTextField(textTitle: "週一(\(UserManager.shared.mondayString ?? ""))工作細項：", textColor: Color.PrimaryDark, text1PlaceHolder: "\(UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "週一早上細項")", text1Content: $mondayMorningDetails, text2PlaceHolder: "\(UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "週一下午細項")", text2Content: $mondayAfternoonDetails)
                        
                        DayCustomTextField(textTitle: "週二(\(UserManager.shared.tuesdayString ?? ""))工作細項：", textColor: Color.PrimaryDark, text1PlaceHolder: "\(UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "週二早上細項")", text1Content: $tuesdayMorningDetails, text2PlaceHolder: "\(UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "週二下午細項")", text2Content: $tuesdayAfternoonDetails)
                        
                        DayCustomTextField(textTitle: "週三(\(UserManager.shared.wednesdayString ?? ""))工作細項：", textColor: Color.PrimaryDark, text1PlaceHolder: "\(UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "週三早上細項")", text1Content: $wednesdayMorningDetails, text2PlaceHolder: "\(UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "週三下午細項")", text2Content: $wednesdayAfternoonDetails)
                        
                        DayCustomTextField(textTitle: "週四(\(UserManager.shared.thursdayString ?? ""))工作細項：", textColor: Color.PrimaryDark, text1PlaceHolder: "\(UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "週四早上細項")", text1Content: $thursdayMorningDetails, text2PlaceHolder: "\(UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "週四下午細項")", text2Content: $thursdayAfternoonDetails)
                        
                        DayCustomTextField(textTitle: "週五(\(UserManager.shared.fridayString ?? ""))工作細項：", textColor: Color.PrimaryDark, text1PlaceHolder: "\(UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "週五早上細項")", text1Content: $fridayMorningDetails, text2PlaceHolder: "\(UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "週五下午細項")", text2Content: $fridayAfternoonDetails)
                    }

                    CustomTextEditor(textTitle: "請輸入本週工作摘要：", textColor: Color.PrimaryDark, textContent: $thisWeekPlan)
                    
                    CustomTextEditor(textTitle: "請輸入下週工作計畫：", textColor: Color.PrimaryDark, textContent: $nextWeekPlan)
                    
                    CustomTextEditor(textTitle: "請輸入建議及協助事項：", textColor: Color.PrimaryDark, textContent: $suggestion)

                }
                
                Spacer(minLength: 80)
                
            }
            
            Button {
                saveChanges()
                isShowSaveAlert = true
                
                let impactRigid = UIImpactFeedbackGenerator(style: .rigid)
                let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                impactRigid.impactOccurred()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    impactHeavy.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        isShowSaveAlert = false
                    }
                }
            } label: {
                Text("儲存")
                    .font(.adaptive(size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical)
                    .frame(height: 42)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.SecondaryBlue)
                    .cornerRadius(8)
            }
            .padding()
//            .padding(.bottom, 20)

            if isShowSaveAlert {
                CheckedView()
            }
            
        }
        .padding()
        .onAppear {
            
            userToEmail = asUserToEmail
            userCcEmail = asUserCcEmail
            userBccEmail = asUserBccEmail
            userEmailContent = asUserEmailContent
            userEmailSignature = asUserEmailSignature
            userEmailAppendText = ""
            UserDefaults.standard.set("", forKey: "userEmailAppendText")

            userName = asUserName
            userTitle = asUserTitle
            missions = asMissions
            mondayMorningDetails = asMondayMorningDetails
            mondayAfternoonDetails = asMondayAfternoonDetails
            tuesdayMorningDetails = asTuesdayMorningDetails
            tuesdayAfternoonDetails = asTuesdayAfternoonDetails
            wednesdayMorningDetails = asWednesdayMorningDetails
            wednesdayAfternoonDetails = asWednesdayAfternoonDetails
            thursdayMorningDetails = asThursdayMorningDetails
            thursdayAfternoonDetails = asThursdayAfternoonDetails
            fridayMorningDetails = asFridayMorningDetails
            fridayAfternoonDetails = asFridayAfternoonDetails
            thisWeekPlan = asThisWeekPlan
            nextWeekPlan = asNextWeekPlan
            suggestion = asSuggestion
        }
        
    }
    
    struct ClearButton: ViewModifier {
        @Binding var text: String
        public func body(content: Content) -> some View {
            ZStack(alignment: .trailing) {
                content
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    })
                    {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(uiColor: .systemGray2))
                    }
                    .padding(.trailing, 8)
                }
            }
        }
    }
    
    struct ClearEditorButton: ViewModifier {
        @Binding var text: String
        public func body(content: Content) -> some View {
            ZStack(alignment: .topTrailing) {
                content
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    })
                    {
                        Image(systemName: "multiply.square")
                            .foregroundColor(Color(uiColor: .systemGray2))
//                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding([.bottom], 2)
                }
            }
        }
    }
    
    func saveChanges(){

        DispatchQueue.main.async {
            saveText()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                saveText()
                UserDefaults.standard.set(userEmailAppendText, forKey: "userEmailAppendText")
            }
        }
        
        UserDefaults.standard.set(userToEmail, forKey: "userToEmail")
        UserDefaults.standard.set(userCcEmail, forKey: "userCcEmail")
        UserDefaults.standard.set(userBccEmail, forKey: "userBccEmail")

        UserDefaults.standard.set(userEmailContent, forKey: "userEmailContent")
        UserDefaults.standard.set(userEmailSignature, forKey: "userEmailSignature")
        
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(userTitle, forKey: "userTitle")
        UserDefaults.standard.set(missions ,forKey: "missions")

        UserDefaults.standard.set(mondayMorningDetails ,forKey: "mondayMorningDetails")
        UserDefaults.standard.set(mondayAfternoonDetails ,forKey: "mondayAfternoonDetails")
        UserDefaults.standard.set(tuesdayMorningDetails ,forKey: "tuesdayMorningDetails")
        UserDefaults.standard.set(tuesdayAfternoonDetails ,forKey: "tuesdayAfternoonDetails")
        UserDefaults.standard.set(wednesdayMorningDetails ,forKey: "wednesdayMorningDetails")
        UserDefaults.standard.set(wednesdayAfternoonDetails ,forKey: "wednesdayAfternoonDetails")
        UserDefaults.standard.set(thursdayMorningDetails ,forKey: "thursdayMorningDetails")
        UserDefaults.standard.set(thursdayAfternoonDetails ,forKey: "thursdayAfternoonDetails")
        UserDefaults.standard.set(fridayMorningDetails ,forKey: "fridayMorningDetails")
        UserDefaults.standard.set(fridayAfternoonDetails ,forKey: "fridayAfternoonDetails")
        
        UserDefaults.standard.set(thisWeekPlan ,forKey: "thisWeekPlan")
        UserDefaults.standard.set(nextWeekPlan ,forKey: "nextWeekPlan")
        UserDefaults.standard.set(suggestion ,forKey: "suggestion")

    }
    
    func saveText() {
        
        isAppended.toggle()
        
        if isAppended {
            
            userEmailAppendText = "<br/><hr><br/>姓名：\(userName)<br/>職稱：\(userTitle)<br />期間：\(UserManager.shared.startDateString ?? "111/06/13") ~ \(UserManager.shared.endDateString ?? "111/06/17")<br/><hr style=\"border-style: dotted;\" />主管交辦任務：<br/>\(missions)<br /><hr style=\"border-style: dotted;\" />細部摘要(一)：\(UserManager.shared.mondayString ?? "06/13")<br/>早：\(UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "")<br/>午：\(UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "")<p/>細部摘要(二)：\(UserManager.shared.tuesdayString ?? "06/13")<br/>早：\(UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "")<br/>午：\(UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "")<p/>細部摘要(三)：\(UserManager.shared.wednesdayString ?? "06/13")<br/>早：\(UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "")<br/>午：\(UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "")<p/>細部摘要(四)：\(UserManager.shared.thursdayString ?? "06/13")<br/>早：\(UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "")<br/>午：\(UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "")<p/>細部摘要(五)：\(UserManager.shared.fridayString ?? "06/13")<br/>早：\(UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "")<br/>午：\(UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "")<hr style=\"border-style: dotted;\" />本週工作摘要：<br/>\(thisWeekPlan)<br/><hr style=\"border-style: dotted;\" />下週工作計畫：<br/>\(nextWeekPlan)<br/><hr style=\"border-style: dotted;\" />建議協助事項：<br/>\(suggestion)<br/><hr style=\"border-style: dotted;\" />"
            
        } else {
            userEmailAppendText = ""
        }
    }

}

struct CustomTextField: View {
    
    var textTitle: String
    var textPlaceHolder: String
    var textColor: Color
    @Binding var textContent: String

    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(textTitle)
                .font(.adaptive(size: 12))
                .foregroundColor(textColor)

            TextField(textPlaceHolder, text: $textContent)
                .modifier(ClearButton(text: $textContent))
                .padding([.vertical, .leading], 12)
                .padding(.trailing, 4)
                .frame(height: 42, alignment: .leading)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: textContent.isEmpty ? 2 : 1)
                        .foregroundColor(textContent.isEmpty ? Color.Error : textColor)
                )
        }
        .padding([.horizontal, .bottom])
    }
    
    struct ClearButton: ViewModifier {
        @Binding var text: String
        public func body(content: Content) -> some View {
            ZStack(alignment: .trailing) {
                content
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    })
                    {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(uiColor: .systemGray2))
                    }
                    .padding(.trailing, 8)
                }
            }
        }
    }
}

struct DayCustomTextField: View {
    
    var textTitle: String
    var textColor: Color
    var text1PlaceHolder: String
    @Binding var text1Content: String
    var text2PlaceHolder: String
    @Binding var text2Content: String

    var body: some View {
        
        VStack (alignment: .leading, spacing: 8) {
            
            Text(textTitle)
                .font(.adaptive(size: 12))
                .foregroundColor(textColor)

            HStack(spacing: 2) {
                Text("早：")
                    .font(.adaptive(size: 12))
                    .foregroundColor(textColor)
                
                TextField(text1PlaceHolder, text: $text1Content).modifier(ClearButton(text: $text1Content))
                    .padding([.vertical, .leading], 12)
                    .padding(.trailing, 4)
                    .frame(height: 42, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: text1Content.isEmpty ? 2 : 1)
                            .foregroundColor(text1Content.isEmpty ? Color.Error : textColor)
                    )
                    .ignoresSafeArea(.keyboard, edges: .bottom)

            }
            
            HStack(spacing: 2) {
                
                Text("午：")
                    .font(.adaptive(size: 12))
                    .foregroundColor(textColor)
                
                TextField(text2PlaceHolder, text: $text2Content).modifier(ClearButton(text: $text2Content))
                    .padding([.vertical, .leading], 12)
                    .padding(.trailing, 4)
                    .frame(height: 42, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: text2Content.isEmpty ? 2 : 1)
                            .foregroundColor(text2Content.isEmpty ? Color.Error : textColor)
                    )
                    .ignoresSafeArea(.keyboard, edges: .bottom)

            }
        }
        .padding([.horizontal, .bottom])
    }
    
    struct ClearButton: ViewModifier {
        @Binding var text: String
        public func body(content: Content) -> some View {
            ZStack(alignment: .trailing) {
                content
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    })
                    {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(uiColor: .systemGray2))
                    }
                    .padding(.trailing, 8)
                }
            }
        }
    }
}

struct CustomTextEditor: View {
    
    var textTitle: String
    var textColor: Color
    @Binding var textContent: String

    var body: some View {
        
        VStack (alignment: .leading, spacing: 8) {

            Text(textTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.adaptive(size: 12))
                .foregroundColor(textColor)
            
            TextEditor(text: $textContent)
                .padding(.leading, 12)
                .padding(.top, 6)
                .frame(height: 100, alignment: .leading)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: textContent.isEmpty ? 2 : 1)
                    .foregroundColor(textContent.isEmpty ? Color.Error : textColor)
                )

        }
        .padding([.horizontal, .bottom])
    }

}




struct EditReportView_Previews: PreviewProvider {
    static var previews: some View {
        EditReportView()
            .environmentObject(TaskManager())
            .environmentObject(ReportViewModel())
    }
}

