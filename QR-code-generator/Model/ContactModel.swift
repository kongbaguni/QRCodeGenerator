//
//  ContactModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import Foundation
import SwiftUI

struct ContactModel {
    /** 이름*/
    var fn:String
    /** 회사*/
    var org:String
    /** 전화번호*/
    var tel:String
    /** 이메일*/
    var email:String
    
    var vCardString:String {
        var result = fn.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" :
"""
BEGIN:VCARD
VERSION:3.0\n
"""
        if fn.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            result.append("FN:\(fn.trimmingCharacters(in: .whitespacesAndNewlines))\n")
        }
        if org.trimmingCharacters(in:.whitespacesAndNewlines).isEmpty == false {
            result.append("ORG:\(org.trimmingCharacters(in: .whitespacesAndNewlines))\n")
        }
        if tel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            result.append("TEL:\(tel.trimmingCharacters(in: .whitespacesAndNewlines))\n")
        }
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            result.append("EMAIL:\(email.trimmingCharacters(in: .whitespacesAndNewlines))\n")
        }

        if result.isEmpty == false {
            result.append("END:VCARD")
        }
        return result

    }
    
    static func parseVCard(vCardString: String) -> ContactModel? {
        var contact = ContactModel(fn: "", org: "", tel: "", email: "")
        
        let lines = vCardString.components(separatedBy: .newlines)
        
        for line in lines {
            let components = line.components(separatedBy: ":")
            guard components.count == 2 else { continue }
            
            let key = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let value = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            switch key {
            case "FN":
                contact.fn = value
            case "ORG":
                contact.org = value
            case "TEL":
                contact.tel = value
            case "EMAIL":
                contact.email = value
            default:
                break
            }
        }
        
        return contact
    }
}
