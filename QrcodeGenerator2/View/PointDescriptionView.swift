//
//  PointDescriptionView.swift
//  myinbody
//
//  Created by Changyeol Seo on 11/14/23.
//

import SwiftUI

struct PointDescriptionView: View {
    var body: some View {
        List {
            Group {
                Image(systemName: "questionmark.diamond")
                    .resizable()
                    .scaledToFit()
                    .padding(20)
                    .foregroundStyle(.yellow,.orange,.blue)
                Text("Point Description 1")
                Text("Point Description 2")
                Text("Point Description 3")
            }.listRowBackground(Color.themeBackground)
        }
        .listStyle(.plain)
        .background(Color.themeBackground)
        .navigationTitle(Text("Point Description title"))
    }
}

#Preview {
    PointDescriptionView()
}
