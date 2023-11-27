//
//  ScrollTabBarView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import SwiftUI

struct ScrollTabBarView: View {
    let titles:[Text]
    @Binding var selectedIndex:Int
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators:false) {
                HStack {
                    Spacer()
                    ForEach(titles.indices, id:\.self) { index in
                        titles[index]
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .foregroundStyle(selectedIndex == index ? .white : .black)
                            .background(selectedIndex == index ? .black : .yellow)
                            .cornerRadius(10)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
            .padding(.vertical, 5)
            .background(.teal)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2.0)
            }
            
        }
    }
}

#Preview {
    ScrollTabBarView(titles: [
        .init("01"),
        .init("02"),
        .init("03"),
    ], selectedIndex: .constant(0))
}
