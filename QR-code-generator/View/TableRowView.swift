//
//  TableRowView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct TableRowView: View {
    let header:Text
    let sub:Text
    let headWidth:CGFloat
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .center) {
                header
                    .frame(width: headWidth)
                Spacer()
            }
            .foregroundStyle(.white)
            .padding(5)
            .background(.teal)
            .bold()
            .overlay {
                Rectangle()
                    .stroke(.primary)
            }
            VStack {
                sub
                    .padding(5)
                    .foregroundStyle(.primary)
                Spacer()
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
        TableRowView(header: .init("title1"), sub: Text("testjkl djkl djsakl djskal  djklj  djkl jkljkl "), headWidth: 100)
        TableRowView(header: .init("title2 asd asd"), sub: Text("test"), headWidth: 100)
        TableRowView(header: .init("title3"), sub: Text("test"), headWidth: 100)
    }
    .listStyle(.plain)
    
}
