//
//  CustomError.swift
//  myinbody
//
//  Created by Changyeol Seo on 10/16/23.
//

import Foundation
enum CustomError : Error {
    /** 익명 계정에서 로그아웃 */
    case anonymousSignOut
    /** 계정 탈퇴를 위한 인증에서 다른 아이디로 로그인함*/
    case wrongAccountSigninWhenLeave
    /** 포인트가 부족하다*/
    case notEnoughPoint
    /** 이미 등록된 태그*/
    case tagsAlreadyRegistered
    /** 코드 삭제하기 확인창 띄우기 */
    case deleteCodeConfirm
    
    /** 광고를 보고 포인트를 얻으세요 프롬프트 띄우기*/
    case watchAddAndEarnPointPrompt
}

extension CustomError {
    public var description : String {
        switch self {
        case .anonymousSignOut:
            return "anomymouse sign out"
        case .notEnoughPoint:
            return "Not enough Point"
        case .wrongAccountSigninWhenLeave:
            return "wrong account signin when leave"
        case .tagsAlreadyRegistered:
            return "Tags already registered"
        case .deleteCodeConfirm:
            return "delete code confirm"
        case .watchAddAndEarnPointPrompt:
            return "watchAddAndEarnPointPrompt"
        }
    }
}

extension CustomError : LocalizedError {
    public var errorDescription:String? {
        switch self {
        case .notEnoughPoint:
            return NSLocalizedString("Not enough Point", comment: "Not enough Point")
        case .wrongAccountSigninWhenLeave:
            return NSLocalizedString("wrongAccountSigninWhenLeave msg", comment: "wrong acount sign in")
        case .anonymousSignOut:
            return NSLocalizedString("anomymouse sign out", comment: "signout")
        case .tagsAlreadyRegistered:
            return NSLocalizedString("Tags already registered", comment: "tag")
        case .deleteCodeConfirm:
            return NSLocalizedString("delete code confirm message", comment: "delete tag")
        case .watchAddAndEarnPointPrompt:
            return NSLocalizedString("watchAddAndEarnPointPrompt", comment: "watch ad")
        }
    }
}
