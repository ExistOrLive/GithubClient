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

func generateAvatarURL(login: String, avatarUrl: String, size: CGFloat) -> String {
    var type = 2
    
    switch type {
    case 0:
        return avatarUrl
    case 1:
        let avatarURLWithLogin = "https://avatars.githubusercontent.com/\(login.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        return avatarURLWithLogin
    case 2:
        var tmpAvatarUrl = avatarUrl
        if let index = tmpAvatarUrl.firstIndex(of: "?") {
            tmpAvatarUrl = String(tmpAvatarUrl[..<index])
        }
        tmpAvatarUrl = tmpAvatarUrl + "?" + "s=\(Int(size))" + "&" + "v=4"
        return tmpAvatarUrl
    default:
        return avatarUrl
    }
}

extension UIImageView {
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60) {
        let url = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        self.sd_setImage(with: URL.init(string: url), placeholderImage: UIImage.init(named: "default_avatar"))
    }
}

extension UIButton {
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60) {
        let url = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        self.sd_setBackgroundImage(with: URL.init(string: url),
                                   for: .normal,
                                   placeholderImage: UIImage.init(named: "default_avatar"))
    }
}
