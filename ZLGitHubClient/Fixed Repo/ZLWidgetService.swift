//
//  ZLWidgetService.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import ZLServiceFramework

struct ZLWidgetService {
    static func trendingRepo(dateRange: FixedRepoDateRange, language : FixedRepoLanguage,  completeHandler: @escaping (Bool,[ZLGithubRepositoryModel]) -> Void) {
        
        var languageStr : String?
        switch language{
        case .any,.unknown:
            languageStr = nil
        case .c:
            languageStr = "C";
        case .cPlusPlus:
            languageStr = "C++";
        case .c4:
            languageStr = "C#";
        case .cMake:
            languageStr = "CMake";
        case .cSS:
            languageStr = "CSS";
        case .cSV:
            languageStr = "CSV";
        case .d:
            languageStr = "D";
        case .dart:
            languageStr = "Dart";
        case .dockerfile:
            languageStr = "Dockerfile";
        case .go:
            languageStr = "Go";
        case .gradle:
            languageStr = "Gradle";
        case .graphQL:
            languageStr = "GraphQL";
        case .groovy:
            languageStr = "Groovy";
        case .hTML:
            languageStr = "HTML";
        case .jSON:
            languageStr = "JSON";
        case .java:
            languageStr = "Java";
        case .javaScript:
            languageStr = "JavaScript";
        case .kotlin:
            languageStr = "Kotlin";
        case .mATLAB:
            languageStr = "MATLAB";
        case .markdown:
            languageStr = "Markdown";
        case .metal:
            languageStr = "Metal";
        case .objectiveC:
            languageStr = "Objective-C";
        case .objectiveCPLUSPLUS:
            languageStr = "Objective-C++";
        case .pHP:
            languageStr = "PHP";
        case .pascal:
            languageStr = "Pascal";
        case .perl:
            languageStr = "Perl";
        case .powerShell:
            languageStr = "PowerShell";
        case .python:
            languageStr = "Python";
        case .ruby:
            languageStr = "Ruby";
        case .sQL:
            languageStr = "SQL";
        case .shell:
            languageStr = "Shell";
        case .swift:
            languageStr = "Swift";
        case .vue:
            languageStr = "Vue";
        case .xML:
            languageStr = "XML";
        case .yAML:
            languageStr = "YAML";
        }
        var zldateRange : ZLDateRange = ZLDateRange.init(0)
        switch dateRange {
        case .daily:
            zldateRange = ZLDateRange.init(0)
        case .monthly:
            zldateRange = ZLDateRange.init(1)
        case .weekly:
            zldateRange = ZLDateRange.init(2)
        default:
            zldateRange = ZLDateRange.init(0)
        }
        
        
        ZLServiceManager.sharedInstance.searchServiceModel?.trending(with: .repositories, language: languageStr, dateRange: zldateRange, serialNumber: NSString.generateSerialNumber(), completeHandle: {  (model:ZLOperationResultModel) in
            if model.result == true {
                guard let repoArray : [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel] else {
                    completeHandler(false,[])
                    return
                }
                completeHandler(true,repoArray)
            } else {
                completeHandler(false,[])
            }
        })
        
    }
}
