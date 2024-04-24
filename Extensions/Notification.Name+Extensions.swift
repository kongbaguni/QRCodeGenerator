//
//  Notification.Name+Extensions.swift
//  QrcodeGenerator2
//
//  Created by Changyeol Seo on 4/24/24.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let themeSettingChanged = Notification.Name("themeSettingChanged_observer")
    static let googleAdNativeAdClick = Notification.Name("googleAdNativeAdClick_observer")
    static let googleAdPlayVideo = Notification.Name("googleAdPlayVideo_observer")
    static let authDidSucessed = Notification.Name("authDidSucessed_observer")
    static let signoutDidSucessed = Notification.Name("signoutDidSucessed_observer")
    static let textfieldSetFocus = Notification.Name("textfieldSetFocus_observer")
    static let pointDidChanged = Notification.Name("pointDidChanged_observer")
}
