//
//  EditView.swift
//  WeeklyReportSwiftUI
//
//  Created by Ryan@work on 2022/6/21.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var reportViewModel = ReportViewModel()
    
    @State private var userEmail: String
    @State private var userName: String
    @State private var userTitle: String
    @State private var startMonth: String
    @State private var startDay: String
    @State private var missions: String
    @State private var mondayMorningDetails: String
    @State private var mondayAfternoonDetails: String
    @State private var tuesdayMorningDetails: String
    @State private var tuesdayAfternoonDetails: String
    @State private var wednesdayMorningDetails: String
    @State private var wednesdayAfternoonDetails: String
    @State private var thursdayMorningDetails: String
    @State private var thursdayAfternoonDetails: String
    @State private var fridayMorningDetails: String
    @State private var fridayAfternoonDetails: String
    @State private var thisWeekPlan: String
    @State private var nextWeekPlan: String
    @State private var suggestion: String
    
    @State var isShowSaveAlert = false
    @State var isShowClearAlert = false
    
    init(){
        
        UserDefaults.standard.set("陳俊宏-工作週報_111-06-13_to_111-06-17", forKey: "outputFileName")
        userEmail = UserDefaults.standard.string(forKey: "userEmail") ?? "default@email.com"
        userName = UserDefaults.standard.string(forKey: "userName") ?? "你的名字"
        userTitle = UserDefaults.standard.string(forKey: "userTitle") ?? "你的職稱"
        startMonth = UserDefaults.standard.string(forKey: "startMonth") ?? "開始月"
        startDay = UserDefaults.standard.string(forKey: "startDay") ?? "開始日"
        missions = UserDefaults.standard.string(forKey: "missions") ?? "主管交辦任務"
        mondayMorningDetails = UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "週一早上細項"
        mondayAfternoonDetails = UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "週一下午細項"
        tuesdayMorningDetails = UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "週二早上細項"
        tuesdayAfternoonDetails = UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "週二下午細項"
        wednesdayMorningDetails = UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "週三早上細項"
        wednesdayAfternoonDetails = UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "週三下午細項"
        thursdayMorningDetails = UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "週四早上細項"
        thursdayAfternoonDetails = UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "週四下午細項"
        fridayMorningDetails = UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "週五早上細項"
        fridayAfternoonDetails = UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "週五下午細項"
        thisWeekPlan = UserDefaults.standard.string(forKey: "thisWeekPlan") ?? "本週計畫"
        nextWeekPlan = UserDefaults.standard.string(forKey: "nextWeekPlan") ?? "下週計畫"
        suggestion = UserDefaults.standard.string(forKey: "suggestion") ?? "建議與協助事項"

        reportViewModel.dateInitManager()
        
        UserDefaults.standard.set("\(UserDefaults.standard.string(forKey: "userName") ?? "姓名")-工作週報_\(UserManager.shared.startDateFile ?? "111-06-13")_to_\(UserManager.shared.endDateFile ?? "111-06-17")", forKey: "outputFileName")
        
    }
    
    //    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ScrollView {
            
            VStack (alignment: .leading, spacing: 3) {
                
                Text("請輸入收件Email：")
                    .font(.caption)
                    .foregroundColor(.teal)
                
                TextField("\(UserDefaults.standard.string(forKey: "userEmail") ?? "收件Email")", text: $userEmail).modifier(ClearButton(text: $userEmail))
                    .padding(.leading, 7)
                    .frame(height: 40, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: userEmail.isEmpty ? 2 : 1)
                            .foregroundColor(userEmail.isEmpty ? .red : .teal)
                    )
            }
            .padding()
            
            VStack (alignment: .leading, spacing: 3) {
                
                Text("請輸入姓名：")
                    .font(.caption)
                    .foregroundColor(.teal)
                
                TextField("\(UserDefaults.standard.string(forKey: "userName") ?? "你的名字")", text: $userName).modifier(ClearButton(text: $userName))
                    .padding(.leading, 7)
                    .frame(height: 40, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: userName.isEmpty ? 2 : 1)
                            .foregroundColor(userName.isEmpty ? .red : .teal)
                    )
            }
            .padding()
            
            VStack (alignment: .leading, spacing: 3) {
                
                Text("請輸入職稱：")
                    .font(.caption)
                    .foregroundColor(.teal)
                
                TextField("\(UserDefaults.standard.string(forKey: "userTitle") ?? "你的職稱")", text: $userTitle).modifier(ClearButton(text: $userTitle))
                    .padding(.leading, 7)
                    .frame(height: 40, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: userTitle.isEmpty ? 2 : 1)
                            .foregroundColor(userTitle.isEmpty ? .red : .teal)
                    )
            }
            .padding()
            
            HStack{
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("請輸入開始月 (數字)：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    TextField("\(UserDefaults.standard.string(forKey: "startMonth") ?? "開始月")", text: $startMonth).modifier(ClearButton(text: $startMonth))
                        .padding(.leading, 7)
                        .frame(height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: startMonth.isEmpty ? 2 : 1)
                                .foregroundColor(startMonth.isEmpty ? .red : .teal)
                        )
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("請輸入開始日 (數字)：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    TextField("\(UserDefaults.standard.string(forKey: "startDay") ?? "開始日")", text: $startDay).modifier(ClearButton(text: $startDay))
                        .padding(.leading, 7)
                        .frame(height: 40, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: startDay.isEmpty ? 2 : 1)
                                .foregroundColor(startDay.isEmpty ? .red : .teal)
                        )
                }
                .padding()
            }
            
            VStack (alignment: .leading, spacing: 3) {
                
                HStack {
                    Text("請輸入主管交辦任務：")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    Spacer()
                    
                    Text("")
                        .modifier(ClearEditorButton(text: $missions))
                }
                
                
                TextEditor(text: $missions)
                    .frame(height: 100, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: missions.isEmpty ? 2 : 1)
                        .foregroundColor(missions.isEmpty ? .red : .teal)
                    )
                
            }
            .padding()
            
            Group {
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("週一(\(UserManager.shared.mondayString ?? ""))工作細項：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Text("早：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "mondayMorningDetails") ?? "週一早上細項")", text: $mondayMorningDetails).modifier(ClearButton(text: $mondayMorningDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: mondayMorningDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(mondayMorningDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                    HStack {
                        Text("午：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "mondayAfternoonDetails") ?? "週一下午細項")", text: $mondayAfternoonDetails).modifier(ClearButton(text: $mondayAfternoonDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: mondayAfternoonDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(mondayAfternoonDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("週二(\(UserManager.shared.tuesdayString ?? ""))工作細項：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Text("早：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "tuesdayMorningDetails") ?? "週二早上細項")", text: $tuesdayMorningDetails).modifier(ClearButton(text: $tuesdayMorningDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: tuesdayMorningDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(tuesdayMorningDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                    HStack {
                        Text("午：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "tuesdayAfternoonDetails") ?? "週二下午細項")", text: $tuesdayAfternoonDetails).modifier(ClearButton(text: $tuesdayAfternoonDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: tuesdayAfternoonDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(tuesdayAfternoonDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("週三(\(UserManager.shared.wednesdayString ?? ""))工作細項：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Text("早：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "wednesdayMorningDetails") ?? "週三早上細項")", text: $wednesdayMorningDetails).modifier(ClearButton(text: $wednesdayMorningDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: wednesdayMorningDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(wednesdayMorningDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                    HStack {
                        Text("午：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "wednesdayAfternoonDetails") ?? "週三下午細項")", text: $wednesdayAfternoonDetails).modifier(ClearButton(text: $wednesdayAfternoonDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: wednesdayAfternoonDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(wednesdayAfternoonDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("週四(\(UserManager.shared.thursdayString ?? ""))工作細項：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Text("早：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "thursdayMorningDetails") ?? "週四早上細項")", text: $thursdayMorningDetails).modifier(ClearButton(text: $thursdayMorningDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: thursdayMorningDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(thursdayMorningDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                    HStack {
                        Text("午：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "thursdayAfternoonDetails") ?? "週四下午細項")", text: $thursdayAfternoonDetails).modifier(ClearButton(text: $thursdayAfternoonDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: thursdayAfternoonDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(thursdayAfternoonDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                }
                .padding()
                
                VStack (alignment: .leading, spacing: 3) {
                    
                    Text("週五(\(UserManager.shared.fridayString ?? ""))工作細項：")
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    HStack {
                        Text("早：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "fridayMorningDetails") ?? "週五早上細項")", text: $fridayMorningDetails).modifier(ClearButton(text: $fridayMorningDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: fridayMorningDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(fridayMorningDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                    HStack {
                        Text("午：")
                            .foregroundColor(.teal)
                        
                        TextField("\(UserDefaults.standard.string(forKey: "fridayAfternoonDetails") ?? "週五下午細項")", text: $fridayAfternoonDetails).modifier(ClearButton(text: $fridayAfternoonDetails))
                            .padding(.leading, 7)
                            .frame(height: 40, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: fridayAfternoonDetails.isEmpty ? 2 : 1)
                                    .foregroundColor(fridayAfternoonDetails.isEmpty ? .red : .teal)
                            )
                    }
                    
                }
                .padding()
            }
            
            
            
            VStack (alignment: .leading, spacing: 3) {
                
                HStack {
                    Text("請輸入本週工作摘要：")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    Spacer()
                    
                    Text("")
                        .modifier(ClearEditorButton(text: $thisWeekPlan))
                }
                
                
                TextEditor(text: $thisWeekPlan)
                    .frame(height: 100, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: thisWeekPlan.isEmpty ? 2 : 1)
                        .foregroundColor(thisWeekPlan.isEmpty ? .red : .teal)
                    )
                
            }
            .padding()
            
            VStack (alignment: .leading, spacing: 3) {
                
                HStack {
                    Text("請輸入下週工作計畫：")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    Spacer()
                    
                    Text("")
                        .modifier(ClearEditorButton(text: $nextWeekPlan))
                }
                
                TextEditor(text: $nextWeekPlan)
                    .frame(height: 100, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: nextWeekPlan.isEmpty ? 2 : 1)
                        .foregroundColor(nextWeekPlan.isEmpty ? .red : .teal)
                    )
                
            }
            .padding()
            
            VStack (alignment: .leading, spacing: 3) {
                
                HStack {
                    Text("請輸入建議及協助事項：")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption)
                        .foregroundColor(.teal)
                    
                    Spacer()
                    
                    Text("")
                        .modifier(ClearEditorButton(text: $suggestion))
                }
                
                TextEditor(text: $suggestion)
                    .frame(height: 100, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: suggestion.isEmpty ? 2 : 1)
                        .foregroundColor(suggestion.isEmpty ? .red : .teal)
                    )
                
            }
            .padding()
            
            HStack {
                deleteButton
                
                if FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).isEmpty {
                    saveButton.hidden()
                } else {
                    saveButton
                }
            }
        }
        .padding()
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
                        Image(systemName: "delete.left")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
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
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                    .padding([.bottom], 2)
                }
            }
        }
    }
}

extension EditView {
    
    private var saveButton: some View{
        
        Button {
            
            UserDefaults.standard.set(userEmail, forKey: "userEmail")
            UserDefaults.standard.set(userName, forKey: "userName")
            UserDefaults.standard.set(userTitle, forKey: "userTitle")
            UserDefaults.standard.set(startMonth, forKey: "startMonth")
            UserDefaults.standard.set(startDay, forKey: "startDay")
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
            
            reportViewModel.dateInitManager()
            
            isShowSaveAlert.toggle()
            
            //                presentation.wrappedValue.dismiss()
            
        } label: {
            Text("SAVE")
                .font(.headline.bold())
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .padding([.vertical], 6)
        }
        .tint(.teal)
        .padding()
        .buttonStyle(.borderedProminent)
        .alert("已儲存", isPresented: $isShowSaveAlert) {
            //                self.presentationMode.wrappedValue.dismiss()
            //                presentation.wrappedValue.dismiss()
        }
    }
    
    private var deleteButton: some View{
        
        Button(role: .destructive) {
            
            //            reportViewModel.clearDiskCache()
            reportViewModel.clearAllFile()
            isShowClearAlert.toggle()
            
        } label: {
            Text("CLEAN FOLDER")
                .font(.headline.bold())
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .padding([.vertical], 6)
        }
        .padding()
        .buttonStyle(.borderedProminent)
        .alert("已刪除", isPresented: $isShowClearAlert) {
            
            //                self.presentationMode.wrappedValue.dismiss()
            //                presentation.wrappedValue.dismiss()
        }
        
    }
}


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
