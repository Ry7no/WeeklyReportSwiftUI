//
//  AddTaskView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import SwiftUI

struct AddTaskView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedCategory: Int?
    
    @State private var showDatePicker: Bool = false
    
    // AppStorage Site
    @AppStorage("asProjectArray") var asProjectArray: [String] = []
    @AppStorage("asMeetingArray") var asMeetingArray: [String] = []
    @AppStorage("asProgramArray") var asProgramArray: [String] = []
    @AppStorage("asDayOffArray") var asDayOffArray: [String] = []
    @AppStorage("asProjectItemArray") var asProjectItemArray: [String] = []
    @AppStorage("asMeetingItemArray") var asMeetingItemArray: [String] = []
    @AppStorage("asProgramItemArray") var asProgramItemArray: [String] = []
    @AppStorage("asDayOffItemArray") var asDayOffItemArray: [String] = []
    
    @AppStorage("combineProject") var combineProject: Bool = true
    @AppStorage("combineMeeting") var combineMeeting: Bool = false
    @AppStorage("combineProgram") var combineProgram: Bool = true
    @AppStorage("combineDayOffs") var combineDayOffs: Bool = false

    // For EditSheet
    @State private var showEditListView: Bool = false
    @State var editTitle: String = ""
    @State var editStringArray: [String] = []
    @State var isSaving: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    
    @State var isTextField: Bool = false
    
    // For Keyboard
    @State private var isKeyboardShowing = false
    
    var numbers: [Double] {
        stride(from: 0.5, through: 8, by: 0.5).map { $0 }
    }
    
    @State private var selectedNumber: Double = 0.5
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            Color.PrimaryDark
            
            VStack {
                
                HStack {
                    
                    Text(taskManager.isEditing ? "編輯" : "新增")
                        .font(.adaptive(size: 17))
                        .fontWeight(.semibold)
                        .kerning(0.24)
                    
                    Spacer()
                    
                    Button {
                        
                        if taskManager.isEditing {
                            taskManager.selectedTask = Task(taskCategory: "", taskTitle: "", taskDescription: "", taskProgress: 0, taskStartDate: Date(), taskEndDate: Date(), taskMoodLevel: 4)
                            taskManager.isEditing = false
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.adaptive(size: 20))
                    }

                }
                .foregroundColor(Color.PrimaryBase)
                .padding([.top, .horizontal], 20)
                
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color.PrimaryBase)
                    .padding(.top, 3)
                
                ZStack(alignment: .bottom) {
                    
                    ScrollView(.vertical, showsIndicators: false) {

                        // MARK: - 項目心情
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("項目心情")
                                .font(.adaptive(size: 16))
                                .foregroundColor(Color.PrimaryDark)
                            
                            HStack {
                                
                                ForEach(taskManager.moodIconInfos.sorted(by: { $0.key < $1.key }), id: \.key) { key, info in
                                    Button(action: {
                                        
                                        withAnimation {
                                            taskManager.selectedTask.taskMoodLevel = key
                                        }
                                        taskManager.impactLight.impactOccurred()
//                                        self.imageButtonTapped(id: key, responseString: info.responseString)
                                    }) {
                                        
                                        VStack {
                                            
                                            Image(info.imageName)
                                                .renderingMode(.template)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(maxWidth: .infinity)
                                                .frame(height: screenWidth/13)
                                                .background(Circle().fill(taskManager.selectedTask.taskMoodLevel == key ? info.imageColor : .white).padding(-2))
                                            
                                            Text(info.imageString)
                                                .font(.adaptive(size: 10))
                                                .foregroundColor(info.imageColor)
                                        }
                                        .foregroundColor(taskManager.selectedTask.taskMoodLevel == key ? .white : info.imageColor)
                                                            
                                    }
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)

                            
                        }
                        .padding(20)
                        .background {
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding([.horizontal])
                        .padding(.top, 10)
                        
                        // MARK: - 項目類別
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("項目類別")
                                .font(.adaptive(size: 16))
                                .foregroundColor(Color.PrimaryDark)
                            
                            HStack(spacing: 12) {
                                
                                ForEach(0..<4) { index in
                                    
                                    Button(action: {
                                        
                                        taskManager.impactLight.impactOccurred()
//
                                        withAnimation {
                                            if selectedCategory == index {
                                                selectedCategory = nil
                                            } else {
                                                selectedCategory = index
                                            }
                                            
                                        }
                                        
                                    }) {
                                        Text(optionTitle(for: index))
                                            .foregroundColor(selectedCategory == index ? Color.white : Color.PrimaryBase)
                                            .font(.adaptive(size: 16))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background {
                                                
                                                if selectedCategory == index {
                                                    
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.PrimaryDark)

                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(lineWidth: 1.5)
                                                        .foregroundColor(Color.PrimaryDark)
                                                    
                                                } else {
                                                    
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.BaseBlackOpacity05)
                                                    
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .stroke(lineWidth: 1)
                                                        .foregroundColor(Color.gray.opacity(0.3))
                                                    
                                                }
                                                
                                            }
                                            .cornerRadius(8)
                                    }
                                    .contextMenu {
                                        
                                        switch optionTitle(for: index) {
                                        case "專案":

                                            Button(role: combineProject ? .destructive : .cancel) {
                                                
                                                combineProject.toggle()
                                                
                                            } label: {
                                                HStack {
                                                    Text("週報專案項目：")
                                                    
                                                    Image(systemName: "\(combineProject ? "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill" : "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")")
                                                }
                                                
                                            }

                                        case "會議":
                                            
                                            Button(role: combineMeeting ? .destructive : .cancel) {
                                                
                                                combineMeeting.toggle()
                                                
                                            } label: {
                                                HStack {
                                                    Text("週報會議項目：")
                                                    
                                                    Image(systemName: "\(combineMeeting ? "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill" : "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")")
                                                }
                                                
                                            }
                                        case "程式":
                                            Button(role: combineProgram ? .destructive : .cancel) {
                                                
                                                combineProgram.toggle()
                                                
                                            } label: {
                                                HStack {
                                                    Text("週報程式項目：")
                                                    
                                                    Image(systemName: "\(combineProgram ? "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill" : "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")")
                                                }
                                                
                                            }
                                            
                                        case "休假":
                                            
                                            Button(role: combineDayOffs ? .destructive : .cancel) {
                                                
                                                combineDayOffs.toggle()
                                                
                                            } label: {
                                                HStack {
                                                    Text("週報程式項目：")
                                                    
                                                    Image(systemName: "\(combineDayOffs ? "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill" : "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right.fill")")
                                                }
                                                
                                            }
                                            
                                        default:
                                            Button {
                                                
                                            } label: {
                                                
                                            }

                                        }

                                    }
                                }
                                
                                Spacer(minLength: 1)
                            }
                            .padding(.top, 2)
                            .padding(.bottom, 6)
                            
                        }
                        .padding(20)
                        .background {
                            Color.white
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding([.horizontal])
                        .padding(.top, 10)
                        
                        switch selectedCategory {
                            
                        case 0:
                            
                            // MARK: - 類別 -> 專案
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("專案名稱")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                TagHStack(tags: taskManager.projectArray, selectedString: $taskManager.selectedTask.taskTitle)

                                Button {
                                    
                                    DispatchQueue.main.async {
    
                                        editTitle = "專案名稱"
                                        editStringArray = taskManager.projectArray
                                        isSaving = false
                                        taskManager.isSaving = false
                                        showEditListView.toggle()
    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                        }
                                    }
                                    
                                } label: {
                                    HStack {
                                        
                                        Text("新增 / 編輯選項")

                                        Image(systemName: "pencil.line")

                                    }
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                }
                                .padding(.vertical, 3)
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            .onAppear {
                                taskManager.selectedTask.taskCategory = "專案"
                            }

                            // MARK: - 專案開始時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("該項目開始時間(\(taskManager.selectedTask.taskCategory))")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
                                        taskManager.impactSoft.impactOccurred()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                            showDatePicker.toggle()
                                        }
                                    }

                                } label: {
                                    
                                    HStack {
                                        Text(DateManager.shared.dateToStringNoSecondFull(date: taskManager.savedTaskStartDate ?? Date()))
                                            .font(.adaptive(size: 16))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "calendar")
                                            .font(.adaptive(size: 16))
                                            .frame(width: 16, height: 16)
                                        
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                    .foregroundColor(Color.PrimaryDark)
                                    .background {
                                        Color.BaseBlackOpacity05
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(Color.PrimaryBase)
                                    }
                                    
                                }
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 專案花費時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("該項目所需時間(\(taskManager.selectedTask.taskCategory))")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                HourPickerView()
                                    .font(.adaptive(size: 14))
                                
                            }
                            .foregroundColor(Color.PrimaryDark)
                            .padding(20)
                            .padding(.bottom, -10)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 專案進度條
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("該項目\(taskManager.selectedTask.taskCategory)進度條") // 將標題改為進度條
                                        .font(.adaptive(size: 16))
                                    
                                    Spacer()
                                    
                                    Text("\(Int(taskManager.selectedTask.taskProgress))%")
                                        .font(.adaptive(size: 18).bold())
                                }
                                .foregroundColor(Color.PrimaryDark)
                                
                                Slider(
                                    value: $taskManager.selectedTask.taskProgress,
                                    in: 0...100,
                                    step: 5,
                                    onEditingChanged: { editing in
                                        if !editing {
                                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                                            impactLight.impactOccurred()
                                        }
                                    }
                                )
                                .tint(Color.PrimaryDark)
                                .padding(.bottom, -7)

                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 專案描述項目
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Button {
                                        isTextField.toggle()
                                    } label: {
                                        Text("該項目內容描述(\(taskManager.selectedTask.taskCategory))")
                                            .font(.adaptive(size: 16))
                                            .foregroundColor(Color.PrimaryDark)
                                    }
                                    
                                    Spacer()
                                    
                                    if isTextField {
                                        Text("\(taskManager.otherDescription == "請輸入專案內容描述" ? 0 : taskManager.otherDescription.count)/30")
                                            .font(.adaptive(size: 14))
                                            .foregroundColor(taskManager.otherDescription.count == 30 ? Color.Error : Color.gray)
                                    }

                                }
                                
                                if isTextField {
                                    
                                    TextEditor(text: $taskManager.otherDescription)
                                        .font(.adaptive(size: 16))
                                        .padding(5)
                                        .padding(.leading, 5)
                                        .background(Color(UIColor.white))
                                        .frame(height: 60)
                                        .cornerRadius(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1.5).foregroundColor(Color.PrimaryBase)
                                        )
                                        .onAppear {
                                            if taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入專案內容描述"
                                            }
                                        }
                                        .foregroundColor(taskManager.otherDescription == "請輸入專案內容描述" ? .gray : .black)
                                        .onTapGesture {
                                            if taskManager.otherDescription == "請輸入專案內容描述" {
                                                taskManager.otherDescription = ""
                                            }
                                        }
                                        .onChange(of: taskManager.otherDescription) { newValue in
                                            if taskManager.otherDescription.count > 30 {
                                                taskManager.otherDescription = String(taskManager.otherDescription.prefix(30))
                                            }
                                        }
                                        .onChange(of: isKeyboardShowing) { newValue in
                                            
                                            if !isKeyboardShowing && taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入專案內容描述"
                                            }
                                        }
                                    
                                } else {
                                    
                                    TagMultiHStack(tags: taskManager.projectItemArray, selectedStrings: $taskManager.selectedProjectItems)
                                    
                                    Button {
                                        
                                        DispatchQueue.main.async {
                                            
                                            editTitle = "專案描述項目"
                                            editStringArray = taskManager.projectItemArray
                                            isSaving = false
                                            taskManager.isSaving = false
                                            showEditListView.toggle()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                taskManager.impactMedium.impactOccurred()
                                            }
                                        }
                                        
                                    } label: {
                                        HStack {
                                            
                                            Text("新增 / 編輯選項")

                                            Image(systemName: "pencil.line")
                                                
                                        }
                                        .font(.adaptive(size: 16))
                                        .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                    }
                                    .padding(.vertical, 3)
                                }

                                
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                        case 1:
                            
                            // MARK: - 類別 -> 會議
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("會議名稱")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                TagHStack(tags: taskManager.meetingArray, selectedString: $taskManager.selectedTask.taskTitle)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
    
                                        editTitle = "會議名稱"
                                        editStringArray = taskManager.meetingArray
                                        isSaving = false
                                        taskManager.isSaving = false
                                        showEditListView.toggle()
    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                        }
                                    }
                                    
                                } label: {
                                    HStack {
                                        
                                        Text("新增 / 編輯選項")

                                        Image(systemName: "pencil.line")
                                            
                                    }
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                }
                                .padding(.vertical, 3)
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            .onAppear {
                                taskManager.selectedTask.taskCategory = "會議"
                            }
                            
                            // MARK: - 會議開始時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("\(taskManager.selectedTask.taskCategory)開始時間")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
                                        taskManager.impactSoft.impactOccurred()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                            showDatePicker.toggle()
                                        }
                                    }

                                } label: {
                                    
                                    HStack {
                                        Text(DateManager.shared.dateToStringNoSecondFull(date: taskManager.savedTaskStartDate ?? Date()))
                                            .font(.adaptive(size: 16))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "calendar")
                                            .font(.adaptive(size: 16))
                                            .frame(width: 16, height: 16)
                                        
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                    .foregroundColor(Color.PrimaryDark)
                                    .background {
                                        Color.BaseBlackOpacity05
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(Color.PrimaryBase)
                                    }
                                    
                                }
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 會議花費時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("\(taskManager.selectedTask.taskCategory)所需時間")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                HourPickerView()
                                    .font(.adaptive(size: 14))
                                
                            }
                            .foregroundColor(Color.PrimaryDark)
                            .padding(20)
                            .padding(.bottom, -10)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 會議進度條
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("\(taskManager.selectedTask.taskCategory)進度條") // 將標題改為進度條
                                        .font(.adaptive(size: 16))
                                    
                                    Spacer()
                                    
                                    Text("\(Int(taskManager.selectedTask.taskProgress))%")
                                        .font(.adaptive(size: 18).bold())
                                }
                                .foregroundColor(Color.PrimaryDark)
                                
                                Slider(
                                    value: $taskManager.selectedTask.taskProgress,
                                    in: 0...100,
                                    step: 5,
                                    onEditingChanged: { editing in
                                        if !editing {
                                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                                            impactLight.impactOccurred()
                                        }
                                    }
                                )
                                .tint(Color.PrimaryDark)
                                .padding(.bottom, -7)

                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 會議描述項目
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Button {
                                        isTextField.toggle()
                                    } label: {
                                        Text("\(taskManager.selectedTask.taskCategory)描述項目")
                                            .font(.adaptive(size: 16))
                                            .foregroundColor(Color.PrimaryDark)
                                    }
                                    
                                    Spacer()
                                    
                                    if isTextField {
                                        Text("\(taskManager.otherDescription == "請輸入會議內容說明" ? 0 : taskManager.otherDescription.count)/30")
                                            .font(.adaptive(size: 14))
                                            .foregroundColor(taskManager.otherDescription.count == 30 ? Color.Error : Color.gray)
                                    }

                                }
                                
                                if isTextField {
                                    
                                    TextEditor(text: $taskManager.otherDescription)
                                        .font(.adaptive(size: 16))
                                        .padding(5)
                                        .padding(.leading, 5)
                                        .background(Color(UIColor.white))
                                        .frame(height: 60)
                                        .cornerRadius(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1.5).foregroundColor(Color.PrimaryBase)
                                        )
                                        .onAppear {
                                            if taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入會議內容說明"
                                            }
                                        }
                                        .foregroundColor(taskManager.otherDescription == "請輸入會議內容說明" ? .gray : .black)
                                        .onTapGesture {
                                            if taskManager.otherDescription == "請輸入會議內容說明" {
                                                taskManager.otherDescription = ""
                                            }
                                        }
                                        .onChange(of: taskManager.otherDescription) { newValue in
                                            if taskManager.otherDescription.count > 30 {
                                                taskManager.otherDescription = String(taskManager.otherDescription.prefix(30))
                                            }
                                        }
                                        .onChange(of: isKeyboardShowing) { newValue in
                                            
                                            if !isKeyboardShowing && taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入會議內容說明"
                                            }
                                        }
                                    
                                } else {
                                    
                                    TagMultiHStack(tags: taskManager.meetingItemArray, selectedStrings: $taskManager.selectedMeetingItems)
                                    
                                    Button {
                                        
                                        DispatchQueue.main.async {
                                            
                                            editTitle = "會議描述項目"
                                            editStringArray = taskManager.meetingItemArray
                                            isSaving = false
                                            taskManager.isSaving = false
                                            showEditListView.toggle()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                taskManager.impactMedium.impactOccurred()
                                            }
                                        }
                                        
                                    } label: {
                                        HStack {
                                            
                                            Text("新增 / 編輯選項")

                                            Image(systemName: "pencil.line")
                                                
                                        }
                                        .font(.adaptive(size: 16))
                                        .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                    }
                                    .padding(.vertical, 3)
                                }

                                
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                        case 2:
                            
                            // MARK: - 類別 -> 程式
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("程式名稱(專案)")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                TagHStack(tags: taskManager.programArray, selectedString: $taskManager.selectedTask.taskTitle)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
    
                                        editTitle = "程式名稱"
                                        editStringArray = taskManager.programArray
                                        isSaving = false
                                        taskManager.isSaving = false
                                        showEditListView.toggle()
    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                        }
                                    }
                                    
                                } label: {
                                    HStack {
                                        
                                        Text("新增 / 編輯選項")
                                        
                                        Image(systemName: "pencil.line")
                                            
                                    }
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                }
                                .padding(.vertical, 3)
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            .onAppear {
                                taskManager.selectedTask.taskCategory = "程式"
                            }
                            
                            // MARK: - 程式開始時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("該項目開始時間(\(taskManager.selectedTask.taskCategory))")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
                                        taskManager.impactSoft.impactOccurred()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                            showDatePicker.toggle()
                                        }
                                    }

                                } label: {
                                    
                                    HStack {
                                        
                                        Text(DateManager.shared.dateToStringNoSecondFull(date: taskManager.savedTaskStartDate ?? Date()))
                                            .font(.adaptive(size: 16))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "calendar")
                                            .font(.adaptive(size: 16))
                                            .frame(width: 16, height: 16)
                                        
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                    .foregroundColor(Color.PrimaryDark)
                                    .background {
                                        Color.BaseBlackOpacity05
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(Color.PrimaryBase)
                                    }
                                    
                                }
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 程式花費時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("該項目所需時間(\(taskManager.selectedTask.taskCategory))")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                HourPickerView()
                                    .font(.adaptive(size: 14))
                                
                            }
                            .foregroundColor(Color.PrimaryDark)
                            .padding(20)
                            .padding(.bottom, -10)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 程式進度條
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Text("該項目進度條(\(taskManager.selectedTask.taskCategory))") // 將標題改為進度條
                                        .font(.adaptive(size: 16))
                                    
                                    Spacer()
                                    
                                    Text("\(Int(taskManager.selectedTask.taskProgress))%")
                                        .font(.adaptive(size: 18).bold())
                                }
                                .foregroundColor(Color.PrimaryDark)
                                
                                Slider(
                                    value: $taskManager.selectedTask.taskProgress,
                                    in: 0...100,
                                    step: 5,
                                    onEditingChanged: { editing in
                                        if !editing {
                                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                                            impactLight.impactOccurred()
                                        }
                                    }
                                )
                                .tint(Color.PrimaryDark)
                                .padding(.bottom, -7)

                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 程式描述項目
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Button {
                                        isTextField.toggle()
                                    } label: {
                                        Text("\(taskManager.selectedTask.taskCategory)描述項目")
                                            .font(.adaptive(size: 16))
                                            .foregroundColor(Color.PrimaryDark)
                                    }
                                    
                                    Spacer()
                                    
                                    if isTextField {
                                        Text("\(taskManager.otherDescription == "請輸入程式描述說明" ? 0 : taskManager.otherDescription.count)/30")
                                            .font(.adaptive(size: 14))
                                            .foregroundColor(taskManager.otherDescription.count == 30 ? Color.Error : Color.gray)
                                    }

                                }
                                
                                if isTextField {
                                    
                                    TextEditor(text: $taskManager.otherDescription)
                                        .font(.adaptive(size: 16))
                                        .padding(5)
                                        .padding(.leading, 5)
                                        .background(Color(UIColor.white))
                                        .frame(height: 60)
                                        .cornerRadius(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1.5).foregroundColor(Color.PrimaryBase)
                                        )
                                        .onAppear {
                                            if taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入程式描述說明"
                                            }
                                        }
                                        .foregroundColor(taskManager.otherDescription == "請輸入程式描述說明" ? .gray : .black)
                                        .onTapGesture {
                                            if taskManager.otherDescription == "請輸入程式描述說明" {
                                                taskManager.otherDescription = ""
                                            }
                                        }
                                        .onChange(of: taskManager.otherDescription) { newValue in
                                            if taskManager.otherDescription.count > 30 {
                                                taskManager.otherDescription = String(taskManager.otherDescription.prefix(30))
                                            }
                                        }
                                        .onChange(of: isKeyboardShowing) { newValue in
                                            
                                            if !isKeyboardShowing && taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入程式描述說明"
                                            }
                                        }
                                    
                                } else {
                                    
                                    TagMultiHStack(tags: taskManager.programItemArray, selectedStrings: $taskManager.selectedProgramItems)
                                    
                                    Button {
                                        
                                        DispatchQueue.main.async {
                                            
                                            editTitle = "程式描述說明"
                                            editStringArray = taskManager.programItemArray
                                            isSaving = false
                                            taskManager.isSaving = false
                                            showEditListView.toggle()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                taskManager.impactMedium.impactOccurred()
                                            }
                                        }
                                        
                                    } label: {
                                        HStack {
                                            
                                            Text("新增 / 編輯選項")

                                            Image(systemName: "pencil.line")
                                                
                                        }
                                        .font(.adaptive(size: 16))
                                        .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                    }
                                    .padding(.vertical, 3)
                                }

                                
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                        case 3:
                            
                            // MARK: - 類別 -> 休假
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("休假類別")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                TagHStack(tags: taskManager.dayOffArray, selectedString: $taskManager.selectedTask.taskTitle)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
    
                                        editTitle = "休假類別"
                                        editStringArray = taskManager.dayOffArray
                                        isSaving = false
                                        taskManager.isSaving = false
                                        showEditListView.toggle()
    
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                        }
                                    }
                                    
                                } label: {
                                    HStack {
                                        
                                        Text("新增 / 編輯選項")
                                        
                                        Image(systemName: "pencil.line")
                                            
                                    }
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                }
                                .padding(.vertical, 3)
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            .onAppear {
                                taskManager.selectedTask.taskCategory = "休假"
                            }
                            
                            // MARK: - 休假開始時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("\(taskManager.selectedTask.taskCategory)開始時間")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                Button {
                                    
                                    DispatchQueue.main.async {
                                        taskManager.impactSoft.impactOccurred()
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            taskManager.impactMedium.impactOccurred()
                                            showDatePicker.toggle()
                                        }
                                    }

                                } label: {
                                    
                                    HStack {
                                        
                                        Text(DateManager.shared.dateToStringNoSecondFull(date: taskManager.savedTaskStartDate ?? Date()))
                                            .font(.adaptive(size: 16))
                                        
                                        Spacer()
                                        
                                        Image(systemName: "calendar")
                                            .font(.adaptive(size: 16))
                                            .frame(width: 16, height: 16)
                                        
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 14)
                                    .foregroundColor(Color.PrimaryDark)
                                    .background {
                                        Color.BaseBlackOpacity05
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(Color.PrimaryBase)
                                    }
                                    
                                }
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 休假花費時間
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text("\(taskManager.selectedTask.taskCategory)所需時間")
                                    .font(.adaptive(size: 16))
                                    .foregroundColor(Color.PrimaryDark)
                                
                                HourPickerView()
                                    .font(.adaptive(size: 14))
                                    .onAppear {
                                        selectedNumber = 3.0
                                    }
                                    .onDisappear {
                                        selectedNumber = 0.5
                                    }
                                
                            }
                            .foregroundColor(Color.PrimaryDark)
                            .padding(20)
                            .padding(.bottom, -10)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding([.horizontal])
                            .padding(.top, 10)
                            
                            // MARK: - 休假描述項目
                            VStack(alignment: .leading, spacing: 10) {
                                
                                HStack {
                                    Button {
                                        isTextField.toggle()
                                    } label: {
                                        Text("\(taskManager.selectedTask.taskCategory)描述項目(可不選)")
                                            .font(.adaptive(size: 16))
                                            .foregroundColor(Color.PrimaryDark)
                                    }
                                    
                                    Spacer()
                                    
                                    if isTextField {
                                        Text("\(taskManager.otherDescription == "請輸入休假描述" ? 0 : taskManager.otherDescription.count)/30")
                                            .font(.adaptive(size: 14))
                                            .foregroundColor(taskManager.otherDescription.count == 30 ? Color.Error : Color.gray)
                                    }

                                }
                                
                                if isTextField {
                                    
                                    TextEditor(text: $taskManager.otherDescription)
                                        .font(.adaptive(size: 16))
                                        .padding(5)
                                        .padding(.leading, 5)
                                        .background(Color(UIColor.white))
                                        .frame(height: 60)
                                        .cornerRadius(8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1.5).foregroundColor(Color.PrimaryBase)
                                        )
                                        .onAppear {
                                            if taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入休假描述"
                                            }
                                        }
                                        .foregroundColor(taskManager.otherDescription == "請輸入休假描述" ? .gray : .black)
                                        .onTapGesture {
                                            if taskManager.otherDescription == "請輸入休假描述" {
                                                taskManager.otherDescription = ""
                                            }
                                        }
                                        .onChange(of: taskManager.otherDescription) { newValue in
                                            if taskManager.otherDescription.count > 30 {
                                                taskManager.otherDescription = String(taskManager.otherDescription.prefix(30))
                                            }
                                        }
                                        .onChange(of: isKeyboardShowing) { newValue in
                                            
                                            if !isKeyboardShowing && taskManager.otherDescription == "" {
                                                taskManager.otherDescription = "請輸入休假描述"
                                            }
                                        }
                                    
                                } else {
                                    
                                    TagMultiHStack(tags: taskManager.dayOffItemArray, selectedStrings: $taskManager.selectedProgramItems)
                                    
                                    Button {
                                        
                                        DispatchQueue.main.async {
                                            
                                            editTitle = "休假描述項目"
                                            editStringArray = taskManager.dayOffItemArray
                                            isSaving = false
                                            taskManager.isSaving = false
                                            showEditListView.toggle()
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                taskManager.impactMedium.impactOccurred()
                                            }
                                        }
                                        
                                    } label: {
                                        HStack {
                                            
                                            Text("新增 / 編輯選項")

                                            Image(systemName: "pencil.line")
                                                
                                        }
                                        .font(.adaptive(size: 16))
                                        .foregroundColor(Color.PrimaryDark.opacity(0.6))
                                    }
                                    .padding(.vertical, 3)
                                }

                                
                                
                            }
                            .padding(20)
                            .background {
                                Color.white
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                        default:
                            Spacer()
                        }
                        
                        Spacer(minLength: 120)
                        
                    }
                    
                    Button {
                        
                        DispatchQueue.main.async {
                            
                            taskManager.selectedTask.taskStartDate = taskManager.savedTaskStartDate ?? Date()
                            taskManager.selectedTask.taskEndDate = taskManager.savedTaskEndDate ?? Date()
                            
                            if taskManager.selectedProjectItems != [] {
                                taskManager.selectedTask.taskDescription = taskManager.combine(strings: taskManager.selectedProjectItems)
                            } else if taskManager.selectedMeetingItems != [] {
                                taskManager.selectedTask.taskDescription = taskManager.combine(strings: taskManager.selectedMeetingItems)
                            } else if taskManager.selectedProgramItems != [] {
                                taskManager.selectedTask.taskDescription = taskManager.combine(strings: taskManager.selectedProgramItems)
                            } else if taskManager.selectedDayOffItems != [] {
                                taskManager.selectedTask.taskDescription = taskManager.combine(strings: taskManager.selectedDayOffItems)
                            } else {
                                taskManager.selectedTask.taskDescription = taskManager.otherDescription
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                                
                                if !taskManager.isEditing {
                                    
                                    if SQLiteCommands.addTask(model: taskManager.selectedTask) ?? false {
                                        
                                        taskManager.savedTaskStartDate = nil
                                        taskManager.savedTaskEndDate = nil
                                        
                                        taskManager.selectedProjectItems = []
                                        taskManager.selectedMeetingItems = []
                                        taskManager.selectedProgramItems = []
                                        taskManager.selectedDayOffItems = []
                                        taskManager.otherDescription = ""

                                        taskManager.selectedTask = Task(taskCategory: "", taskTitle: "", taskDescription: "", taskProgress: 0, taskStartDate: Date(), taskEndDate: Date(), taskMoodLevel: 4)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            showHUDView(image: "checkmark.circle.fill", title: "新增紀錄成功", bgColor: Color.greenColor) { _,_  in

                                            }
                                            
                                            taskManager.needUpdate = true
                                            presentationMode.wrappedValue.dismiss()
                                            
                                        }
                                    } else {
                                        showHUDView(image: "xmark.circle.fill", title: "新增紀錄失敗，請稍候重試", bgColor: Color.Error) { _,_  in

                                        }
                                    }
                                    
                                } else {

                                    if SQLiteCommands.updateTask(taskValue: taskManager.selectedTask) ?? false {
                                        
                                        taskManager.savedTaskStartDate = nil
                                        taskManager.savedTaskEndDate = nil
                                        
                                        taskManager.selectedProjectItems = []
                                        taskManager.selectedMeetingItems = []
                                        taskManager.selectedProgramItems = []
                                        taskManager.selectedDayOffItems = []
                                        taskManager.otherDescription = ""

                                        taskManager.selectedTask = Task(taskCategory: "", taskTitle: "", taskDescription: "", taskProgress: 0, taskStartDate: Date(), taskEndDate: Date(), taskMoodLevel: 4)
                                        
                                        taskManager.isEditing = false
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                            showHUDView(image: "checkmark.circle.fill", title: "修改紀錄成功", bgColor: Color.greenColor) { _,_  in

                                            }
                                            
                                            taskManager.needUpdate = true
                                            presentationMode.wrappedValue.dismiss()
                                            
                                        }
                                    } else {
                                        showHUDView(image: "xmark.circle.fill", title: "修改紀錄失敗，請稍候重試", bgColor: Color.Error) { _,_  in

                                        }
                                    }
                                    
                                    
                                }
                                
                                
                                
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            taskManager.impactLight.impactOccurred()
                        }

                        print("\(taskManager.selectedTask)")

        //                presentationMode.wrappedValue.dismiss()
                        
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
                    .padding(30)
                    .padding(.bottom, 20)
                }

            }
            
            if showDatePicker {
                
                CustomDatePicker(showDatePicker: $showDatePicker, savedDate: $taskManager.savedTaskStartDate, selectedDate: taskManager.savedTaskStartDate ?? Date())
                    .animation(.linear, value: showDatePicker)
                    .transition(.opacity)
                    .tint(Color.PrimaryBase)
                
            }

        }
        .ignoresSafeArea()
        .onChange(of: taskManager.isSaving, perform: { newValue in
            
            switch editTitle {
                
            case "專案名稱":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.projectArray = editStringArray
                            asProjectArray = editStringArray
                        }
                    }
                }
                
            case "會議名稱":

                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.meetingArray = editStringArray
                            asMeetingArray = editStringArray
                        }
                    }
                }
                
            case "程式名稱":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.programArray = editStringArray
                            asProgramArray = editStringArray
                        }
                    }
                }
                
            case "休假類別":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.dayOffArray = editStringArray
                            asDayOffArray = editStringArray
                        }
                    }
                }
   
            case "專案描述項目":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.projectItemArray = editStringArray
                            asProjectItemArray = editStringArray
                        }
                    }
                }
 
            case "會議描述項目":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.meetingItemArray = editStringArray
                            asMeetingItemArray = editStringArray
                        }
                    }
                }
                
            case "程式描述說明":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.programItemArray = editStringArray
                            asProgramItemArray = editStringArray
                        }
                    }
                }
                
            case "休假描述項目":
                
                if taskManager.isSaving {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            taskManager.dayOffItemArray = editStringArray
                            asDayOffItemArray = editStringArray
                        }
                    }
                }
 
            default:
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                
            }
        })
        .sheet(isPresented: $showEditListView) {
            
            switch editTitle {
                
            case "專案名稱":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "會議名稱":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "程式名稱":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "休假類別":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
   
            case "專案描述項目":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "會議描述項目":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "程式描述說明":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)
                
            case "休假描述項目":
                
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
                    .interactiveDismissDisabled(true)

            default:
                EditListView(sheetTitle: $editTitle, items: $editStringArray, isSaving: $isSaving)
//                    .presentationDetents([.fraction(0.95)])
                    .interactiveDismissDisabled(true)

            }
            
        }

        .onAppear {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                taskManager.impactMedium.impactOccurred()
            }

            if taskManager.isEditing {
                selectedCategory = optionTitleToInt(for: taskManager.selectedTask.taskCategory)
                taskManager.savedTaskStartDate = taskManager.selectedTask.taskStartDate
                selectedNumber = DateManager.shared.hoursBetween(date1: taskManager.selectedTask.taskStartDate, date2: taskManager.selectedTask.taskEndDate)
                
                switch taskManager.selectedTask.taskCategory {
                case "專案":
                    taskManager.selectedProjectItems = taskManager.split(combinedString: taskManager.selectedTask.taskDescription)
                case "會議":
                    taskManager.selectedMeetingItems = taskManager.split(combinedString: taskManager.selectedTask.taskDescription)
                case "程式":
                    taskManager.selectedProgramItems = taskManager.split(combinedString: taskManager.selectedTask.taskDescription)
                default:
                    taskManager.otherDescription = taskManager.selectedTask.taskDescription
                    
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { _ in
                isKeyboardShowing = true
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardShowing = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @ViewBuilder
    func HourPickerView() -> some View {
        
        HStack {
            
            Text("共計")
            
            Picker("選擇數字", selection: $selectedNumber) {
                ForEach(numbers, id: \.self) { number in
                    Text("\(number, specifier: "%.1f")").tag(number)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 100, height: 50)
            
            Text("小時，至")
            
            if let time = taskManager.savedTaskEndDate {
                let timeString = DateManager.shared.dateToTimeString(date: time)
                Text("\(timeString)")
                    .font(.adaptive(size: 18).bold())
            }
            
            
            Spacer()
            
        }
        .onAppear {
            taskManager.savedTaskEndDate = DateManager.shared.addHoursToDate(startDate: taskManager.savedTaskStartDate ?? Date(), hoursToAdd: selectedNumber)
        }
        .onChange(of: selectedNumber) { newValue in
            taskManager.savedTaskEndDate = DateManager.shared.addHoursToDate(startDate: taskManager.savedTaskStartDate ?? Date(), hoursToAdd: selectedNumber)
        }
//        .padding()
    }
    
    
    private func optionTitle(for index: Int) -> String {
        switch index {
        case 0: return "專案"
        case 1: return "會議"
        case 2: return "程式"
        case 3: return "休假"
        default: return ""
        }
    }
    
    private func optionTitleToInt(for index: String) -> Int {
        switch index {
        case "專案": return 0
        case "會議": return 1
        case "程式": return 2
        case "休假": return 3
        default: return 4
        }
    }
}

struct TagHStack: View {

    var tags: [String]
    @Binding var selectedString: String
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.colorScheme) var scheme
    let screenWidth = UIScreen.main.bounds.width

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding(.vertical, 6)
                    .padding(.trailing, 12)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })

            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        
        Button {

            taskManager.impactLight.impactOccurred()
            
            withAnimation(.easeOut(duration: 0.2)) {
                
                if selectedString == text {
                    selectedString = ""
                } else {
                    selectedString = text
                }
            }

        } label: {
            
            Text(text)
                .foregroundColor(selectedString == text ? Color.white : Color.PrimaryBase)
                .font(.adaptive(size: 16))
                .padding(.horizontal, screenWidth * 0.04)
                .padding(.vertical, 8)
                .background {
                    
                    if selectedString == text {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.PrimaryDark)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.PrimaryDark)
                        
                    } else {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.BaseBlackOpacity05)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                    }
                }
                .cornerRadius(8)
        }

    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct TagMultiHStack: View {

    var tags: [String]
    @Binding var selectedStrings: [String]
    
    @EnvironmentObject var taskManager: TaskManager
    @Environment(\.colorScheme) var scheme
    let screenWidth = UIScreen.main.bounds.width

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding(.vertical, 6)
                    .padding(.trailing, 12)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })

            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        
        Button {

            taskManager.impactLight.impactOccurred()
            
            withAnimation(.easeOut(duration: 0.2)) {
                if selectedStrings.contains(text) {
                    selectedStrings.removeAll { $0 == text }
                } else {
                    selectedStrings.append(text)
                }
            }

        } label: {
            
            Text(text)
                .foregroundColor(selectedStrings.contains(text) ? Color.white : Color.PrimaryBase)
                .font(.adaptive(size: 16))
                .padding(.horizontal, screenWidth * 0.04)
                .padding(.vertical, 8)
                .background {
                    
                    if selectedStrings.contains(text) {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.PrimaryDark)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.PrimaryDark)
                        
                    } else {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.BaseBlackOpacity05)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                    }
                }
                .cornerRadius(8)
        }
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            .environmentObject(TaskManager())
    }
}
