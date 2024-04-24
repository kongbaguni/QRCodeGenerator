//
//  TagCollectionView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/28/23.
//

import SwiftUI
import SwiftUIFlowLayout

struct TagCloudView: View {
    let tags:[String]
    var vaildTags:[String] {
        var result:[String] = []
        for tag in tags {
            let str = tag.trimmingCharacters(in: .whitespacesAndNewlines)
            if str.isEmpty == false {
                result.append(str)
            }
        }
        return result
    }
    
    var body: some View {
        FlowLayout(mode: .scrollable,
                   items: vaildTags,
                   itemSpacing: 4) { data in
            if data.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                EmptyView()
            } else {
                NavigationLink {
                    CodeListView(tag: data)
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
            }
        }
        .padding(5)
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(lineWidth: vaildTags.count > 0 ? 1.0 : 0.0)
        }
        
    }
}

#Preview {
    NavigationView {
        NavigationStack {
            TagCloudView(tags: [
                "test1",
                "da","asdf","rand","zzz","test 합니다","da","asdf","rand","zz zdsa",
                "test1","da","asdf","rand"
                ,"zzasd d z","test1"
                ,"금강산도 식후겸","asdf","rand","zzz"])
            TagCloudView(tags: [""])
        }
    }
}
