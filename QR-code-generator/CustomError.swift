//
//  CustomError.swift
//  myinbody
//
//  Created by Changyeol Seo on 10/16/23.
//

import Foundation
enum CustomError : Error {
    /** 계정 탈퇴를 위한 인증에서 다른 아이디로 로그인함*/
    case wrongAccountSigninWhenLeave
    /** 포인트가 부족하다*/
    case notEnoughPoint
}

extension CustomError {
    public var description : String {
        switch self {
        case .notEnoughPoint:
            return "Not enough Point"
        case .wrongAccountSigninWhenLeave:
            return "wrong account signin when leave"
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
        }
    }
}
