//
//  TableRowView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import Marquee

struct TableRowView: View {
    let header:Text
    let sub:Text
    let headWidth:CGFloat
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                HStack {
                    header
                        .lineLimit(.max)
                        .padding(.leading,5)
                    Spacer()
                }
                Spacer()
            }
            .foregroundStyle(.primary)
            .padding(5)
            .frame(width: headWidth)
            .background(.teal.opacity(0.25))
            .bold()
            .overlay {
                Rectangle()
                    .stroke(.primary)
            }
            
            VStack {
                Marquee {
                    sub
                        .lineLimit(.max)
//                        .padding(5)
                        .foregroundStyle(.primary)
                }
                .marqueeDirection(.right2left)
                .marqueeWhenNotFit(true)
                .marqueeDuration(10)
            }
            Spacer()
        }.overlay {
            Rectangle()
                .stroke(.primary)
        }
    }
}

#Preview {
    List {
        TableRowView(header: .init("title1"), sub: Text("testjkl djkl djsakl djskal  djklj  djkl jkljkl dsjm,a.jsdajdlkasjdlkasjdklasjdskladjaskldjaskljdslkajd "), headWidth: 100)
        TableRowView(header: .init("title2 asd asd"), sub: Text("test"), headWidth: 100)
        TableRowView(header: .init("title3"), sub: Text("test"), headWidth: 100)
    }
    .listStyle(.plain)
    
}
