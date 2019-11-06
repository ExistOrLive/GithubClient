//
//  UIColor+extension.swift
//  ZLGitHubClient
//
//  Created by LongMac on 2019/9/3.
//  Copyright © 2019年 ZM. All rights reserved.
//

import Foundation

extension UIColor {
    
    convenience init(_ color: Any) {
        switch color {
            
        case let hex as Int: //16进制整型
            let intr = (hex >> 16) & 0xFF
            let intg = (hex >> 8) & 0xFF
            let intb = (hex) & 0xFF
            self.init(red: CGFloat(intr)/255, green: CGFloat(intg)/255, blue: CGFloat(intb)/255, alpha: 1)
            
        case let hex as String: //字符串
            var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                let index = cString.index(cString.startIndex, offsetBy:1)
                cString = String(cString[index...])
            }
            
            if (cString.count != 6) {
                self.init(red: 1, green: 0, blue: 0, alpha: 1)
            }
            else {
                let rIndex = cString.index(cString.startIndex, offsetBy: 2)
                let rString = String(cString[..<rIndex])
                let otherString = String(cString[rIndex...])
                let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
                let gString = String(otherString[..<gIndex])
                let bIndex = cString.index(cString.endIndex, offsetBy: -2)
                let bString = String(cString[bIndex...])
                
                var intr:UInt32 = 0, intg:UInt32 = 0, intb:UInt32 = 0;
                Scanner(string: rString).scanHexInt32(&intr)
                Scanner(string: gString).scanHexInt32(&intg)
                Scanner(string: bString).scanHexInt32(&intb)
                
                self.init(red: CGFloat(intr)/255.0, green: CGFloat(intg)/255.0, blue: CGFloat(intb)/255.0, alpha: 1)
            }
            
        default:
            self.init(red: 1, green: 0, blue: 0, alpha: 1)
            break
        }
    }
}
