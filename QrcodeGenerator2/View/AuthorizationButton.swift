//
//  SigninButton.swift
//  PixelArtMaker (iOS)
//
//  Created by 서창열 on 2022/04/07.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct AuthorizationButton : View {
    
    enum ProviderType {
        case apple
        case google
        case anonymous
    }
    
    enum TextType {
        case signin
        case upgreade
    }
        
    let provider:ProviderType
    let textType:TextType

    let action:()->Void

    private var headImage:some View {
        switch provider {
        case .anonymous:
            return Image(systemName: "person.fill.questionmark")
                .resizable()
        case .apple:
            return Image("signin_logo_apple")
                .resizable()
        case .google:
            return Image("signin_logo_google")
                .resizable()
        }
    }

    private var text:Text {
        switch provider {
        case .anonymous:
            return .init("Signin anonymous")
        case .apple:
            switch textType {
            case .signin:
                return .init("Signin with Apple")
            case .upgreade:
                return .init("Continue with Apple")
            }
            
            
        case .google:
            switch textType {
            case .signin:
                return .init("Signin with Google")
            case .upgreade:
                return .init("Continue with Google")          
            }
        }
    }
    
    private var backgroundColor:Color {
        switch provider {
        case .apple:
            return .init("signinBtnBackgroundApple")
        case .google:
            return .init("signinBtnBackgroundGoogle")
        case .anonymous:
            return .clear
        }
    }
    
    private var btnLabel : some View {
        Group {
            HStack {
                headImage
                    .foregroundStyle(Color("signinBtnBorder"))
                    .scaledToFit()
                    .frame(width: 40, height: 40, alignment: .leading)
                    .padding(.top, 5)
                    .padding(.leading, 30)
                    .padding(.bottom, 5)
                
                text
                    .foregroundColor(Color("signinBtnBorder"))
                    .font(.headline)
                Spacer()
            }
        }
    }
    
    var body : some View {
        Button {
            action()
        } label : {
            btnLabel
        }
        .background(backgroundColor)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30).stroke(Color("signinBtnBorder"), lineWidth:1)
        )
        .padding(.leading, 10)
        .padding(.trailing, 10)
    }
}

#Preview {
    VStack {
        AuthorizationButton(provider: .apple, textType: .signin) {
            
        }
        AuthorizationButton(provider: .google, textType: .upgreade) {
            
        }
        AuthorizationButton(provider: .anonymous, textType: .signin) {
            
        }
    }
}
