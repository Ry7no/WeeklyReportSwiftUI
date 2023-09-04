//
//  EditListView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import SwiftUI

struct EditListView: View {
    
    enum FocusField: Hashable {
        case field
    }
    
    @EnvironmentObject var taskManager: TaskManager
    
    @Environment(\.presentationMode) var presentationMode

    @Binding var sheetTitle: String
    @Binding var items: [String]
    @Binding var isSaving: Bool
    
    @State private var itemsCount: Int = 0
    @State private var isMove: Bool = false
    
    @FocusState private var focusedField: FocusField?
    
    @State private var isDragging: Bool = false
    @State private var selectedString: String = ""
    @State private var selectedIndex: Int?
    
    @State private var showAlert: Bool = false
    
    // For Adding
    @State private var isAdding: Bool = false

    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Color.SecondaryBlue.ignoresSafeArea()
            
            VStack {
                
                
                HStack {
                    
                    Text(sheetTitle)
                        .font(.adaptive(size: 17))
                        .fontWeight(.semibold)
                        .kerning(0.24)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.adaptive(size: 20))
                            .foregroundColor(Color.white)
                    }

                }
                .padding([.top, .horizontal])

                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 3)

                List {

                    ForEach(Array($items.indices), id: \.self) { index in
                        
                        ItemRow(index: index)
                        
                    }
                    .onMove(perform: move)
                    
                    

                    Color.SecondaryBlue.frame(height: 50)
                        .listRowBackground(Color.SecondaryBlue)
                    
                }
                .listStyle(.plain)
                
                Spacer()
//                .environment(\.editMode, .constant(self.isDragging ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
   
            }
            .frame(maxHeight: .infinity)


            HStack(alignment: .center, spacing: 16) {
                
                Button {
                    
                    if isAdding {
                        
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            taskManager.impactLight.impactOccurred()
                        }
                        withAnimation {
                            items.append("")
                            selectedIndex = items.count - 1
                            isAdding = true
                        }
                    }

                } label: {
                    
                    Text("新增選項")
                        .font(.adaptive(size: 16))
                        .padding(.horizontal, 16)
                        .padding(.vertical)
                        .frame(height: 42)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background {
                            Color.SecondaryBlue
                            RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1)
                        }
                        .foregroundColor(Color.PrimaryBase)
                        .cornerRadius(8)
                    
                }
                
                Button {
                    
                    if isAdding {
                        isAdding = false
                    }
                    
                    isSaving = true
                    taskManager.isSaving = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        taskManager.impactLight.impactOccurred()
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    Text("儲存")
                        .font(.adaptive(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical)
                        .frame(height: 42)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.PrimaryBase)
                        .cornerRadius(8)
                }
                
            }
            .padding()

        }
        


    }
    
    @ViewBuilder
    private func ItemRow(index: Int) -> some View {
        
        HStack(spacing: 0) {
            
            Image(systemName: "arrowtriangle.right.fill")
                .font(.adaptive(size: 6))
                .foregroundColor(.white)
                .padding(.trailing, selectedIndex == index ? 12 : 0)
            
            TextField("請輸入選項名稱，限 15 個字元", text: $items[index])
                .font(.adaptive(size: selectedIndex == index ? 14 : 16))
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .disabled(selectedIndex != index)
                .focused($focusedField, equals: .field)
                .onChange(of: items[index]) { newValue in
                    
                    if isAdding {
                        if items.contains(newValue) && items.firstIndex(of: newValue) != index {
                            items[index] = getUniqueName(for: newValue, in: items)
                        }
                    }

                    if items[index].count > 15 {
                        items[index] = String(items[index].prefix(15))
                    }
                }
                .background {
                    
                    if selectedIndex == index {
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8).foregroundColor(.white)
                            RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.46, green: 0.38, blue: 0.66), lineWidth: 1)
                        }
                        .onAppear {
                            
                            if isAdding {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    self.focusedField = .field
                                }
//                                isAdding = false
                            }
                            
                        }
                        
                    } else {
                        Color.clear
                    }
                    
                }
            
            Spacer()
            
            if items[index] != "" {
                Image(systemName: "trash")
                    .font(.adaptive(size: 14))
                    .foregroundColor(.white)
                    .onTapGesture {
                        
                        taskManager.impactLight.impactOccurred()
                        
                        if selectedIndex == index {
                            
                            let tempIndex = selectedIndex
                            selectedIndex = nil
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                
                                withAnimation {
                                    deleteItem(at: tempIndex!)
                                }
                            }
                            
                        } else {
                            withAnimation {
                                deleteItem(at: index)
                            }
                        }
                        
                    }
                    .padding(.trailing, 16)
                
            }
            
            Image(systemName: selectedIndex == index ? "arrow.turn.up.left" : "pencil")
                .font(.adaptive(size: 16))
                .foregroundColor(.white)
                .onTapGesture {
                    
                    taskManager.impactLight.impactOccurred()
                    
                    if isAdding && selectedIndex == index {
                        isAdding = false
                    } else {
                        isAdding = true
                    }
                    
                    withAnimation {
                        if selectedIndex == index {
                            selectedIndex = nil
                        } else {
                            selectedIndex = index
                        }
                    }
                }
 
        }
        .padding(.trailing, 8)
        .foregroundColor(selectedIndex == index ? .black : .white.opacity(0.8))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.SecondaryBlue)
        .frame(height: 45)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            items.move(fromOffsets: source, toOffset: destination)
        }
    }
    
    private func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
    func deleteItem(at index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            items.remove(at: index)
        }
    }

    func getUniqueName(for base: String, in array: [String]) -> String {
        var uniqueName = base
        var counter = 1
        
        while array.contains(uniqueName) {
            uniqueName = base + "\(counter)"
            counter += 1
        }
        
        return uniqueName
    }
    
}
