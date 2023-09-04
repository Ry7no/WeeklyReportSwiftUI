//
//  Extensions.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/10.
//

import Foundation
import SwiftUI

extension Color {
    
    // Primary
    static let PrimaryBase = Color(#colorLiteral(red: 0.5779236555, green: 0.7500825524, blue: 0.8109346628, alpha: 1)) // Base
    static let PrimaryDark = Color(#colorLiteral(red: 0.1149325594, green: 0.3627199531, blue: 0.6063907146, alpha: 1))  // Dark
    static let PrimaryBaseOpacity40 = Color(#colorLiteral(red: 0.5779236555, green: 0.7500825524, blue: 0.8109346628, alpha: 1)).opacity(0.4)

    // Secondary
    static let SecondaryBlue = Color(#colorLiteral(red: 0.1382403076, green: 0.1777792871, blue: 0.4087888598, alpha: 1))
    static let SecondaryDarkBlue = Color(#colorLiteral(red: 0.08392318338, green: 0.1122986749, blue: 0.2823827267, alpha: 1))
    static let SecondaryDarkBlueOpacity40 = Color(#colorLiteral(red: 0.08424624056, green: 0.1170893088, blue: 0.2823737264, alpha: 1)).opacity(0.4)
    static let SecondaryYellow = Color(#colorLiteral(red: 0.9534497857, green: 0.6978744268, blue: 0.2650270164, alpha: 1))
    
    // White
    static let BaseWhite = Color(#colorLiteral(red: 0.9353198409, green: 0.9353198409, blue: 0.9353198409, alpha: 1))
    static let BaseWhiteOpacity50 = Color(#colorLiteral(red: 0.9353198409, green: 0.9353198409, blue: 0.9353198409, alpha: 1)).opacity(0.5)
    static let BaseWhiteOpacity80 = Color(#colorLiteral(red: 0.9353198409, green: 0.9353198409, blue: 0.9353198409, alpha: 1)).opacity(0.8)
    
    // Black
    static let BaseBlack = Color(#colorLiteral(red: 0.2418233454, green: 0.2418342233, blue: 0.2462815046, alpha: 1))
    static let BaseBlackOpacity50 = Color(#colorLiteral(red: 0.2418233454, green: 0.2418342233, blue: 0.2462815046, alpha: 1)).opacity(0.5)
    static let BaseBlackOpacity05 = Color(#colorLiteral(red: 0.2418233454, green: 0.2418342233, blue: 0.2462815046, alpha: 1)).opacity(0.05)
    
    // SystemColor
    static let Error = Color(#colorLiteral(red: 0.8859390616, green: 0.371355474, blue: 0.3435535729, alpha: 1))
    static let Success = Color(#colorLiteral(red: 0.3955483437, green: 0.6809468269, blue: 0.4586374164, alpha: 1))
    
    static let homeRedColor = Color(#colorLiteral(red: 0.7014058232, green: 0.07429151982, blue: 0.0709830299, alpha: 1))
    static let homeGreenColor = Color(#colorLiteral(red: 0.1045525745, green: 0.3660890758, blue: 0.1024298593, alpha: 1))
    
    static let skinColor = Color(#colorLiteral(red: 1, green: 0.5808969736, blue: 0.578376472, alpha: 1))
    static let greenColor = Color(#colorLiteral(red: 0.3751052916, green: 0.5999268889, blue: 0.3993713856, alpha: 1))
    static let navyColor = Color(#colorLiteral(red: 0.07978292555, green: 0.2597567141, blue: 0.4486560822, alpha: 1))
    
    static let orangeColor = Color(#colorLiteral(red: 0.8839624524, green: 0.3014259338, blue: 0.1651532948, alpha: 1))
    static let darkBlueColor = Color(#colorLiteral(red: 0.1679833531, green: 0.2050396204, blue: 0.4037947059, alpha: 1))
    
    static let purpleColor = Color(#colorLiteral(red: 0.647262156, green: 0.3331556916, blue: 0.9240896106, alpha: 1))
    static let purplePinkColor = Color(#colorLiteral(red: 0.7770558596, green: 0.5361503363, blue: 0.7768468261, alpha: 1))
    static let purpleLightColor = Color(#colorLiteral(red: 0.7190495133, green: 0.6012201309, blue: 0.9996199012, alpha: 1))
    static let purpleBlueColor = Color(#colorLiteral(red: 0.2422194481, green: 0.3284125328, blue: 0.6762429476, alpha: 1))
    
    static let darkOrangeColor = Color(#colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
    static let darkRedColor = Color(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))
    static let darkGreenColor = Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))
    
    static func gradientColor(from value: Double, startColor: Color = .red, endColor: Color = .green) -> Color {
        let clampedValue = max(0.0, min(1.0, value / 100.0))
        
        let redValue = startColor.redValue + clampedValue * (endColor.redValue - startColor.redValue)
        let greenValue = startColor.greenValue + clampedValue * (endColor.greenValue - startColor.greenValue)
        let blueValue = startColor.blueValue + clampedValue * (endColor.blueValue - startColor.blueValue)
        
        return Color(red: redValue, green: greenValue, blue: blueValue)
    }
    
    var redValue: Double {
        return Double(CGColor?.components?[0] ?? 0)
    }
    
    var greenValue: Double {
        return Double(CGColor?.components?[1] ?? 0)
    }
    
    var blueValue: Double {
        return Double(CGColor?.components?[2] ?? 0)
    }
    
    var CGColor: CoreGraphics.CGColor? {
        return self.cgColor
    }

}

extension Font {
    
    static func adaptive(size: CGFloat) -> Font {
        let screenWidth = UIScreen.main.bounds.width
        let fontSize = screenWidth * (size / 400)
        return .system(size: fontSize)
    }
    
    static func adaptive(rate: CGFloat) -> Font {
        let screenWidth = UIScreen.main.bounds.width
        return .system(size: screenWidth * (rate / 100))
    }
    
}

extension Date {
    
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func toTaiwanDateString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: self) - 1911
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        return "\(year)/\(String(format: "%02d", month))/\(String(format: "%02d", day))"
    }
    
    func toTaiwanDateTitleString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: self) - 1911
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        
        return "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
    }
    
    func isOnSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
    
    func isBetween(_ start: Date, and end: Date) -> Bool {
        return self >= start && self <= end
    }
    
    func at(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? self
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}


extension View {

    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }
        
        return safeArea
    }
    
    func getRootController()->UIViewController{
        
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.last?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    
    func spotlight(enabled: Bool, title: String = "") -> some View {
        self
            .overlay {
                
                if enabled {
                    
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .global)
                        SpotlightView(rect: rect, title: title) {
                            self
                        }
                        
                    }
                    
                }
            }
    }
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }

}

extension Double {
    
    var customFormatted: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(self))"
        } else {
            return String(format: "%.1f", self)
        }
    }
    
    var roundedToFirstDecimal: Double {
        return (self * 10).rounded() / 10
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
//        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension AnyTransition {
    static var slideFromTrailing: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var slideFromLeading: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

extension Array: RawRepresentable where Element: Codable {
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct SpotlightView<Content: View>: View {
    
    var content: Content
  
    var rect: CGRect
    var title: String
    
    init(rect: CGRect, title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.title = title
        self.rect = rect
    }
    
    @State var tag: Int = 1009
    
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.03))
            .onAppear {
                addOverlayView()
            }
            .onDisappear {
                removeOverlayView()
            }
    }
    
    func removeOverlayView() {
        getRootController().view.subviews.forEach { view in
            if view.tag == self.tag {
                view.removeFromSuperview()
            }
        }
    }
    
    func addOverlayView() {
        
        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
        hostingView.view.frame = screenBounds()
        hostingView.view.backgroundColor = .clear
        
        if self.tag == 1009 {
            self.tag = generateRandom()
        }
        hostingView.view.tag = self.tag
        
        getRootController().view.subviews.forEach { view in
            if view.tag == self.tag { return }
        }
        
        getRootController().view.addSubview(hostingView.view)
    }
    
    @ViewBuilder
    func overlaySwiftUIView() -> some View {
        ZStack {
            
            Rectangle()
                .fill(Color.black.opacity(0.8))
                .mask({
                    
                    let radius = (rect.height / rect.width) > 0.7 ? rect.width : 10
                    
                    Rectangle()
                        .overlay {
                            content
                                .frame(width: rect.width, height: rect.height)
                                .padding(10)
                                .background(.white, in: RoundedRectangle(cornerRadius: radius))
                                .position()
                                .offset(x: rect.midX, y: rect.midY)
                                .blendMode(.destinationOut)
                        }
                })
            
            if title != "" {
                Text(title)
                    .font(.adaptive(size: 28).bold())
                    .foregroundColor(.white)
                    .position()
                    .offset(x: screenBounds().midX, y: rect.maxY > (screenBounds().height - 60) ? (rect.minY - 60) : (rect.maxY + 60))
                    .padding()
                    .lineLimit(1)
            }
        }
        .frame(width: screenBounds().width, height: screenBounds().height)
        .ignoresSafeArea()
    }
    
    func generateRandom() -> Int {
        
        let random = Int(UUID().uuid.0)
        
        let subViews = getRootController().view.subviews
        
        for index in subViews.indices {
            if subViews[index].tag == random {
                return generateRandom()
            }
        }
        
        return random
    }
}
