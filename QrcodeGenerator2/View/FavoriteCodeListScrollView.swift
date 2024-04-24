//
//  FavoriteCodeListView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/11/23.
//

import SwiftUI
import RealmSwift

struct FavoriteCodeListScrollView: View {
    @ObservedResults (
        CodeModel.self,
        filter: .init(format: "isInfavorites = true"),
        sortDescriptor: .init(
            keyPath: "updateDtTimeIntervalSince1970",
            ascending: false)
        
    ) var codelist

    var body: some View {
        ScrollViewReader{ scroll in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(codelist, id: \.self) { code in
                        NavigationLink {
                            CodeDetailView(code:code)
                        } label: {
                            VStack {
                                code.image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:100)
                                if code.codeType == .bar {
                                    Text(code.text)
                                        .font(.caption)
                                        .foregroundStyle(code.foregroundColor)
                                }
                            }
                            .frame(height:100)
                        }
                        .padding(10)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(code.backgroundColor)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(code.foregroundColor, lineWidth: 2.0)
                        }

                    }
                }
            }
        }
    }
}

#Preview {
    FavoriteCodeListScrollView()
}
