//
//  UIFont+IconFont.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/28.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
 
public extension UIFont {
    
    static func iconFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name:iconFontName, size: size) {
            return font
        }
       
        let fontFileUrl = Bundle.main.url(forResource: iconFontName, withExtension: "ttf")
        
        // icon font file 不存在，则终止执行
        assert(fontFileUrl != nil && FileManager.default.fileExists(atPath: fontFileUrl?.path ?? ""),"icon font file not exist in main bundle")
        
        if let provider = CGDataProvider(url: fontFileUrl! as CFURL),
           let newFont = CGFont(provider) {
            
            CTFontManagerRegisterGraphicsFont(newFont, nil)
            
            if let font = UIFont(name:iconFontName, size: size) {
                return font
            } else {
                assertionFailure("UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
            }
        }
        
        assertionFailure("UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.")
        
        return UIFont.systemFont(ofSize: size)
    }
    
    static var iconFontName: String = "iconfont"
    
    @objc static func zlIconFont(withSize size: CGFloat) -> UIFont {
        return UIFont.iconFont(size: size)
    }
}

