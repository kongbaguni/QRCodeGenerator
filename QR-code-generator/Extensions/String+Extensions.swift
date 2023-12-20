//
//  String+Extensions.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/20/23.
//

import Foundation
extension String {
    var dictionaryValue : [String:Any]? {
        if let jsonData = self.data(using: .utf8) {
            do {
                // JSON 데이터를 [String: Any]로 변환
                if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // 변환된 딕셔너리를 사용
                    print("JSON 딕셔너리: \(jsonDictionary)")
                    return jsonDictionary
                } else {
                    print("JSON 데이터를 [String: Any]로 변환할 수 없습니다.")
                }
            } catch {
                print("JSON 데이터를 변환하는 동안 에러가 발생했습니다: \(error.localizedDescription)")
            }
        } else {
            print("유효한 JSON 데이터가 아닙니다.")
        }        
        return nil
    }
}
