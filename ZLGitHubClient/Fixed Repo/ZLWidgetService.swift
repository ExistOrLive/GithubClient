//
//  ZLWidgetService.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Kanna

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
            
            guard let htmlDoc = try? HTML(url: url, encoding: .utf8) else {
                DispatchQueue.main.async {
                    completeHandler(false,[])
                }
                return
            }
            
            var repoArray = [ZLSimpleRepositoryModel]()
            
            for article in htmlDoc.xpath("//article") {
                
                let h1 = article.xpath("//h1").first
                let p = article.xpath("//p").first
                let a = h1?.xpath("//a").first
            
                guard var fullName = a?["href"] else { continue }
                fullName = String(fullName.suffix(from: fullName.index(after: fullName.startIndex)))
                var repoModel = ZLSimpleRepositoryModel(fullName: fullName)
                
                let set = NSCharacterSet(charactersIn: " \n") as CharacterSet
                if let desc = p?.content?.trimmingCharacters(in: set){
                    repoModel.desc = desc
                }
                
                for span in article.xpath("//span") {
                    if let itemprop = span["itemprop"],
                       itemprop == "programmingLanguage" {
                        repoModel.language = span.content
                        break
                    }
                }
                
                for svg in article.xpath("//svg") {
                    let ariaLabel = svg["aria-label"]
                    if "star" == ariaLabel,
                       let content = svg.parent?.content {
                        var str =  content.trimmingCharacters(in: set)
                        str = (str as NSString).replacingOccurrences(of: ",", with: "")
                        if let num = Int(str) {
                            repoModel.star = num
                        }
                    }
                    if "fork" == ariaLabel,
                       let content = svg.parent?.content {
                        var str =  content.trimmingCharacters(in: set)
                        str = (str as NSString).replacingOccurrences(of: ",", with: "")
                        if let num = Int(str) {
                            repoModel.fork = num
                        }
                    }
                }
                repoArray.append(repoModel)
                
            }
            print(repoArray)
            
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
            
            for dayData in htmlDoc.xpath("//rect[@class=\"ContributionCalendar-day\"]") {
            
                if let count = dayData["data-count"] {
                    var contributionModel = ZLSimpleContributionModel()
                    contributionModel.contributionsNumber = Int(count) ?? 0
                    contributionModel.contributionsDate = dayData["data-date"] ?? ""
                    contributionModel.contributionsLevel = Int(dayData["data-level"] ?? "") ?? 0
                    contributionArray.append(contributionModel)
                    totalCount += contributionModel.contributionsNumber
                }
            }
            
            print(contributionArray)
            
            var resultArray = contributionArray
            let showCount = resultArray.count % 7 == 0 ? 154 : resultArray.count % 7 + 147
            if resultArray.count > showCount {
                let startIndex = resultArray.count - showCount
                resultArray = Array(resultArray[startIndex...])
            }
            
            DispatchQueue.main.async {
                completeHandler(true,resultArray,showCount)
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
