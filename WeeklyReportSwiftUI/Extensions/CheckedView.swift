//
//  CheckedView.swift
//  WeeklyReportSwiftUI
//
//  Created by Br7 on 2022/6/26.
//

import SwiftUI

struct CheckedView: View {
    var body: some View {
        VStack {
            LottieView(filename: "Checked")
                .frame(width: 160, height: 160)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
        }
    }
}

struct CheckedView_Previews: PreviewProvider {
    static var previews: some View {
        CheckedView()
    }
}
