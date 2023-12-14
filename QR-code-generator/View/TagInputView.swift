//
//  TagInputView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import SwiftUI
import RealmSwift

struct TagInputView: View {
    @State var tags:[String] = TagModel.tags
    
    @State var inputTags:Set<String> = []
    @Binding var tagsString:String
    
    func initInputTags() {
        for tag in tagsString.components(separatedBy: ",") {
            if tag.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                inputTags.insert(tag)
            }
        }
    }
    
    var body: some View {
        VStack {
            if tags.count > 0 {
                ScrollSelectButtonView(title: .init("tags"), strings: tags, selection: inputTags) { string in
                    initInputTags()
                    
                    if let idx = inputTags.firstIndex(of: string) {
                        inputTags.remove(at: idx)
                    } else {
                        inputTags.insert(string)
                    }
                    tagsString = inputTags.sorted().joined(separator: ",")
                }
            }
            Group {
                if #available(iOS 17.0, *) {
                    TextField("Tag input: separated by commas", text: $tagsString)
                        .onChange(of: tagsString) {
                            changeTextCheck()
                        }
                } else {
                    TextField("Tag input: separated by commas", text: $tagsString)
                        .onChange(of: tagsString, perform: { value in
                            changeTextCheck()
                        })
                }
            }
            .padding(5)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.black.opacity(0.2))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 1.0)
            }
        }
        .onAppear {
            tags = TagModel.tags
            initInputTags()
            TagModel.sync { error in
                tags = TagModel.tags
                initInputTags()
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
    TagInputView(tagsString: .constant("test"))
}
