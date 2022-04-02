//
//  ZLPresenterMessageModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/4/1.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

@objc class ZLPresenterMessageModel: NSObject {
    
    var messageType: Int = 0
    
    var result: Bool = false
    
    var data: Any?
    
    var error: String = ""

}
