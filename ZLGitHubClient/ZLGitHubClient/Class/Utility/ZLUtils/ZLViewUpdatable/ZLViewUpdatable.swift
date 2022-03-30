//
//  ZLViewUpdate.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/30.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation

protocol ViewUpdatable {
    
    associatedtype ViewData
    
    func fillWithData(viewData: ViewData)
}

