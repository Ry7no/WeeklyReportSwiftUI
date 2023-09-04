//
//  CustomDatePicker.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import Foundation
import SwiftUI

struct CustomDatePicker: View {
    
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {
        
        ZStack {
            
            Color.BaseBlackOpacity50
            
            VStack(spacing: 15) {
                
                DatePicker("", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute]).datePickerStyle(.graphical)
    //                .environment(\.locale, Locale.init(identifier: "zh_Hant"))
                    .font(.adaptive(size: 14))
                    .padding(.top, -8)
                    .padding(.bottom, -4)
                    .preferredColorScheme(.light)
                
    //            Divider()
                
                HStack(alignment: .center, spacing: 15) {
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showDatePicker = false
                        }
                    } label: {
                        Text("取消")
                            .font(.adaptive(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.PrimaryBase)
                            .cornerRadius(8)
                            
                    }
                    
                    Button {
                        savedDate = selectedDate
                        withAnimation(.easeIn) {
                            showDatePicker = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                        }
                    } label: {
                        Text("確定")
                            .font(.adaptive(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color.PrimaryDark)
                            .cornerRadius(8)
                            
                    }

                }
                
    //            HStack {
    //
    //                Button(action: {
    //                    withAnimation(.easeInOut) {
    //                        showDatePicker = false
    //                    }
    //                }, label: {
    //
    //                    Text("取消")
    //                        .font(.system(size: 16).bold())
    //                        .foregroundColor(.red)
    //                        .padding([.vertical], 7)
    //                        .padding([.horizontal], 25)
    //                        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(.red))
    //
    //                })
    //
    //                Spacer()
    //
    //                Button(action: {
    //                    savedDate = selectedDate
    //                    withAnimation(.easeIn) {
    //                        showDatePicker = false
    //                    }
    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    //                        let impactLight = UIImpactFeedbackGenerator(style: .light)
    //                        impactLight.impactOccurred()
    //                    }
    //                }, label: {
    //                    Text("確定")
    //                        .font(.system(size: 16).bold())
    //                        .foregroundColor(.white)
    //                        .padding([.vertical], 7)
    //                        .padding([.horizontal], 25)
    //                        .background(Color("Yellow").clipShape(RoundedRectangle(cornerRadius: 10)))
    //                        .background(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color("Yellow")))
    //                })
    //
    //            }
                
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width - 30)
            .background(
                Color.white
                    .cornerRadius(15)
            )
        }
        
        
        
        
        
    }
}

