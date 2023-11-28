//
//  SignInView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @AppStorage("readSigninDesc") var readSigninDesc = false
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
    @State var isAnonymous = AuthManager.shared.auth.currentUser?.isAnonymous == true
    @State var user:FirebaseAuth.User? = nil
    
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
            if isAnonymous {
                error = CustomError.anonymousSignOut
            }
            else {
                signout()
            }
            
        } label: {
            Text("SignOut")
        }
    }
    
    func signout() {
        self.error = AuthManager.shared.signout()
        checkSignin()
    }
    
    var accountInfoView : some View {
        Group {
            VStack(spacing:0) {
                if let user = user {
                    let w:CGFloat = 70
                    TableRowView(header: .init("ID"), sub: .init(user.uid),
                                 headWidth: w)
                    if let dt = user.metadata.creationDate {
                        TableRowView(header: .init("account creation date"), sub: .init(dt.formatted(.dateTime)), headWidth: w)
                    }
                    if let dt = user.metadata.lastSignInDate {
                        TableRowView(header: .init("last sign in date"), sub: .init(dt.formatted(.dateTime)), headWidth: w)

                    }
                    if let email = user.email {
                        TableRowView(
                            header: .init("email"),
                            sub: .init(email), headWidth: w)
                    }
                    if let phone = user.phoneNumber {
                        TableRowView(
                            header: .init("phone"),
                            sub: .init(phone), headWidth: w)

                    }
                        
                }
                
            }
        }
    }
    var body: some View {
        ScrollView {
            if isSignin {
                accountInfoView
                    .padding()
                if isAnonymous {
                    upgradeButtons
                }
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
        }
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
            }
        }
        isAnonymous = AuthManager.shared.auth.currentUser?.isAnonymous == true
        user = AuthManager.shared.auth.currentUser
    }
}

#Preview {
    SignInView()
}
