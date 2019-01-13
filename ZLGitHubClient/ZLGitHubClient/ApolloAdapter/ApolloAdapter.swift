//
//  ApolloAdapter.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/1/13.
//  Copyright © 2019年 ZM. All rights reserved.
//

import Foundation
import Apollo


@objcMembers class ApolloAdapter: NSObject
{
    override init() {
        super.init();
    }
    
    public func printA()
    {
        print("dadsadasd");
    }
    
    @objc public func printB(a: Int, b: Int) -> Int
    {
        let c = a + b;
        print(c);
        return c;
    }
    
}
