//
//  ZLSearchFilterPickerView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/18.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSearchFilterPickerView: ZLBaseView {
    
    static func showLanguagePickerView(initTitle:String?,resultBlock:((String)->Void)?)
    {
        let languageArray = ["Any Language","Action Sheet","C","C++","C#","Clojure","CoffeeScript","CSS","Dart","Go","Haskell","HTML","Java","JavaScript","Lua","MATLAB","Objective-C","Objective-C++","Perl","PHP","Python","R","Ruby","Scala","Shell","Swift","Tex","Vim script"]
        
        var initIndex = 0;
        if(initTitle != nil)
        {
            let index =  languageArray.firstIndex(of: initTitle!)
            initIndex = index ?? 0;
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: "请选择语言",withInitIndex: UInt(initIndex), withDataArray: languageArray, withResultBlock: {(result:UInt) in
            resultBlock?(languageArray[Int(result)])
        })
    }
    
    static func showRepoOrderPickerView(initTitle:String?, resultBlock:((String)->Void)?)
    {
        let repoOrderArray = ["Best match","Most stars","Fewst stars","Most forks","Fewest forks","Recently updated","Least recently updated"]
        
        var initIndex = 0;
             if(initTitle != nil)
             {
                let index =  repoOrderArray.firstIndex(of: initTitle!)
                 initIndex = index ?? 0;
             }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "OrderSelect", comment: ""),withInitIndex: UInt(initIndex), withDataArray: repoOrderArray, withResultBlock: {(result:UInt) in
            resultBlock?(repoOrderArray[Int(result)])
        })
    }
    
    static func showUserOrderPickerView(initTitle:String?, resultBlock:((String)->Void)?)
    {
        let userOrderArray = ["Best match","Most followers","Fewest followers","Most recently joined","Least recently joined","Most repositories","Fewest repositories"]
        
        var initIndex = 0;
        if(initTitle != nil)
        {
            let index =  userOrderArray.firstIndex(of: initTitle!)
            initIndex = index ?? 0;
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "OrderSelect", comment: ""), withInitIndex: UInt(initIndex), withDataArray: userOrderArray, withResultBlock: {(result:UInt) in
            resultBlock?(userOrderArray[Int(result)])
        })
    }
    
    
    static func showOrgOrderPickerView(initTitle:String?, resultBlock:((String)->Void)?)
    {
        let userOrderArray = ["Best match","Most recently joined","Least recently joined","Most repositories","Fewest repositories"]
        
        var initIndex = 0;
        if(initTitle != nil)
        {
            let index =  userOrderArray.firstIndex(of: initTitle!)
            initIndex = index ?? 0;
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "OrderSelect", comment: ""), withInitIndex: UInt(initIndex), withDataArray: userOrderArray, withResultBlock: {(result:UInt) in
            resultBlock?(userOrderArray[Int(result)])
        })
    }
    
    static func showPROrderPickerView(initTitle:String?, resultBlock:((String)->Void)?)
    {
        let userOrderArray = ["Best match","Newest","Oldest","Most commented","Least commented","Recently updated","Least recently updated"]
        
        var initIndex = 0;
        if(initTitle != nil)
        {
            let index =  userOrderArray.firstIndex(of: initTitle!)
            initIndex = index ?? 0;
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "OrderSelect", comment: ""), withInitIndex: UInt(initIndex), withDataArray: userOrderArray, withResultBlock: {(result:UInt) in
            resultBlock?(userOrderArray[Int(result)])
        })
    }
    
    
    static func showIssueOrderPickerView(initTitle:String?, resultBlock:((String)->Void)?)
    {
        let userOrderArray = ["Best match","Newest","Oldest","Most commented","Least commented","Recently updated","Least recently updated"]
        
        var initIndex = 0;
        if(initTitle != nil)
        {
            let index =  userOrderArray.firstIndex(of: initTitle!)
            initIndex = index ?? 0;
        }
        
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "OrderSelect", comment: ""), withInitIndex: UInt(initIndex), withDataArray: userOrderArray, withResultBlock: {(result:UInt) in
            resultBlock?(userOrderArray[Int(result)])
        })
    }
    
    
//    static func showIssueOrPRStatePickerView(initTitle:String?, resultBlock:((String)->Void)?)
//    {
//        let userOrderArray = ["Open","Closed"]
//
//        var initIndex = 0;
//        if(initTitle != nil)
//        {
//            let index =  userOrderArray.firstIndex(of: initTitle!)
//            initIndex = index ?? 0;
//        }
//
//        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "State", comment: ""), withInitIndex: UInt(initIndex), withDataArray: userOrderArray, withResultBlock: {(result:UInt) in
//            resultBlock?(userOrderArray[Int(result)])
//        })
//    }
    
    
    static func showDatePickerView(resultBlock:((String)->Void)?)
    {
        CYDatePickerView.showCYDatePickerPopover(withTitle: ZLLocalizedString(string: "DateRange", comment: ""), withYearRange: NSRange.init(location: 2008, length: 50), withResultBlock: {(date:Date) in
            
            let dateFormatter = DateFormatter();
            dateFormatter.dateFormat = "yyyy-MM-dd";
            dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
            resultBlock?(dateFormatter.string(from: date))
        })
    }
    
}

