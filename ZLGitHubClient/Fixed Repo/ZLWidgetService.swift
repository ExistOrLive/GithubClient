//
//  ZLWidgetService.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Kanna
import HandyJSON

struct ZLSimpleRepositoryModel{
    let fullName: String
    var desc: String?
    var language: String?
    var star: Int = 0
    var fork: Int = 0
}

struct ZLSimpleContributionModel{
    var contributionsNumber = 0
    var contributionsDate = ""
    var contributionsLevel = 0
}

struct ZLWidgetService {
    class TrendingConfig: HandyJSON {
        required init() {}
        var path: String = ""
        var property: String = ""
        
        func getTargetElementStr(element: XMLElement) -> String? {
            guard let targetElement = element.at_xpath(path) else {
                return nil
            }
            var content: String?
            let set = NSCharacterSet(charactersIn: " \n") as CharacterSet
            if property == "content" {
                content = targetElement.content
            } else {
                content = targetElement[property]
            }
            return content?.trimmingCharacters(in: set)
        }
    }
    class TrendingRepoConfig: HandyJSON {
        required init() {}
        var repoArrayPath: String = ""
        var fullName: TrendingConfig = TrendingConfig()
        var desc: TrendingConfig = TrendingConfig()
        var language: TrendingConfig = TrendingConfig()
        var star: TrendingConfig = TrendingConfig()
        var fork: TrendingConfig = TrendingConfig()
    }
    static let trendingRepoConfig: [String:Any] = [
        "repoArrayPath": "//article[@class=\"Box-row\"]",
        "fullName": [
          "path": "/h2[@class=\"h3 lh-condensed\"]/a[@class=\"Link\"]",
          "property": "href"
        ],
        "desc": [
          "path": "/p[@class=\"col-9 color-fg-muted my-1 pr-4\"]",
          "property": "content"
        ],
        "language": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/span[@class=\"d-inline-block ml-0 mr-3\"]/span[@itemprop=\"programmingLanguage\"]",
          "property": "content"
        ],
        "star": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/a[@class=\"Link Link--muted d-inline-block mr-3\"]/svg[@aria-label=\"star\"]/..",
          "property": "content"
        ],
        "fork": [
          "path": "/div[@class=\"f6 color-fg-muted mt-2\"]/a[@class=\"Link Link--muted d-inline-block mr-3\"]/svg[@aria-label=\"fork\"]/..",
          "property": "content"
        ]
    ]
    
    static func trendingRepo(dateRange: FixedRepoDateRange,
                             language : FixedRepoLanguage,
                             completeHandler: @escaping (Bool,[ZLSimpleRepositoryModel]) -> Void) {
        
        var urlStr = "https://github.com/trending"
        
        if let languageStr = language.languageString {
            urlStr += "/\(languageStr)"
        }
        
        if let dateRangeStr = dateRange.rangeString {
            urlStr += dateRangeStr
        }
        
        guard let url = URL(string: urlStr) else {
            completeHandler(false,[])
            return
        }
        
        DispatchQueue.global().async {
            
            guard let htmlDoc = try? HTML(url: url, encoding: .utf8),
                  let trendConfig = TrendingRepoConfig.deserialize(from: ZLWidgetService.trendingRepoConfig) else {
                DispatchQueue.main.async {
                    completeHandler(false,[])
                }
                return
            }
            
            var repoArray = [ZLSimpleRepositoryModel]()
            
            for article in htmlDoc.xpath(trendConfig.repoArrayPath) {
                
                guard var fullName = trendConfig.fullName.getTargetElementStr(element: article) else {
                    continue
                }
                fullName = String(fullName.suffix(from: fullName.index(after: fullName.startIndex)))
                var repoModel = ZLSimpleRepositoryModel(fullName: fullName)
            
                if let desc = trendConfig.desc.getTargetElementStr(element: article) {
                    repoModel.desc = desc
                }
                
                if let language = trendConfig.language.getTargetElementStr(element: article){
                    repoModel.language = language
                }
            
                if var starStr = trendConfig.star.getTargetElementStr(element: article) {
                    starStr = (starStr as NSString).replacingOccurrences(of: ",", with: "")
                    if let num = Int(starStr) {
                        repoModel.star = num
                    }
                }
                
                if var forkStr = trendConfig.fork.getTargetElementStr(element: article) {
                    forkStr = (forkStr as NSString).replacingOccurrences(of: ",", with: "")
                    if let num = Int(forkStr) {
                        repoModel.fork = num
                    }
                }
               
                repoArray.append(repoModel)
            }
            
            DispatchQueue.main.async {
                completeHandler(true,repoArray)
            }
        }
        
    }
    
    
    static func contributions(loginName : String,
                              completeHandler: @escaping (Bool,[ZLSimpleContributionModel],Int) -> Void) {
        
        guard let loginNamePath = loginName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed),
              let url = URL(string: "https://github.com/users/\(loginNamePath)/contributions") else {
            completeHandler(false,[],0)
            return
        }
        
        DispatchQueue.global().async {
            
            guard let htmlDoc = try? HTML(url: url, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completeHandler(false,[],0)
                }
                return
            }
            
            var contributionArray = [ZLSimpleContributionModel]()
            var totalCount = 0
            
            for dayData in htmlDoc.xpath("//td[@class=\"ContributionCalendar-day\"]") {
                var contributionModel = ZLSimpleContributionModel()
                contributionModel.contributionsDate = dayData["data-date"] ?? ""
                contributionModel.contributionsLevel = Int(dayData["data-level"] ?? "") ?? 0
                contributionArray.append(contributionModel)
                totalCount += contributionModel.contributionsNumber
            }
    
            var resultArray = contributionArray
            let showCount = resultArray.count % 7 == 0 ? 154 : resultArray.count % 7 + 147
            if resultArray.count > showCount {
                let startIndex = resultArray.count - showCount
                resultArray = Array(resultArray[startIndex...])
            }
            
            DispatchQueue.main.async {
                completeHandler(true,resultArray,totalCount)
            }
           
        }
        
    }
}


extension FixedRepoLanguage {
    
    var languageString : String? {
        
        var languageStr: String? = nil
        switch self{
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
        
        return languageStr
    }
    
}


extension FixedRepoDateRange {

    var rangeString: String? {
        var dateRangeStr: String?
        switch self {
        case .daily:
            dateRangeStr = "?since=daily"
        case .weekly:
            dateRangeStr = "?since=weekly"
        case .monthly:
            dateRangeStr = "?since=monthly"
        case .unknown:
            break
        }
        return dateRangeStr
    }
   
    
}
