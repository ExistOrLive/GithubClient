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
    
    let type = ZLRCM().configAsInt(for: "GithubAvatarImageLoad")
    
    switch type {
    case 1:
        let scale = Int(UIScreen.main.scale)
        /// 使用login拼接avatar链接
        let avatarURLWithLogin = "https://avatars.githubusercontent.com/\(login.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"+"?s=\(60 * scale)"
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
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60, forceFromRemote: Bool = false, remoteCallBack: ((UIImage?) -> Void)? = nil) {
        let startTime = Date().timeIntervalSince1970
        let (urlStr,type) = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        
        self.sd_setImage(with: URL.init(string: urlStr),
                         placeholderImage: UIImage.init(named: "default_avatar"),
                         options: forceFromRemote ? [.refreshCached] : [] ) { image, error, cacheType, url in
            let result = image != nil
            let time = Date().timeIntervalSince1970 - startTime
            
            if forceFromRemote && cacheType == .none { /// 非缓存
                remoteCallBack?(image)
            }
            
            analytics.log(.githubAvatarDownload(result: result,
                                                duration: time,
                                                type: type,
                                                url: urlStr,
                                                cacheType: cacheType.rawValue,
                                                errorMsg: error?.localizedDescription ?? ""))
        }
    }
}

extension UIButton {
    
    func loadAvatar(login: String, avatarUrl: String, size: CGFloat = 60, forceFromRemote: Bool = false,remoteCallBack: ((UIImage?) -> Void)? = nil) {
        let startTime = Date().timeIntervalSince1970
        let (urlStr,type) = generateAvatarURL(login: login, avatarUrl: avatarUrl, size: size * UIScreen.main.scale)
        self.sd_setBackgroundImage(with: URL.init(string: urlStr),
                                   for: .normal,
                                   placeholderImage: UIImage.init(named: "default_avatar"),
                                   options: forceFromRemote ? [.refreshCached] : [] ){ image, error, cacheType, url in
            let result = image != nil
            let time = Date().timeIntervalSince1970 - startTime
            
            if forceFromRemote && cacheType == .none { /// 非缓存
                remoteCallBack?(image)
            }
            
            
            analytics.log(.githubAvatarDownload(result: result,
                                                duration: time,
                                                type: type,
                                                url: urlStr,
                                                cacheType: cacheType.rawValue,
                                                errorMsg: error?.localizedDescription ?? ""))
        }
    }
}


extension UIImage {
    
    static func image(with attributedString: NSAttributedString, size: CGSize) -> UIImage {
        let render =  UIGraphicsImageRenderer(size: size)
        return  render.image { context in
            
            let textSize = attributedString.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                                      height: CGFloat.greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         context: nil).size
            attributedString.draw(in: CGRect(x:(size.width - textSize.width)/2.0,
                                             y: (size.height - textSize.height)/2.0,
                                             width: textSize.width,
                                             height: textSize.height))
        }
    }

}
