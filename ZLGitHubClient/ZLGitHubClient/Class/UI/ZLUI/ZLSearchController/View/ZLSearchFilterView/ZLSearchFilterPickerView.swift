//
//  ZLSearchFilterPickerView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/18.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSearchFilterPickerView: ZLBaseView {
    
    static func showLanguagePickerView(resultBlock:((String)->Void)?)
    {
        let languageArray = ["Any Language","Action Sheet","C","C++","C#","Clojure","CoffeeScript","CSS","Dart","Go","Haskell","HTML","Java","JavaScript","Lua","MATLAB","Objective-C","Objective-C++","Perl","PHP","Python","R","Ruby","Scala","Shell","Swift","Tex","Vim script"]
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: "请选择语言", withDataArray: languageArray, withResultBlock: {(result:Int32) in
            resultBlock?(languageArray[Int(result)])
        })
    }
    
    static func showRepoOrderPickerView(resultBlock:((String)->Void)?)
    {
        let repoOrderArray = ["Best match","Most stars","Fewst stars","Most forks","Fewest forks","Recently updated","Least recently updated"]
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: "排序规则", withDataArray: repoOrderArray, withResultBlock: {(result:Int32) in
            resultBlock?(repoOrderArray[Int(result)])
        })
    }
    
    static func showUserOrderPickerView(resultBlock:((String)->Void)?)
    {
        let userOrderArray = ["Best match","Most followers","Fewest followers","Most recently joined","Least recently joined","Most repositories","Fewest repositories"]
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: "排序规则", withDataArray: userOrderArray, withResultBlock: {(result:Int32) in
            resultBlock?(userOrderArray[Int(result)])
        })
    }
    
    static func showDatePickerView(resultBlock:((String)->Void)?)
    {
        CYDatePickerView.showCYDatePickerPopover(withTitle: "选择日期", withYearRange: NSRange.init(location: 2008, length: 50), withResultBlock: {(date:Date) in
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd";
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            resultBlock?(dateFormatter.string(from: date))
        })
    }
    
}

