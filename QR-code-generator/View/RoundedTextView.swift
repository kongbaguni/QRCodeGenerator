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
                             foregroundColors: [.primary, .secondary],
                             backgroundColor: .teal)
            case .cancel:
                return .init(font: .system(size:12),
                             cornerRadius: 25,
                             foregroundColors: [.red, .orange, .white],
                             backgroundColor: .yellow)
            case .weak:
                return .init(font: .system(size: 10), cornerRadius: 15, foregroundColors: [.secondary, .primary,.teal], backgroundColor: .clear)
            }
        }
    }

    let text:Text
    let image:Image?
    let style:StyleType
  
    var styledImg: some View {
        Group {
            if let img = image {
                switch style.styleValue.foregroundColors.count {
                case 1:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(style.styleValue.foregroundColors[0])
                        
                case 2:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(
                            style.styleValue.foregroundColors[0]
                            ,style.styleValue.foregroundColors[1]
                        )
                case 3:
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(
                            style.styleValue.foregroundColors[0]
                            ,style.styleValue.foregroundColors[1]
                            ,style.styleValue.foregroundColors[2]
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
        .foregroundStyle(style.styleValue.foregroundColors[0])
        .background{
            RoundedRectangle(cornerRadius: style.styleValue.cornerRadius)
                .foregroundStyle(style.styleValue.backgroundColor)
        }
        .overlay {
            RoundedRectangle(cornerRadius: style.styleValue.cornerRadius)
                .stroke(style.styleValue.foregroundColors[0], lineWidth: 2)
        }
            
    }
}

#Preview {
    HStack {
        RoundedTextView(text:.init("test"), image:  .init(systemName: "rectangle.portrait.and.arrow.forward") ,style: .normal)
        RoundedTextView(text:.init("test"), image: .init(systemName: "rectangle.portrait.and.arrow.forward") ,style: .cancel)
    }
    
}
