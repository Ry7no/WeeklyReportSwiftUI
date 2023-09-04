//
//  HUDView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/12.
//

import SwiftUI

struct HUDView: View {
 
    var image: String
    var title: String
    var bgColor: Color

    @State var showHUD: Bool = false
    
    var body: some View{
        
        HStack(spacing: 10){
            
            if image != "" {
                Image(systemName: image)
                    .font(.adaptive(size: 18))
                    .foregroundColor(.white)
            }

            Text(title)
                .font(.adaptive(size: 16))
                .foregroundColor(.white)
            
            Spacer()
            
        }
        .padding(.horizontal)
        .frame(height: 35)
        .background(
            Capsule().fill(bgColor)
        )
        .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 1, y: 5)
        .shadow(color: Color.primary.opacity(0.03), radius: 5, x: 0, y: -5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // top
        .offset(y: showHUD ? 0 : -250)
        .onAppear {
            
            withAnimation(.easeInOut(duration: 0.5)){
                showHUD = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)){
                    showHUD = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    
                    getRootController().view.subviews.forEach { view in
                        if view.tag == 1009{
                            
                            view.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}

extension View {

    func showHUDView(image: String, title: String, bgColor: Color = .primary, completion: @escaping (Bool, String)->()){
        
        if getRootController().view.subviews.contains(where: { view in
            return view.tag == 1009
        }){
            
            completion(false, "Already Presenting")
            return
        }
        
        let hudViewController = UIHostingController(rootView: HUDView(image: image, title: title, bgColor: bgColor))
        let size = hudViewController.view.intrinsicContentSize
        
        hudViewController.view.frame.size = size
        hudViewController.view.frame.origin = CGPoint(x: (getRect().width / 2) - (size.width / 2), y: 50)
        hudViewController.view.backgroundColor = .clear
        hudViewController.view.tag = 1009
        
        getRootController().view.addSubview(hudViewController.view)
        
    }
}
