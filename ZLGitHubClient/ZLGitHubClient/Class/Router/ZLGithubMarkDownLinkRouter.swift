//
//  ZLGithubMarkDownLinkRouter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/6/3.
//  Copyright © 2025 ZM. All rights reserved.
//


class ZLGithubMarkDownLinkRouter {
    
    let needDealWithRelativePath: Bool     /// 是否处理相对路径
    
    let needDealWithAboutBlank: Bool       /// 是否处理AboutBlank
    
    let needDealWithCommonURL: Bool        /// 是否处理 邮箱，手机号等链接
    
    let forbidSamePathNavigation: Bool     /// 禁止相同路径跳转
    
    let forbidInvalidNavigation: Bool      /// 禁止无效的跳转
    
    var rootRepoHTMLPath: String = ""      /// 仓库根链接
    
    var markdownHTMLPath: String = ""      /// markdown页面 page
    
    
    init(needDealWithRelativePath: Bool = false ,
         needDealWithAboutBlank: Bool = false,
         needDealWithCommonURL: Bool = false,
         forbidSamePathNavigation: Bool = false,
         forbidInvalidNavigation: Bool = true,
         rootRepoHTMLPath: String = "",
         markdownHTMLPath: String = "") {
        self.needDealWithCommonURL = needDealWithCommonURL
        self.needDealWithRelativePath = needDealWithRelativePath
        self.needDealWithAboutBlank = needDealWithAboutBlank
        self.forbidSamePathNavigation = forbidSamePathNavigation
        self.forbidInvalidNavigation = forbidInvalidNavigation
        self.rootRepoHTMLPath = rootRepoHTMLPath
        self.markdownHTMLPath = markdownHTMLPath
    }
    
    
    /// 处理链接
    func dealWithLink(urlStr: String) -> Bool {
        
    print("dealWithLink \(urlStr)")
        
    
        
        /**
         * 1. 处理AboutBlank
         */
        if isAboutBlackURLStr(urlStr: urlStr) {
            /// 是AboutBlank
            if needDealWithAboutBlank {
                return dealWithAboutBlank(urlStr: urlStr)
            } else {
                return false
            }
        }
        
        /**
         * 2. 处理相同html路径跳转
         */
        if let url = URL(string: urlStr),
           let htmlURL = URL(string: markdownHTMLPath) {
            if forbidSamePathNavigation, url.path == htmlURL.path {
                return true
            }
        }
    
        /**
         * 3. 处理处理 邮箱，手机号等链接
         */
        if needDealWithCommonURL, ZLCommonURLManager.openURL(urlStr: urlStr) {
            return true
        }
        
        /**
         * 4. 处理处理 邮箱，手机号等链接
         */
        var url = URL(string: urlStr)
        if needDealWithRelativePath, url?.host == nil {  // 如果是相对路径，组装baseurl; baseurl为仓库根路径
            url = URL(string: "\(rootRepoHTMLPath)/\(urlStr)")
        }
        
        
        if let realurl = url {
            /// 处理github 链接 或者 webview
            ZLUIRouter.openURL(url: realurl)
            return true
        }
        
        if forbidInvalidNavigation {
            return true
        } else {
            return false 
        }
        
    }
    
    
    func dealWithAboutBlank(urlStr: String) -> Bool {
        var url = urlStr
        if(url.hasPrefix("about:blank%23")) {
            if let range = url.range(of: "about:blank%23") {
                url.removeSubrange(range)
            }
            if let url = URL(string: "\(self.markdownHTMLPath)#\(url)") {
                ZLUIRouter.openURL(url: url)
                return true
            } else {
                return false
            }
        }
        return false
    }
    
    func isAboutBlackURLStr(urlStr: String) -> Bool {
        return urlStr.hasPrefix("about:blank%23")
    }
}
