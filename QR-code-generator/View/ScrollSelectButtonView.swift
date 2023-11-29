//
//  ScrollSelectButtonView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import SwiftUI

struct ScrollSelectButtonView: View {
    let title:Text
    let strings:[String]
    let selection:Set<String>
    let onTouch:(_ string:String)->Void
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators:false) {
                HStack {
                    Spacer()
                    title
                    ForEach(strings.indices, id:\.self) { index in
                        Button {
                            onTouch(strings[index])
                        } label : {
                            Text(strings[index])
                                .font(.subheadline)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                                .foregroundStyle(.black)
                                .background(selection.firstIndex(of: strings[index].trimmingCharacters(in:  .whitespacesAndNewlines)) == nil ? .yellow : .gray)
                                .cornerRadius(10)
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
    ScrollSelectButtonView(title:.init("tags") ,strings: ["test","test2"], selection: ["test"]) { string in
        print(string)
    }
}
