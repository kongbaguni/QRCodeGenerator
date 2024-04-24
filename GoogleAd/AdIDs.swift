//
//  AdIDs.swift
//  myinbody
//
//  Created by Changyeol Seo on 11/8/23.
//

import Foundation

struct AdIDs {
    #if DEBUG
    static let nativeAd = "ca-app-pub-3940256099942544/3986624511"
    static let rewardAd = "ca-app-pub-3940256099942544/6978759866"
    #else
    static let nativeAd = "ca-app-pub-7714069006629518/8862481197"
    static let rewardAd = "ca-app-pub-7714069006629518/9451269019"
    #endif
}
