//
//  String+extension.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/2.
//  Copyright © 2019年 ZM. All rights reserved.
//

import Foundation

public extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
