//
//  FloatingCloudsView.swift
//  WeeklyReportSwiftUI
//
//  Created by @Ryan on 2023/8/11.
//

import SwiftUI

struct UltraBlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}

struct FloatingCloudsView: View {
    
    @Environment(\.colorScheme) var scheme
    @State var isDarker: Bool = false
    
    let blur: CGFloat = 50

    var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                if isDarker {
                    Theme.background
                    Rectangle().fill(.ultraThinMaterial.blendMode(.normal))
                } else {
                    Theme.background
                }

                ZStack {
                    
                    Cloud(proxy: proxy,
                          color: Color.purplePinkColor,
                          rotationStart: 180,
                          duration: 70,
                          alignment: .topLeading)
                    
                    Cloud(proxy: proxy,
                          color: Color.purpleLightColor,
                          rotationStart: 240,
                          duration: 50,
                          alignment: .topTrailing)
                    
                    Cloud(proxy: proxy,
                          color: Color.purpleColor,
                          rotationStart: 120,
                          duration: 80,
                          alignment: .bottomLeading)
                    
                    Cloud(proxy: proxy,
                          color: Color.purpleBlueColor,
                          rotationStart: 0,
                          duration: 60,
                          alignment: .bottomTrailing)

                }
                .blur(radius: blur)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .ignoresSafeArea()
        }
    }
}

struct Theme {
    
    static var background: Color {
        Color.PrimaryDark
    }

    
    static var generalBackgroundDarker: Color {
        
        Color("AppPurpleDark").opacity(0.9)
//        Color(red: 0.043, green: 0.467, blue: 0.494)
    }
    
    static var generalBackground: Color {
        Color("AppPurple").opacity(0.9)
    }
    
    static var generalBackgroundLighter: Color {
        Color("AppPurpleLight").opacity(0.9)
    }

    static func ellipsesTopLeading(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.039, green: 0.388, blue: 0.502, opacity: 0.81)
        let dark = Color(red: 0.000, green: 0.176, blue: 0.216, opacity: 80.0)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }

    static func ellipsesTopTrailing(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.196, green: 0.796, blue: 0.329, opacity: 0.5)
        let dark = Color(red: 0.408, green: 0.698, blue: 0.420, opacity: 0.61)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }

    static func ellipsesBottomTrailing(forScheme scheme: ColorScheme) -> Color {
        Color(red: 0.541, green: 0.733, blue: 0.812, opacity: 0.7)
    }

    static func ellipsesBottomLeading(forScheme scheme: ColorScheme) -> Color {
        let any = Color(red: 0.196, green: 0.749, blue: 0.486, opacity: 0.55)
        let dark = Color(red: 0.525, green: 0.859, blue: 0.655, opacity: 0.45)
        switch scheme {
        case .light:
            return any
        case .dark:
            return dark
        @unknown default:
            return any
        }
    }
}

class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat

    init() {
        frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)
        offset = CGSize(width: CGFloat.random(in: -150 ..< 150),
                        height: CGFloat.random(in: -150 ..< 150))
    }
}

struct Cloud: View {
    @StateObject var provider = CloudProvider()
    @State var move = false
    let proxy: GeometryProxy
    let color: Color
    let rotationStart: Double
    let duration: Double
    let alignment: Alignment

    var body: some View {
        Circle()
            .fill(color)
            .frame(height: proxy.size.height /  provider.frameHeightRatio)
            .offset(provider.offset)
            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360) )
            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .opacity(0.8)
            .onAppear {
                move.toggle()
            }
    }
}

struct FloatingCloudsView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingCloudsView()
    }
}
