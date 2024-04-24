//
//  ContentView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/23/23.
//

import SwiftUI

struct ContentView: View {
    @State var navigationPath = NavigationPath()
    var body: some View {
        NavigationView {
            NavigationStack(path: $navigationPath, root: {
                HomeView()
                    
            })
        }
        .navigationViewStyle(.stack)
        .onOpenURL { url in
            handleOpenURL(url)
        }
        
    }
    
    func handleOpenURL(_ url: URL) {
        print(url.scheme ?? "스킴 없다")
        switch url.scheme {
        case "kongqrmake":
            if let params = url.queryParameters {
                guard let text = params["text"],
                      let type = params["type"] else {
                    return
                }
                switch type {
                case "qr":
                    CodeModel.add(codeType: .qr, inputType: .text, text: text, colors: (f: Color.white, b: Color.black), tags: "") { error in
                        if error as? CustomError == CustomError.notEnoughPoint {
                            GoogleAd.shared.showAd { error in
                                handleOpenURL(url)
                            }
                        }
                    }
                case "bar":
                    CodeModel.add(codeType: .bar, inputType: .text, text: text, colors: (f: Color.white, b: Color.black), tags: "") { error in
                        if error as? CustomError == CustomError.notEnoughPoint {
                            GoogleAd.shared.showAd { error in
                                handleOpenURL(url)
                            }
                        }
                    }
                default:
                    break

                }
            }
        default:
            break

        }
    }
}

#Preview {
    ContentView()
}
