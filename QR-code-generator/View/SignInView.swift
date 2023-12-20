//
//  SignInView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import FirebaseAuth
import CachedAsyncImage
struct SignInView: View {
    @AppStorage("readSigninDesc") var readSigninDesc = false
    @AppStorage("selectThemeId") var selectThemeId:String = ""

    @State var readCheck = false
    
    @State var error:Error? = nil {
        didSet {
            if error != nil {
                isAlert = true
            }
        }
    }
    @State var isAlert:Bool = false
    @State var isSignin = AuthManager.shared.isSignined
    @State var account:AccountModel? = nil
    
    var signinButtons : some View {
        Group {
            AuthorizationButton(provider: .apple, textType: .signin) {
                AuthManager.shared.startSignInWithAppleFlow { error in
                    self.error = error
                    checkSignin()
                }
            }
            AuthorizationButton(provider: .google, textType: .signin) {
                AuthManager.shared.startSignInWithGoogleId { error in
                    self.error = error
                    checkSignin()
                }
            }

            AuthorizationButton(provider: .anonymous, textType: .signin) {
                AuthManager.shared.startSignInAnonymously { error in
                    self.error = error
                    checkSignin()
                }
            }
        }
    }
    
    var upgradeButtons : some View  {
        Group {
            AuthorizationButton(provider: .apple, textType: .upgreade) {
                AuthManager.shared.upgradeAnonymousWithAppleId { error in
                    self.error = error
                    checkSignin()
                }
            }
            AuthorizationButton(provider: .google, textType: .upgreade) {
                AuthManager.shared.upgradeAnonymousWithGoogleId { error in
                    self.error = error
                    checkSignin()
                }
            }
        }
    }
    
    var signoutButton : some View  {
        Button {
            if account?.isAnonymous == true {
                error = CustomError.anonymousSignOut
            }
            else {
                signout()
            }
            
        } label: {
            
            RoundedTextView(text: Text("SignOut"), image: .init(systemName:"rectangle.portrait.and.arrow.forward"), style: .normal)
                .padding(.horizontal,10)
        }
    }
    
    var pointView : some View {
        NavigationLink {
            PointHistoryView()
        } label: {
            RoundedTextView(text: .init("Point"), image: .init(systemName: "p.circle"), style: .weak)
        }
    }
    
    var themeListView : some View {
        NavigationLink {
            ThemeListView()                
        } label: {
            RoundedTextView(text: .init("theme list"), image: .init(systemName: "paintbrush.fill"), style: .weak)
        }
    }
    
    var deleteAccount : some View {
        Group {
            if let account = account ?? AuthManager.shared.accountModel {
                if account.isAnonymous == false {
                    NavigationLink {
                        DeleteAccountConfirmView(accountModel: account)
                    } label: {
                        RoundedTextView(text: .init("delete account"), image: .init(systemName: "arrow.up.trash"), style: .cancel)
                            .padding(.horizontal,10)
                    }
                }
            }
        }
    }
    
    func signout() {
        self.error = AuthManager.shared.signout()
        NotificationCenter.default.post(name: .themeSettingChanged, object: nil)
        checkSignin()
    }
    var appVersion : some View {
        Group {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                HStack {
                    Text("App Version :")
                        .foregroundStyle(.secondary)
                    Text(appVersion)
                        .foregroundStyle(.primary)
                    
                }.padding(20)
            }
        }
    }
    var profileImage: some View {
        Group {
            if let url = account?.photoURL {
                CachedAsyncImage(url: url)
                    .cornerRadius(20)
                    .overlay{
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.primary,lineWidth: 2.0)
                    }
                    .padding(10)
            }
        }
    }
    
    var accountInfoView : some View {
        Group {
            HStack {
                VStack {
                    profileImage
                    Spacer()
                }
                VStack(spacing:0) {
                    let w:CGFloat = 150
                    if let userId = account?.userId {
                        TableRowView(header: .init("ID"), sub: .init(userId),
                                     headWidth: w)
                    }
                    if let dt = account?.accountRegDt {
                        TableRowView(header: .init("account creation date"), sub: .init(dt.formatted(.dateTime)), headWidth: w)
                    }
                    if let dt = account?.accountLastSigninDt {
                        TableRowView(header: .init("last sign in date"), sub: .init(dt.formatted(.dateTime)), headWidth: w)
                        
                    }
                    if let email = account?.email {
                        TableRowView(
                            header: .init("email"),
                            sub: .init(email), headWidth: w)
                    }
                    if let phone = account?.phoneNumber {
                        TableRowView(
                            header: .init("phone"),
                            sub: .init(phone), headWidth: w)
                        
                    }
                    
                    
                }
            }
        }
    }
    
    var navigationMenu : some View {
        Group {
            pointView
            if let url = Bundle.main.url(forResource: "HTML/openSourceLicense", withExtension: "html") {
                NavigationLink {
                    WebView(url: url, title: .init("OpenSorce License"))
                } label: {
                    RoundedTextView(text: .init("OpenSorce License"), image: .init(systemName: "info.square"), style: .weak)
                        
                }
            }
            themeListView
                .padding(.bottom,10)
            
        }.padding(.horizontal,10)
    }
    var body: some View {
        ScrollView {
            if isSignin {
                accountInfoView
                    .padding()
                navigationMenu

                if account?.isAnonymous == true {
                    upgradeButtons
                }
                deleteAccount
                signoutButton
            } else {
                if readSigninDesc == false {
                    Text("Signin desc")
                        .padding(.leading,20)
                        .padding(.trailing,20)
                        .padding(.top,20)
                    CheckboxView(isOn: $readCheck, label: .init("Don't see this message again"))
                        .padding(.bottom,20)
                }
                signinButtons
            }
            appVersion
        }
        .background(Color.themeBackground)
        .onAppear {
            checkSignin()
        }
        .onDisappear {
            if readCheck {
                readSigninDesc = readCheck
            }
        }
        .alert(isPresented: $isAlert, content: {
            switch error as? CustomError {
            case .anonymousSignOut:
                return .init(
                    title: .init("alert"),
                    message: .init(error?.localizedDescription ?? ""),
                    primaryButton: .cancel(),
                    secondaryButton: .default(.init("SignOut"), action: {
                       signout()
                    })
                )
            default:
                return .init(title: .init("alert"), message: .init(error?.localizedDescription ?? ""))
            }
            
        })
        .navigationTitle(isSignin ? .init("Account") : .init("Signin"))
    }
    
    func checkSignin() {
        isSignin = AuthManager.shared.isSignined
        if isSignin {
            PointModel.initPoint { error in
                self.error = error
                TagModel.sync { error in
                    self.error = error 
                }
            }
            reloadTheme()
        }

        account = AuthManager.shared.accountModel
    }
    
    func reloadTheme() {
        ThemeModel.sync { error in
            if error != nil {
                self.error = error
            }
            else {
                ThemeModel.getThemeId { error, id in
                    if let id = id {
                        selectThemeId = id
                        ThemeManager.shared.selectThemeId = id
                        NotificationCenter.default.post(name: .themeSettingChanged, object: id)
                    }
                    self.error = error
                }
            }

        }
    }
}

#Preview {
    SignInView()
}
