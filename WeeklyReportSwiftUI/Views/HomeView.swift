//
//  HomeView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    @EnvironmentObject var reportManager: ReportViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("userName") var userName: String = ""
    
    @State private var showImagePicker: Bool = false
    @State private var userImage: UIImage?
    
    @State private var weekSlider: [[DateValue]] = []
    @State private var currentWeekInt: Int = 1
    
    @State private var changeMonth: Bool = false
//    @State private var currentMonth: Int = 0
    
    @State private var offset: CGSize = .zero
    @State private var didJustSwipe = false
    
    @State private var isMonth: Bool = false
    @State private var isSelected: Bool = false
    
    @State private var showTaskView: Bool = false
    
    @State private var needUpdate: Bool = false
    
    @State private var showMainReportView: Bool = false
    
    @AppStorage("currentHighlight") var currentHighlight: Int = 0
    
    let screenWidth = UIScreen.main.bounds.width
    
    fileprivate func updateWeekSliderData() {

        weekSlider.removeAll()
        
        let currentWeek = taskManager.fetchCurrentWeek(taskManager.selectedDateValue.date)
        
        if let firstDate = currentWeek.first?.date {
            let previousWeek = taskManager.createPreviousWeek(firstDate)
            weekSlider.append(previousWeek)
        }
        
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
            let nextWeek = taskManager.createNextWeek(lastDate)
            weekSlider.append(nextWeek)
        }
    }

    var body: some View {
        
        ZStack {

            FloatingCloudsView().ignoresSafeArea()
            
            VStack {
                
                HStack(alignment: .center) {
                    
                    Button {
                        
                        showImagePicker.toggle()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            taskManager.impactMedium.impactOccurred()
                        }
                        
                    } label: {
                        
                        ZStack {
                            
                            if let userImage = self.userImage {
                                
                                Image(uiImage: userImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    
                                    .clipShape(Circle())
                                    .overlay(content: {
                                        LinearGradient(colors: [Color.yellow, Color.Error], startPoint: .topLeading, endPoint: .bottomTrailing)
                                            .mask(Circle().stroke(lineWidth: 2.5))
                                    })
                                
                            } else {
                                
                                LinearGradient(colors: [Color.yellow, Color.Error], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .mask(Circle())
                                    .frame(width: 60, height: 60)

                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("嗨！\(taskManager.removeFirstCharacter(from: userName))")
                            .font(.adaptive(size: 20))
                            .fontWeight(.semibold)
                        
                        Text("讓我們一起來紀錄這週做了什麼吧")
                            .font(.adaptive(size: 14))
                    }
                    .foregroundColor(.white)
                    .padding(.leading, 12)
                    
                    Spacer()

                }
                .frame(maxWidth: .infinity)
                .padding(.top, UIScreen.main.bounds.height / 20)
                .padding(.bottom, 20)
                .padding(.leading, 20)

                // Bar
                HStack {
                    
                    if isMonth {
                        
                        Button {
                            taskManager.currentDate = taskManager.firstDayOfPreviousMonth(from: taskManager.currentDate)!
                            changeMonth.toggle()
                            
                            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.15) {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                            }
                            
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                    }

                    Spacer()
                    
                    Button {
                        
                        withAnimation {
                            isMonth.toggle()
                        }
                        
                    } label: {
                        Text(DateManager.shared.formatDateToMonthYear(date: taskManager.currentDate) ?? "")
                    }
                    .spotlight(enabled: currentHighlight == 4, title: "切換週曆月曆模式")
                    
                    Spacer()
                    
                    if isMonth {
                        
                        Button {
                            
                            taskManager.currentDate = taskManager.firstDayOfNextMonth(from: taskManager.currentDate)!
                            changeMonth.toggle()
                            
                            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.15) {
                                let impactLight = UIImpactFeedbackGenerator(style: .light)
                                impactLight.impactOccurred()
                            }
                            
                        } label: {
                            Image(systemName: "chevron.right")
                            
                        }
                    }
                    
                }
                .font(.adaptive(size: 16))
                .foregroundColor(Color.BaseWhiteOpacity80)
                .padding(.horizontal, 30)
                .padding(.bottom, 25)
                
                
                if !isMonth {
                    TabView(selection: $currentWeekInt) {
                        ForEach(weekSlider.indices, id: \.self) { index in
                            let week = weekSlider[index]
                            WeekDateView(week)
                                .padding(.horizontal, 5)
                        }
                    }
                    .spotlight(enabled: currentHighlight == 1, title: "點擊選擇日期")
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .transition(.slide)
                    .frame(height: 80)
                    .padding(.top, -10)
                    .padding(.bottom, -5)

                } else {
                    MonthDateView(extractDate(userTasks: taskManager.fetchedSqlTasks))
                        .padding(.horizontal, 8)
                }
                
                TabView(selection: $taskManager.selectedDateValue.day) {
                    
                    ForEach(weekSlider.indices, id: \.self) { index in
                        
                        let week = weekSlider[index]
                        ForEach(week) { day in
                            
                            NewTaskView(tasks: day.tasks)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.top, -10)
                                .frame(width: UIScreen.main.bounds.width)
                                .tag(day.day)
                            
                            
                        }
                        
                    }
                    .onChange(of: taskManager.selectedDateValue.day) { newValue in
                        
                        taskManager.delayedImpactOccurred(impactStyle: .light, delaySec: 0.12)
                        
                        if let foundDateValue = findDateValue(by: taskManager.selectedDateValue.day, in: weekSlider) {
                            taskManager.selectedDateValue = foundDateValue
                        }
                    }
                    
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .transition(.slide)
                .ignoresSafeArea()
                
                /*
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack {
                        
                        TaskView(tasks: taskManager.selectedDateValue.tasks)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.top, -10)

                        Spacer(minLength: 40)
                            
                    }
                    .hSpacing(.center)
                    .vSpacing(.center)
                    .padding(.top, isMonth ? 10 : 25)
                    

                }
                 */
                
            }
            .onAppear {

//                SQLiteDatabase.shared.deleteTaskTable()
//                SQLiteCommands.cleanPainTable()
                
                SQLiteDatabase.shared.creatTables()
                taskManager.fetchedSqlTasks = SQLiteCommands.getAllTasks()
                
                self.userImage = loadImageFromDiskWith()
                
                if weekSlider.isEmpty {
                    updateWeekSliderData()
                }
                
                if taskManager.needUpdate {
                    
                    weekSlider.removeAll()
                    updateWeekSliderData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        taskManager.needUpdate = false
                    }

                }
            }
            .onChange(of: needUpdate, perform: { newValue in
                
                DispatchQueue.main.async {
                    
                    weekSlider = []
                    taskManager.fetchedSqlTasks = []
                    taskManager.fetchedSqlTasks = SQLiteCommands.getAllTasks()
                    taskManager.selectedDateValue.tasks = []
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        updateWeekSliderData()
                        taskManager.fetchedDateValues = extractDate(userTasks: taskManager.fetchedSqlTasks)
                        taskManager.fetchedDateValues.forEach { dateValue in
                            if isSameDay(date1: dateValue.date, date2: taskManager.currentDate) {
                                taskManager.selectedDateValue = dateValue
                            }
                        }
                    }
                }

            })
            .onChange(of: taskManager.selectedDateValue) { newValue in
                
                isSelected = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                    updateWeekSliderData()
                }

            }

            
            Button {

                taskManager.savedTaskStartDate = getLatestTaskEndDate(on: taskManager.selectedDateValue.date, from: taskManager.fetchedSqlTasks)

                showTaskView.toggle()

            } label: {
                Image(systemName: "plus")
                    .font(.adaptive(size: 23))
                    .foregroundColor(Color.PrimaryDark)
                    .padding(16)
                    .frame(width: 55, height: 55)
                    .spotlight(enabled: currentHighlight == 2, title: "點擊新增項目")
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding()
                    .padding(.trailing, 5)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            Button {
                
                reportManager.dateInitManager(initDate: taskManager.selectedDateValue.date.startOfWeek.addingDays(1))
                
                taskManager.fetchedSelectedWeekTasks = SQLiteCommands.getTasksForWeek(of: taskManager.selectedDateValue.date)
                
                if taskManager.fetchedSelectedWeekTasks.isEmpty {
                    taskManager.fetchedSelectedWeekTasks = taskManager.filterTasks(from: taskManager.fetchedSqlTasks, basedOn: taskManager.selectedDateValue.date)
                }
                
                print("@ fetchedSelectedWeekTasks: \(taskManager.fetchedSelectedWeekTasks)")
                
                taskManager.sortedWeekTasks = taskManager.splitAndCombineTasks(for: taskManager.fetchedSelectedWeekTasks)
                taskManager.sortedWeekTaskString = taskManager.generateDescriptionStrings(from: taskManager.sortedWeekTasks)
                taskManager.saveDetailsToAppStorage(descriptionsForWeek: taskManager.sortedWeekTaskString)
                
                showMainReportView = true
                
                print("@ sortedWeekTaskString: \(taskManager.sortedWeekTaskString)")
                
            } label: {
                Image(systemName: "doc.badge.arrow.up")
                    .font(.adaptive(size: 20))
                    .foregroundColor(Color.PrimaryDark)
                    .padding(16)
                    .frame(width: 55, height: 55)
                    .spotlight(enabled: currentHighlight == 5, title: "輸出成pdf週報")
                    .background(Color.white)
                    .clipShape(Circle())
                    .padding()
                    .padding(.trailing, 5)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            
        }
        .onTapGesture {
            if currentHighlight < 6 {
                currentHighlight += 1
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(uiImage: $userImage, isPresented: $showImagePicker)
        }
        .sheet(isPresented: $showTaskView) {
            
            AddTaskView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .interactiveDismissDisabled(true)
                .onDisappear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        if taskManager.needUpdate {
                            needUpdate.toggle()
                            taskManager.needUpdate = false
                        } 
                    }
                }
            
        }
        .fullScreenCover(isPresented: $showMainReportView) {
            
            ZStack(alignment: .top) {

                MainReportView(isShowAlert: taskManager.showSelections)

                HStack {

                    Button {
                        
                        showMainReportView = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .frame(width: 20, height: 20)

                    }

                    Spacer()

//                    Button {
//                        taskManager.showSelections.toggle()
//                    } label: {
//                        Image(systemName: "doc.badge.gearshape")
//                            .frame(width: 20, height: 20)
//                    }
//                    .padding(.trailing, 5)

                }
                .font(.adaptive(size: 20))
                .foregroundColor(Color.PrimaryDark)
                .padding(.horizontal, 25)
                .padding(.top, 5)
            }
            
        }
    }
    
    func findDateValue(by day: Int, in nestedArray: [[DateValue]]) -> DateValue? {
        for innerArray in nestedArray {
            for dateValue in innerArray {
                if dateValue.day == day {
                    return dateValue
                }
            }
        }
        return nil
    }
    
    @ViewBuilder
    func WeekDateView(_ week: [DateValue]) -> some View {
        
        HStack(spacing: (UIScreen.main.bounds.width - (47 * 7)) / 8) {
            
            ForEach(week) { day in
                
                VStack(spacing: 6) {
                    
                    VStack(spacing: 4) {
                        
                        Text(taskManager.extractChinessWeek(date: day.date))
                            .font(.adaptive(size: 12))
                            .padding(.top, 2)
                        
                        Text(taskManager.extractDate(date: day.date, format: "dd"))
                            .font(.adaptive(size: 15))
                            .fontWeight(.semibold)
                        
                    }
                    .hSpacing(.center)
                    .frame(width: 47 * 0.98, height: 56 * 0.98)
                    .background {
                        if isSameDay(day.date, taskManager.selectedDateValue.date) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.8))
//                                .matchedGeometryEffect(id: "INDICATOR", in: animation)
                        }
                    }
                    .overlay {

                        if isSameDay(day.date, Date()) {
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1.5).foregroundColor(.BaseWhite)
                        } else {
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.5).foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .foregroundColor(isSameDay(day.date, taskManager.selectedDateValue.date) ? Color.PrimaryDark : isSameDay(day.date, Date()) ? .BaseWhite : .white.opacity(0.8))
                    .onAppear {
                        if !isSelected {
                            if isSameDay(day.date, Date()) && areInSameWeek(date1: weekSlider[1][0].date, date2: Date()) {
                                taskManager.selectedDateValue = day
                            }
                        }
                        
                    }
//                    .onChange(of: taskManager.selectedDateValue, perform: { newValue in
//                        isSelected = true
//                    })
                    .onChange(of: currentWeekInt) { newValue in
                        
                        if newValue == 0 || newValue == (weekSlider.count - 1) {
                            
                            if let firstDate = weekSlider[currentWeekInt].first?.date {
                                taskManager.currentDate = firstDate
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                taskManager.impactLight.impactOccurred()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    paginateWeek()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        currentWeekInt = 1
                                    }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        
                        withAnimation {
                            taskManager.selectedDateValue = day
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {

//                            withAnimation {
//                                taskManager.selectedDateValue = day
//                            }
                            
                            taskManager.currentDate = taskManager.selectedDateValue.date

//                            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.05) {
//                                taskManager.impactLight.impactOccurred()
//                            }
                        }

                    }
                    
                    HStack(spacing: 5) {
                        
                        if day.tasks.count != 0 {
                            
                            if day.tasks.count > 2 {
                                ForEach(0..<2) { _ in
                                    Circle()
                                        .frame(width: 7.5, height: 7.5)
                                        .foregroundColor(Color.SecondaryYellow)
                                }

                                Text("+\(day.tasks.count - 2)")
                                    .font(.adaptive(size: 8))
                                    .foregroundColor(Color.SecondaryYellow)
                                    .frame(height: 7.5)

//                                HStack(spacing: 1.6) {
//                                    ForEach(0..<3) { _ in
//                                        Circle()
//                                            .frame(width: 1.2, height: 1.2)
//                                            .foregroundColor(Color.SecondaryYellow)
//                                    }
//                                }
//                                .frame(width: 8)
                                
                            } else {
                                ForEach(0..<day.tasks.count) { _ in
                                    Circle()
                                        .frame(width: 7.5, height: 7.5)
                                        .foregroundColor(Color.SecondaryYellow)
                                }
                            }
                            
                        } else {
                            Circle()
                                .frame(width: 7.5, height: 7.5)
                                .foregroundColor(Color.clear)
                        }

                    }
                }
                
            }
        }

    }
    
    @ViewBuilder
    func MonthDateView(_ month: [DateValue]) -> some View {
        
        VStack(spacing: 30) {
            
            let days: [String] = ["日", "一", "二", "三", "四", "五", "六"]

                // Week Name
                HStack(spacing: 0) {
                    ForEach(days, id: \.self) { day in
                        Text(day)
                            .font(.adaptive(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(minWidth: 0, maxWidth: .infinity)

                    }
                }

                // Month View
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 10) {
                    
                    ForEach(month) { value in
                        DayCardView(value: value)
                            .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                                onChanged(value: value)
                            }).onEnded({ (value) in
                                onEnded(value: value)
                            }))
                        
                    }
                }
//                .padding(.horizontal, 4)

        }
        .background(Color.clear)
   
    }
    
    @ViewBuilder
    func DayCardView(value: DateValue) -> some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            if value.day != -1 {

                Text("\(value.day)")
                    .font(.adaptive(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(isSameDay(date1: value.date, date2: taskManager.selectedDateValue.date) ? .PrimaryDark : Color.BaseWhiteOpacity50)
                    .frame(maxWidth: .infinity)
                   
                    .onTapGesture {
                        
//                        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
//                            let impactLight = UIImpactFeedbackGenerator(style: .light)
//                            impactLight.impactOccurred()
//                        }
                        
                        taskManager.selectedDateValue = value
                        
//                        print("Date: \(value.date.toTaiwanDateString())")

                    }
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.8))
                            .frame(width: 32, height: 32)
                            .padding(.horizontal, 5)
                            .opacity(isSameDay(date1: value.date, date2: taskManager.selectedDateValue.date) ? 1 : 0)

                    }
                    .padding(.bottom, 3)

                HStack(spacing: 5) {
                    
                    if value.tasks.count != 0 {
                        if value.tasks.count > 2 {
                            ForEach(0..<min(value.tasks.count, 2)) { _ in
                                Circle()
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(Color.SecondaryYellow)
                            }
                        } else {
                            ForEach(0..<min(value.tasks.count, 3)) { _ in
                                Circle()
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(Color.SecondaryYellow)
                            }
                        }

                    } else {
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(Color.clear)
                    }
                    
                    if value.tasks.count > 2 {
                        Text("+\(value.tasks.count - 2)")
                            .font(.adaptive(size: 8))
                            .foregroundColor(Color.SecondaryYellow)
                            .frame(height: 6)

                    }
//
                    
                }
                .padding(.top, 10)
                
                Spacer()
                
            }
        }
        .padding(.vertical, 4)
        .frame(height: 45, alignment: .top)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.clear)
                .padding(.bottom, -8)
                .opacity(isSameDay(date1: value.date, date2: taskManager.selectedDateValue.date) ? 0.6 : 0)
        }
        
    }
    
    @ViewBuilder
    func TaskView(tasks: [Task]) -> some View {
        
        VStack(alignment: .leading, spacing: 35) {
            
            if tasks.count != 0 {
                
                ForEach(tasks) { task in
                    
                    TaskRowView(task: task, showTaskView: $showTaskView, needUpdate: $needUpdate)
                        .contextMenu {
                            
                            Button {
                                taskManager.selectedTask = task
                                taskManager.isEditing = true
                                showTaskView.toggle()
                            } label: {
                                HStack {
                                    Text("編輯項目")
                                    Image(systemName: "highlighter")
                                }
                            }
                            
                            Button {
                                SQLiteCommands.deleteTask(taskValue: task)
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    needUpdate.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("刪除項目")
                                    Image(systemName: "eraser.line.dashed")
                                }
                            }
                            
                        }
                        .padding(.vertical, -5)
                }
                
            } else {
                
                VStack(alignment: .center, spacing: 0) {
                    
                    Text("這天目前沒有紀錄喔")
                        .font(.adaptive(size: 15))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .spotlight(enabled: currentHighlight == 3, title: "新增紀錄呈現在此")
                .background {
                    UltraBlurView()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.6).foregroundColor(.white)
                        }
                }

            }
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        
    }
    
    @ViewBuilder
    func NewTaskView(tasks: [Task]) -> some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 35) {
                
                if tasks.count != 0 {
                    
                    ForEach(tasks) { task in
                        
                        TaskRowView(task: task, showTaskView: $showTaskView, needUpdate: $needUpdate)
                            .contextMenu {
                                
                                Button {
                                    taskManager.selectedTask = task
                                    taskManager.isEditing = true
                                    showTaskView.toggle()
                                } label: {
                                    HStack {
                                        Text("編輯項目")
                                        Image(systemName: "highlighter")
                                    }
                                }
                                
                                Button {
                                    SQLiteCommands.deleteTask(taskValue: task)
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        needUpdate.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Text("刪除項目")
                                        Image(systemName: "eraser.line.dashed")
                                    }
                                }
                                
                            }
                            .padding(.vertical, -5)
                    }
                    
                } else {
                    
                    VStack(alignment: .center, spacing: 0) {
                        
                        Text("這天目前沒有紀錄喔")
                            .font(.adaptive(size: 15))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .spotlight(enabled: currentHighlight == 3, title: "新增紀錄呈現在此")
                    .background {
                        UltraBlurView()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.6).foregroundColor(.white)
                            }
                    }

                }
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.top, isMonth ? 10 : 25)
            
            Spacer(minLength: 70)
            
        }
    }
    
    /*
    
    @ViewBuilder
    func TaskViewTest() -> some View {
        
        VStack(alignment: .leading, spacing: 35) {
            
            if taskManager.selectedDateValue.tasks.count != 0 {
                
                ForEach($taskManager.selectedDateValue.tasks) { $task in
                    
                    TaskRowView(task: $task, showTaskView: $showTaskView, needUpdate: $needUpdate)
                        .contextMenu {
                            
                            Button {
                                taskManager.selectedTask = task
                                taskManager.isEditing = true
                                showTaskView.toggle()
                            } label: {
                                HStack {
                                    Text("編輯項目")
                                    Image(systemName: "highlighter")
                                }
                            }
                            
                            Button {
                                SQLiteCommands.deleteTask(taskValue: task)
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    needUpdate.toggle()
                                }
                            } label: {
                                HStack {
                                    Text("刪除項目")
                                    Image(systemName: "eraser.line.dashed")
                                }
                            }

                        }
                        .padding(.vertical, -5)
                }
                
            } else {
                
                VStack(alignment: .center, spacing: 0) {

                    Text("這天目前沒有紀錄喔")
                        .font(.adaptive(size: 15))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
     
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .spotlight(enabled: currentHighlight == 3, title: "新增紀錄呈現在此")
                .background {
                    UltraBlurView()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.6).foregroundColor(.white)
                        }
                }
            }
 
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        
    }
    */
    
    func loadImageFromDiskWith() -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        let fileName = "userImage"
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }
    
    func extractDate(userTasks: [Task]) -> [DateValue] {

        let calendar = Calendar.current

        if let currentMonth = taskManager.firstDayOfCurrentMonth(from: taskManager.currentDate) {
            var days = currentMonth.getAllDates().compactMap { date -> DateValue in
                let day = calendar.component(.day, from: date)
                var tasks: [Task] = []
                userTasks.forEach { task in
                    if isSameDay(date1: date, date2: task.taskStartDate) {
                        tasks.append(task)
                    }
                }

                return DateValue(day: day, date: date, tasks: tasks)
            }
            
            let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
            
            for _ in 0..<firstWeekday - 1 {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }

            return days
        }
        
        return []
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isAfterTomorrow(date: Date) -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        return date > tomorrow
    }

    func getLatestTaskEndDate(on selectedDate: Date, from tasks: [Task]) -> Date {
        let tasksLatestDate = tasks.filter { $0.taskEndDate.isOnSameDay(as: selectedDate) }
                                   .max(by: { $0.taskEndDate < $1.taskEndDate })?.taskEndDate
        
        let nineAMDate = selectedDate.at(hour: 9, minute: 0)
        let noonDate = selectedDate.at(hour: 12, minute: 0)
        let oneThirtyPMDate = selectedDate.at(hour: 13, minute: 30)

        // 檢查 tasksLatestDate 是否在12:00到13:30之間
        if let tasksDate = tasksLatestDate, tasksDate.isBetween(noonDate, and: oneThirtyPMDate) {
            return oneThirtyPMDate
        } else if let tasksDate = tasksLatestDate, tasksDate > nineAMDate {
            return tasksDate
        } else {
            return nineAMDate
        }
    }
    
    func extractDateString() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: taskManager.currentDate)
        
        return date.components(separatedBy: " ")
    }

    func onChanged(value: DragGesture.Value) {
        
    }
    
    func onEnded(value: DragGesture.Value) {

        withAnimation {

            if value.translation.width > 0 && value.translation.width > UIScreen.main.bounds.width / 4.5 {
//                currentMonth -= 1
                taskManager.currentDate = taskManager.firstDayOfPreviousMonth(from: taskManager.currentDate)!
                changeMonth.toggle()
                DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }
                print("@ -")
            } else if value.translation.width < 0 && -value.translation.width > UIScreen.main.bounds.width / 4.5 {
//                currentMonth += 1
                taskManager.currentDate = taskManager.firstDayOfNextMonth(from: taskManager.currentDate)!
                changeMonth.toggle()
                DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }
                print("@ +")
            }

        }
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func areInSameWeek(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current

        // 獲取日期所在周的第一天
        func firstDayOfWeek(for date: Date) -> Date? {
            guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else { return nil }
            return calendar.date(byAdding: .day, value: 1, to: sunday)
        }

        // 獲取每個日期所在周的第一天
        guard let firstDayOfWeek1 = firstDayOfWeek(for: date1),
              let firstDayOfWeek2 = firstDayOfWeek(for: date2) else { return false }

        // 比較是否在同一週
        return calendar.isDate(firstDayOfWeek1, inSameDayAs: firstDayOfWeek2)
    }
    
    func paginateWeek() {
        
        if weekSlider.indices.contains(currentWeekInt) {
            if let firstDate = weekSlider[currentWeekInt].first?.date, currentWeekInt == 0 {
                let previousWeek = taskManager.createPreviousWeek(firstDate)
                weekSlider.insert(previousWeek, at: 0)
                weekSlider.removeLast()
            }
            
            if let lastDate = weekSlider[currentWeekInt].last?.date, currentWeekInt == (weekSlider.count - 1) {
                let nextWeek = taskManager.createNextWeek(lastDate)
                weekSlider.append(nextWeek)
                weekSlider.removeFirst()
            }
            
            currentWeekInt = 1
        }
//        print(recordManager.weekSlider.count)
    }
    
    
}

struct TaskRowView: View {
    
    @EnvironmentObject var taskManager: TaskManager
    
    @State var task: Task
    @Binding var showTaskView: Bool
    @Binding var needUpdate: Bool
    
    @State var showAlert: Bool = false
    
    var body: some View {

        HStack(alignment: .top, spacing: 12) {
 
            if let iconInfo = taskManager.getIconInfo(from: task.taskMoodLevel) {
                
                Image(iconInfo.imageName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(iconInfo.imageColor.opacity(0.9)).padding(-2))
                    .padding(10)
                    .background {
                        UltraBlurView()
                            .clipShape(RoundedRectangle(cornerRadius: 8)).frame(width: 50, height: 50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.4).foregroundColor(.white)
                            }
                    }

                /*
                HStack(spacing: 5) {
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "trash")
                            .font(.adaptive(size: 10))
                            .padding()
                            .frame(width: 22, height: 22)
                            .background {
                                UltraBlurView()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.4).foregroundColor(.white)
                                    }
                            }
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                            .font(.adaptive(size: 11))
                            .padding()
                            .frame(width: 22, height: 22)
                            .background {
                                UltraBlurView()
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.4).foregroundColor(.white)
                                    }
                            }
                    }

                }
                 */
                
            }

            VStack(alignment: .leading, spacing: 6) {
                
                HStack {
                    
                    HStack(spacing: 2) {
                        
                        Text("\(taskManager.firstCharacter(of: task.taskCategory)!)")
                            .font(.adaptive(size: 9))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .frame(height: 19)
                            .background {
                                Circle()
                                    .fill(task.taskCategory == "專案" ? Color.darkOrangeColor : task.taskCategory == "會議" ? Color.darkGreenColor : task.taskCategory == "程式" ? Color.PrimaryDark : Color.BaseBlack)
                            }
                            .overlay {
                                Circle().stroke(lineWidth: 0.7).padding(-1.2).foregroundColor(task.taskCategory == "專案" ? Color.darkOrangeColor : task.taskCategory == "會議" ? Color.darkGreenColor : task.taskCategory == "程式" ? Color.PrimaryDark : Color.BaseBlack)
                            }
                        
                        if task.taskCategory != "休假" {
                            Text("\(String(format: "%.0f", task.taskProgress))%")
                                .font(.adaptive(size: 9))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .frame(height: 20)
                                .background {
                                    Capsule()
                                        .fill(Color.gradientColor(from: task.taskProgress, startColor: Color.homeRedColor, endColor: Color.homeGreenColor))
                                }
                        }
  
                    }
                    .padding(.trailing, task.taskCategory == "休假" ? -2.5 : 0)

                    Text("\(task.taskTitle)")
                        .lineLimit(1)
                        .font(.adaptive(size: 16).bold())

                    Spacer()

                    Text("\(DateManager.shared.hoursBetween(date1: task.taskStartDate, date2: task.taskEndDate).customFormatted) hrs")
                        .font(.adaptive(size: 12))
                        .foregroundColor(Color.BaseWhite)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 5).foregroundColor(Color.black.opacity(0.15))
                        }
//                        .padding(.top, 4)
                        .padding(.trailing, -15)
//                    
                }
                
                Text("項目描述：\(task.taskDescription == "" ? "無" : task.taskDescription)")
                    .lineLimit(1)
                    .font(.adaptive(size: 14))
                
                HStack {
                    
                    Text("開始時間：\(DateManager.shared.dateToStringNoSecond(date: task.taskStartDate))\n結束時間：\(DateManager.shared.dateToStringNoSecond(date: task.taskEndDate))")
                        .font(.adaptive(size: 14))
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        
                        Button {
                            showAlert.toggle()
                            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
                                taskManager.impactLight.impactOccurred()
                            }
                        } label: {
                            Image(systemName: "trash")
                                .font(.adaptive(size: 9.5))
                                .foregroundColor(Color.homeRedColor)
                                .padding()
                                .frame(width: 22, height: 22)
                                .background {
                                    UltraBlurView()
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.4).foregroundColor(.white)
                                        }
                                }
                        }
                        
                        Button {
                            
                            taskManager.selectedTask = task
                            taskManager.isEditing = true
                            showTaskView.toggle()
                            
                        } label: {
                            Image(systemName: "highlighter")
                                .font(.adaptive(size: 10))
                                .padding()
                                .frame(width: 22, height: 22)
                                .background {
                                    UltraBlurView()
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.4).foregroundColor(.white)
                                        }
                                }
                        }
                    }
                    .padding(.trailing, -15)
                    .padding(.bottom, -8)
                    
                    
                }

            }
            .foregroundColor(Color.darkBlueColor)
            
            Spacer()
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 16)
        .background {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(task.taskCategory == "專案" ? Color.red.opacity(0.16) : task.taskCategory == "會議" ? Color.green.opacity(0.16) : task.taskCategory == "程式" ? Color.blue.opacity(0.16) : Color.clear)
            
            UltraBlurView()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.6).foregroundColor(.white)
                }
        }
//        確定刪除此項\n[\(task.taskTitle)] 的紀錄？
//        [\(task.taskCategory)] - \(task.taskTitle)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("確定刪除此項\n[\(task.taskTitle)] 的紀錄？"),
                  message: Text(""),
                  primaryButton: .default(Text("取消")),
                  secondaryButton: .destructive(Text("確定"), action: {
                
                SQLiteCommands.deleteTask(taskValue: task)
                withAnimation(.easeInOut(duration: 0.5)) {
                    needUpdate.toggle()
                }
                DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.1) {
                    taskManager.impactLight.impactOccurred()
                }
            })
                  
            )
        }
        

    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskManager())
            .environmentObject(ReportViewModel())
    }
}
