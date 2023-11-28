//
//  CodeDetailView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/27/23.
//

import SwiftUI
import RealmSwift
import ActivityView

struct CodeDetailView: View {
    @ObservedRealmObject var code:CodeModel
    @State var activityItem:ActivityItem? = nil
    var body: some View {
        ScrollView {
            code.image
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(20)
                .background(code.backgroundColor)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.teal, lineWidth: 5.0)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.primary, lineWidth: 2.0)
                }
                .padding()
            Text(code.outputString)

            VStack {
                TableRowView(
                    header: .init("id"),
                    sub: .init(code.id),
                    headWidth: 100)
                
                TableRowView(header: .init("tags"),
                             sub: .init(code.tagsValue),
                             headWidth: 100)
                
                TableRowView(header: .init("regDt"), sub: .init(code.regDt.formatted(date: .complete, time: .standard)), headWidth: 100)
                
                if code.regDtTimeIntervalSince1970 != code.updateDtTimeIntervalSince1970 {
                    TableRowView(
                        header: .init("updateDt"),
                        sub: .init(code.updateDt.formatted(date: .complete, time: .standard)), headWidth: 100)
                }
            }.padding()
            
            
            
        }
        .navigationTitle(code.outputString)
        .toolbar {
            Button {
                if let image = code.uiimage {
                    if let data = image.pngData() {
                        activityItem = .init(itemsArray: [data])
                    }
                }
            } label : {
                Image(systemName: "square.and.arrow.up")
            }
        }
        .activitySheet($activityItem)
    }
}

#Preview {
    NavigationView {
        NavigationStack {
            let data:[String:AnyHashable] = [
                "id":"123asdjkl",
                "text":"text",
                "tagsValue":"ㅋㅋㅋ,바보",
                "codeTypeValue":1,
                "inputTypeValue":1,
                "foregroundColorRed":1,
                "foregroundColorGreen":1,
                "foregroundColorBlue":1,
                "foregroundColorAlpha":1,
                "backgroundColorRed":0.5,
                "backgroundColorGreen":0.3,
                "backgroundColorBlue":0.9,
                "backgroundColorAlpha":1.0,
            ]
            CodeDetailView(code: .init(value: data))
        }
    }
}
