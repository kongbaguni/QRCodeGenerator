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
        checkSignin()
    }
    
    var accountInfoView : some View {
        Group {
            VStack(spacing:0) {
                let w:CGFloat = 70
                if let url = account?.photoURL {
                    AsyncImage(url: url)
                        .padding()
                        .cornerRadius(20)
                        .overlay{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.primary,lineWidth: 2.0)
                        }
                }
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
    var body: some View {
        ScrollView {
            if isSignin {
                accountInfoView
                    .padding()
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
                TagModel.sync { error in
                    self.error = error 
                }
            }
        }

        account = AuthManager.shared.accountModel
        
        
    }
}

#Preview {
    SignInView()
}
