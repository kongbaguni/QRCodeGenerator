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
    }
    
    func checkSignin() {
        isSignin = AuthManager.shared.isSignined
    }
}

#Preview {
    SignInView()
}
