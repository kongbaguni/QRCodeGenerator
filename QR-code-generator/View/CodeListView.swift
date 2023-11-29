//
//  CodeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/29/23.
//

import SwiftUI
import RealmSwift

struct CodeListView: View {
    let tag:String?

    @ObservedResults (
        CodeModel.self,
        sortDescriptor: .init(
            keyPath: "updateDtTimeIntervalSince1970",
            ascending: false)
        
    ) var codelist
    
    var body: some View {
        List {
            ForEach(codelist, id:\.self) { code in
                HStack {
                    NavigationLink {
                        CodeDetailView(code: code)
                    }label: {
                        code.image
                            .resizable()
                            .scaledToFit()
                            .frame(height:100)
                        
                        Text(code.text)

                    }
                }
            }
        }
        .navigationTitle(.init(tag ?? "code list"))
        .onAppear {
            if let tag = tag {
                $codelist.filter = .init(format: "tagsValue contains %@", tag)
            }
        }
    }
}

#Preview {
    CodeListView(tag: "123")
}
