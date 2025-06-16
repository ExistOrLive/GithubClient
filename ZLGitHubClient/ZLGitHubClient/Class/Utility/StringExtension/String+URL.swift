//
//  String+URL.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/28.
//  Copyright © 2025 ZM. All rights reserved.
//

//
public extension String {
    var urlPathEncoding: String {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
    }

    var urlPathDecoding: String {
        return removingPercentEncoding ?? ""
    }
}
