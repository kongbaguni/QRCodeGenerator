//
//  TagInputView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import SwiftUI
import RealmSwift

struct TagInputView: View {
    let tags:[String]
    
    @State var inputTags:Set<String> = []
    @Binding var tagsString:String
    
    var body: some View {
        VStack {
            if tags.count > 0 {
                ScrollSelectButtonView(title: .init("tags"), strings: tags) { string in
                    inputTags.insert(string)
                    tagsString = inputTags.sorted().joined(separator: ",")
                }
            }
            if #available(iOS 17.0, *) {
                TextField("Tag input: separated by commas", text: $tagsString)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: tagsString) {
                        changeTextCheck()
                    }
            } else {
                TextField("Tag input: separated by commas", text: $tagsString)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: tagsString, perform: { value in
                        changeTextCheck()
                    })
            }
        }
    }
    
    func changeTextCheck() {
        print(tagsString)
        inputTags.removeAll()
        for str in tagsString.components(separatedBy: ",") {
            if str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                inputTags.insert(str)
            }
        }
    }
}

#Preview {
    TagInputView(tags: ["홈페이지","하하"],tagsString: .constant("test"))
}
