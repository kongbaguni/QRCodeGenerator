//
//  TagCollectionView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/28/23.
//

import SwiftUI
import SwiftUIFlowLayout

struct TagCollectionView: View {
    let tags:[String]
    let onClick:(_ tag:String)->Void
    var body: some View {
        FlowLayout(mode: .scrollable,
                   items: tags,
                   itemSpacing: 4) { data in
            Button {
                onClick(data)
            } label: {
                Text(data)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.yellow)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(lineWidth: 2)
                    }

            }
        }.padding()
        
    }
}

#Preview {
    TagCollectionView(tags: [
        "test1",
        "da","asdf","rand","zzz","test 합니다","da","asdf","rand","zz zdsa",
        "test1","da","asdf","rand"
        ,"zzasd d z","test1"
        ,"금강산도 식후겸","asdf","rand","zzz"]) { tag in
            print(tag)
            
        }
}
