//
//  GithubAvatar+Extension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2024/2/18.
//  Copyright © 2024 ZM. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import ZLUtilities

func generateAvatarURL(login: String, avatarUrl: String, size: CGFloat) -> (String,Int) {
    
    let type = ZLAGC().configAsInt(for: "GithubAvatarImageLoad")
    
    switch type {
    case 1:
        /// 使用login拼接avatar链接
        let avatarURLWithLogin = "https://avatars.githubusercontent.com/\(login.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        return (avatarURLWithLogin,type)
    case 2:
        /// 原生链接拼接size
        var tmpAvatarUrl = avatarUrl
        if let index = tmpAvatarUrl.firstIndex(of: "?") {
            tmpAvatarUrl = String(tmpAvatarUrl[..<index])
        }
        tmpAvatarUrl = tmpAvatarUrl + "?" + "s=\(Int(size))" + "&" + "v=4"
        return (tmpAvatarUrl,type)
    default:
        return (avatarUrl,type)
    }
}

extension UIImageView {
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60) {
        let startTime = Date().timeIntervalSince1970
        let (urlStr,type) = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        
        self.sd_setImage(with: URL.init(string: urlStr),
                         placeholderImage: UIImage.init(named: "default_avatar")) { image, error, cacheType, url in
            let result = image != nil ? 1 : 0
            let time = Date().timeIntervalSince1970 - startTime
            
            ZLAGC().reportEvent(eventId: "GitHub_Avatar_Download",
                                params: ["p_result":result,
                                         "p_time":time,
                                         "p_type":type,
                                         "p_url": urlStr,
                                         "p_cacheType": cacheType.rawValue,
                                         "p_errorMsg": error?.localizedDescription ?? ""])
        }
    }
}

extension UIButton {
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60) {
        let startTime = Date().timeIntervalSince1970
        let (urlStr,type) = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        self.sd_setBackgroundImage(with: URL.init(string: urlStr),
                                   for: .normal,
                                   placeholderImage: UIImage.init(named: "default_avatar")){ image, error, cacheType, url in
            let result = image != nil ? 1 : 0
            let time = Date().timeIntervalSince1970 - startTime
            
            ZLAGC().reportEvent(eventId: "GitHub_Avatar_Download",
                                params: ["p_result":result,
                                         "p_time":time,
                                         "p_type":type,
                                         "p_url": urlStr,
                                         "p_cacheType": cacheType.rawValue,
                                         "p_errorMsg": error?.localizedDescription ?? ""])
        }
    }
}
