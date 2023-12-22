//
//  URL+Extensions.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/22/23.
//

import Foundation
extension URL {
    var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else {
            return nil
        }

        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}
