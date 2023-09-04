//
//  CalendarView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var taskManager: TaskManager

//    @State private var currentDate: Date = Date()
    @State private var currentMonth: Int = 0
    
    @State private var offset: CGSize = .zero
    @State private var didJustSwipe = false
    
    @State private var isMonth: Bool = false
    
    var body: some View {
        
        VStack(spacing: 30) {
            
            let days: [String] = ["日", "一", "二", "三", "四", "五", "六"]
            
            // Bar
            HStack {
                
                Button {
                    currentMonth -= 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    }
                    
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Button {
                    isMonth.toggle()
                } label: {
                    Text(DateManager.shared.formatDateToMonthYear(date: taskManager.currentDate) ?? "")
                }

                Spacer()
                
                Button {
                    currentMonth += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        let impactLight = UIImpactFeedbackGenerator(style: .light)
                        impactLight.impactOccurred()
                    }

                } label: {
                    Image(systemName: "chevron.right")
                        
                }

            }
            .font(.system(size: 16))
            .padding(.horizontal, 20)
            
            // Week Name
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.adaptive(size: 13))
                        .frame(minWidth: 0, maxWidth: .infinity)

                }
            }

            // Month View
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(extractDate(userTasks: taskManager.fetchedSqlTasks)) { value in
                    DayCardView(value: value)
                        .gesture(DragGesture(minimumDistance: 0).onChanged({ (value) in
                            onChanged(value: value)
                        }).onEnded({ (value) in
                            onEnded(value: value)
                        }))
                    
                }
            }
            .padding(.horizontal, 4)
            
        }
        .background(Color.clear)
        .onChange(of: currentMonth) { newValue in
            taskManager.currentDate = getCurrentMonth()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                taskManager.fetchedDateValues = extractDate(userTasks: taskManager.fetchedSqlTasks)
                taskManager.fetchedDateValues.forEach { dateValue in
                    if isSameDay(date1: dateValue.date, date2: Date()) {
                        taskManager.selectedDateValue = dateValue
                    }
                }
            }
            
        }
    }

    @ViewBuilder
    func DayCardView(value: DateValue) -> some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            if value.day != -1 {

                Text("\(value.day)")
                    .font(.adaptive(size: 14))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 3)
                    .onTapGesture {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let impactLight = UIImpactFeedbackGenerator(style: .light)
                            impactLight.impactOccurred()
                        }
                        taskManager.selectedDateValue = value
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.PrimaryBase)
                            .frame(width: 32, height: 32)
                            .padding(.horizontal, 5)
                            .opacity(isSameDay(date1: value.date, date2: taskManager.selectedDateValue.date) ? 1 : 0)

                    }

                HStack(spacing: 5) {
                    
                    if value.tasks.count != 0 {
                        if value.tasks.count > 3 {
                            ForEach(0..<min(value.tasks.count, 3)) { _ in
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
                    
//                    if value.tasks.count > 3 {
//                        HStack(spacing: 1.6) {
//                            ForEach(0..<3) { _ in
//                                Circle()
//                                    .frame(width: 1.2, height: 1.2)
//                                    .foregroundColor(Color.SecondaryYellow)
//                            }
//                        }
//                        .frame(width: 8)
//                    }
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
    
    func extractDate(userTasks: [Task]) -> [DateValue] {

        let calendar = Calendar.current

        let currentMonth = getCurrentMonth()

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
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isAfterTomorrow(date: Date) -> Bool {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        return date > tomorrow
    }
    
    func extractDateString() -> [String] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: taskManager.currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.current

        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else { return Date() }
        
        return currentMonth
        
    }
    
    func offset(for i: Int) -> CGSize {
        return i == currentMonth ? offset : .zero
    }

    func onChanged(value: DragGesture.Value) {
        
    }
    
    func onEnded(value: DragGesture.Value) {
        
        withAnimation {
            
            if value.translation.width > 0 && value.translation.width > UIScreen.main.bounds.width / 4.5 {
                currentMonth -= 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }
                print("@ -")
            } else if value.translation.width < 0 && -value.translation.width > UIScreen.main.bounds.width / 4.5 {
                currentMonth += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    let impactLight = UIImpactFeedbackGenerator(style: .light)
                    impactLight.impactOccurred()
                }
                print("@ +")
            }

        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TaskManager())
    }
}
