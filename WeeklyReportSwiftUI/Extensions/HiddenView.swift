//
//  HiddenView.swift
//  WeeklyReportSwiftUI
//
//  Created by Br7 on 2022/6/25.
//

import SwiftUI

extension View {

    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
