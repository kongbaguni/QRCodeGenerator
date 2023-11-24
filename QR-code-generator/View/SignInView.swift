//
//  SignInView.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 11/24/23.
//

import SwiftUI

struct SignInView: View {
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
    
    var signinButtons : some View {
        Group {
            Button {
                AuthManager.shared.startSignInWithAppleFlow { error in
                    self.error = error
                    checkSignin()
                }
            } label: {
                Text("Signin with Apple")
            }
            Button {
                AuthManager.shared.startSignInWithGoogleId { error in
                    self.error = error
                    checkSignin()
                }
            } label: {
                Text("Signin with Google")
            }
            Button {
                AuthManager.shared.startSignInAnonymously { error in
                    self.error = error
                    checkSignin()
                }
            } label: {
                Text("Signin anonymous")
            }
        }
    }
    
    var upgradeButtons : some View  {
        Group {
            Button {
                AuthManager.shared.upgradeAnonymousWithAppleId { error in
                    self.error = error
                    checkSignin()
                }
            } label: {
                Text("Continue with Apple")
            }
            Button {
                AuthManager.shared.upgradeAnonymousWithGoogleId { error in
                    self.error = error
                    checkSignin()
                }
            } label: {
                Text("Continue with Google")
            }
        }
    }
    
    var signoutButton : some View  {
        Button {
            self.error = AuthManager.shared.signout()
            checkSignin()
        } label: {
            Text("SignOut")
        }
    }
    
    
    var body: some View {
        ScrollView {
            if isSignin {
                Text(AuthManager.shared.userId ?? "?")
                if isAnonymous {
                    upgradeButtons
                }
                signoutButton
            } else {
                signinButtons
            }
        }
        .onAppear {
            checkSignin()
        }
        .alert(isPresented: $isAlert, content: {
            .init(title: .init("alert"), message: .init(error?.localizedDescription ?? ""))
        })
        .navigationTitle(isSignin ? .init("Account") : .init("Signin"))
    }
    
    func checkSignin() {
        isSignin = AuthManager.shared.isSignined
        isAnonymous = AuthManager.shared.auth.currentUser?.isAnonymous == true
    }
}

#Preview {
    SignInView()
}
