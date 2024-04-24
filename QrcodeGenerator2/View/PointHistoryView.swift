//
//  PointHistoryView.swift
//  myinbody
//
//  Created by Changyeol Seo on 11/8/23.
//

import SwiftUI
import RealmSwift

struct PointHistoryView: View {
    @ObservedResults(PointModel.self,sortDescriptor: .init(keyPath: "regTimeIntervalSince1970", ascending: false)) var points
        
    @State var pointSum:Int = PointModel.sum
    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    
    
    var body: some View {
        List {
            Group {
                HStack {
                    Text("Current Point :")
                        .foregroundStyle(.secondary)
                    Text("\(pointSum)")
                        .bold()
                        .foregroundStyle(ThemeManager.shared.primary)
                    
                }
                
                NavigationLink {
                    PointDescriptionView()
                } label: {
                    Text("Point Description title")
                }
                
                Section {
                    ForEach(points, id:\.self) { point in
                        HStack {
                            Text("\(point.value > 0 ? "+" : "")\(point.value)")
                                .bold()
                                .foregroundStyle(point.value < 0 ? .red : ThemeManager.shared.primary)
                            Text(point.regDt.simpleString)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(point.localizedDesc)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Button {
                    self.error = CustomError.watchAddAndEarnPointPrompt
                } label: {
                    ImageTextView(image: .init(systemName: "play.tv"), text: .init("watch ad"))
                }
                if points.count > 1 {
                    Section {
                        NavigationLink {
                            PointHistoryCombineView()
                        } label: {
                            Text("combin point history")
                        }
                    }
                }
            }
            .listRowBackground(Color.themeBackground)
        }
        .listStyle(.plain)
        .background(Color.themeBackground)
        .refreshable {
            sync()
        }
        .alert(isPresented: $isAlert) {
            switch error as? CustomError {
            case .watchAddAndEarnPointPrompt:
                return .init(
                    title: .init(error!.localizedDescription),
                    primaryButton: .default(.init("confirm"), action: {
                        GoogleAd.shared.showAd { error in
                            self.error = error
                        }
                    }), secondaryButton: .cancel())
            default:
                return .init(title: .init("alert"), message: .init(error?.localizedDescription ?? ""))

            }
        }
        .navigationTitle(.init("points history"))
        .onAppear {
            sync()
        }
        .onReceive(NotificationCenter.default.publisher(for: .pointDidChanged), perform: { noti in
            pointSum = noti.object as? Int ?? PointModel.sum
        })
    }
    
    func sync() {
        PointModel.sync { error in
            self.error = error
        }
    }
}

#Preview {
    PointHistoryView()
}
