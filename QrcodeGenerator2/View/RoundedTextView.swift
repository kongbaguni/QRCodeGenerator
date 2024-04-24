//
//  RoundButtonView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import SwiftUI

struct RoundedTextView: View {
    struct Style {
        let font:Font
        let cornerRadius:CGFloat
        let foregroundColors:[Color]
        let backgroundColor:Color
    }
    
    enum StyleType {
        case normal
        case cancel
        case weak
        var styleValue:Style {
            switch self {
            case .normal:
                return .init(font: .system(size: 12),
                             cornerRadius: 25,
                             foregroundColors: [
                                ThemeManager.shared.btn1Foreground,
                                ThemeManager.shared.btn1Foreground.opacity(0.5),
                                ThemeManager.shared.btn1Foreground.opacity(0.2)
                             ],
                             backgroundColor: ThemeManager.shared.btn1Background)
            case .cancel:
                return .init(font: .system(size:12),
                             cornerRadius: 25,
                             foregroundColors: [
                                ThemeManager.shared.btn2Foreground,
                                ThemeManager.shared.btn2Foreground.opacity(0.5),
                                ThemeManager.shared.btn2Foreground.opacity(0.2)
                             ],
                             backgroundColor: ThemeManager.shared.btn2Background)
            case .weak:
                return .init(font: .system(size: 10), cornerRadius: 15,
                             foregroundColors: [
                                ThemeManager.shared.btn3Foreground,
                                ThemeManager.shared.btn3Foreground.opacity(0.5),
                                ThemeManager.shared.btn3Foreground.opacity(0.2)
                             ], backgroundColor: ThemeManager.shared.btn3Background)
            }
        }
    }

    let text:Text
    let image:Image?
    let style:StyleType
  
    @State var foregroundColors:[Color] = [.primary,.secondary,.teal]
    @State var backgroundColor:Color = .clear
    
    func loadColor() {
        foregroundColors = style.styleValue.foregroundColors
        backgroundColor = style.styleValue.backgroundColor
    }
    
    var styledImg: some View {
        Group {
            if let img = image {
                switch style.styleValue.foregroundColors.count {
                case 1:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(foregroundColors[0])
                        
                case 2:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(
                            foregroundColors[0]
                            ,foregroundColors[1]
                        )
                case 3:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(
                            foregroundColors[0]
                            ,foregroundColors[1]
                            ,foregroundColors[2]
                        )
                default:
                     img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                }
            } else {
                EmptyView()
            }
            
        }
        
    }
    
    var body: some View {
        HStack {
            styledImg
            text
            Spacer()
        }
        .padding()
        .foregroundStyle(foregroundColors[0])
        .background{
            RoundedRectangle(cornerRadius: style.styleValue.cornerRadius)
                .foregroundStyle(backgroundColor)
        }
        .overlay {
            RoundedRectangle(cornerRadius: style.styleValue.cornerRadius)
                .stroke(foregroundColors[0], lineWidth: 2)
        }.onReceive(NotificationCenter.default.publisher(for: .themeSettingChanged, object: nil), perform: { _ in
            loadColor()
        })
        .onAppear {
            loadColor()
        }
            
    }
}

#Preview {
    HStack {
        RoundedTextView(text:.init("test"), image:  .init(systemName: "rectangle.portrait.and.arrow.forward") ,style: .normal)
        RoundedTextView(text:.init("test"), image: .init(systemName: "rectangle.portrait.and.arrow.forward") ,style: .cancel)
    }
    
}
