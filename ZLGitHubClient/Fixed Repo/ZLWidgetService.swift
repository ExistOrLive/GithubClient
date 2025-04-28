//
//  ZLWidgetService.swift
//  Fixed RepoExtension
//
//  Created by 朱猛 on 2020/12/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Kanna
import ObjectMapper
import Alamofire

struct ZLSimpleRepositoryModel{
    let fullName: String
    var desc: String?
    var language: String?
    var star: Int = 0
    var fork: Int = 0
}

class ZLViewersContributionModel: Mappable {
    var login: String = ""
    var name: String = ""
    var contributionsModel: ZLContributionCalendarModel?
    
    init() {}
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
       
        login <- map["login"]
        name <- map["name"]
        contributionsModel <- map["contributionsCollection.contributionCalendar"]
    }
}


class ZLContributionCalendarModel: Mappable {
    var totalContributions: Int = 0
    var weeks: [ZLContributionWeekModel] = []
    
    init() {}
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        totalContributions <- map["totalContributions"]
        weeks <- map["weeks"]
    }
}

class ZLContributionWeekModel: Mappable {
    var firstDay: String = ""
    var contributionDays: [ZLSimpleContributionModel] = []
    
    init() {}
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        firstDay <- map["firstDay"]
        contributionDays <- map["contributionDays"]
    }
}

class ZLSimpleContributionModel: Mappable {
    var contributionsNumber = 0
    var contributionsDate = ""
    var contributionsLevel = 0
    var contributionsWeekDay = 0
    
    init() {}
    
    required init?(map: ObjectMapper.Map) {}
    
    func mapping(map: ObjectMapper.Map) {
        
        let levelTransform = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            // transform value from String? to Int?
            switch(value) {
            case "NONE": return 0
            case "FIRST_QUARTILE": return 1
            case "SECOND_QUARTILE": return 2
            case "THIRD_QUARTILE": return 3
            case "FOURTH_QUARTILE": return 4
            default: return 0
            }
        }, toJSON: { (value: Int?) -> String? in
            // transform value from Int? to String?
            switch(value) {
            case 0: return "NONE"
            case 1: return "FIRST_QUARTILE"
            case 2: return "SECOND_QUARTILE"
            case 3: return "THIRD_QUARTILE"
            case 4: return "FOURTH_QUARTILE"
            default: return "NONE"
            }
        })
        
        contributionsNumber <- map["contributionCount"]
        contributionsDate <- map["date"]
        contributionsLevel <- (map["contributionLevel"],levelTransform)
        contributionsWeekDay <- map["weekday"]
    }
}

struct ZLWidgetService {
    class TrendingConfig: Mappable {
        var path: String = ""
        var property: String = ""
        
        required init() {}
        required init?(map: Map) { }
        
        func mapping(map: Map) {
            path    <- map["path"]
            property  <- map["property"]
        }
        
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
    class TrendingRepoConfig: Mappable {
        var repoArrayPath: String = ""
        var fullName: TrendingConfig = TrendingConfig()
        var desc: TrendingConfig = TrendingConfig()
        var language: TrendingConfig = TrendingConfig()
        var star: TrendingConfig = TrendingConfig()
        var fork: TrendingConfig = TrendingConfig()
        
        required init?(map: ObjectMapper.Map) {}
        
        func mapping(map: ObjectMapper.Map) {
            repoArrayPath <- map["repoArrayPath"]
            fullName <- map["fullName"]
            desc <- map["desc"]
            language <- map["language"]
            star <- map["star"]
            fork <- map["fork"]
        }
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
                             completeHandler: @escaping (Bool,[ZLSimpleRepositoryModel]) -> Void)
    {
        
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
                  let trendConfig = TrendingRepoConfig(JSON: ZLWidgetService.trendingRepoConfig) else {
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
    
    
    static func contributions(completeHandler: @escaping (Bool,ZLViewersContributionModel?,String) -> Void) {
        
        let userDefaults = UserDefaults(suiteName: "group.com.zm.ZLGithubClient")
        let token = userDefaults?.object(forKey: "ZLAccessTokenKey") as? String
        
        guard let token, !token.isEmpty else {
            completeHandler(false,nil,"Not logged in")
            return
        }
        
        
        var query: String = """
query viewerContributions {
        viewer {
          name
          login
          contributionsCollection {
            contributionCalendar{
              totalContributions
              weeks{
                firstDay
                contributionDays{
                  contributionCount
                  contributionLevel
                  date
                  weekday
                }
              }
            }
          }
        }
}
"""
        let headers: [String: String] = ["Authorization": "Bearer \(token)",
                                               "Accept": "*/*",
                                               "content-type":"application/json"]
        let httpHeaders = HTTPHeaders(headers)
        
        let params: [String:Any] = ["query": query]
        
        AF.request("https://api.github.com/graphql",
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding.default,
                   headers: httpHeaders).responseData { (dataResponse : AFDataResponse<Data>) in
            switch dataResponse.result {
            case .success(let value):
                if let jsonObject = try? JSONSerialization.jsonObject(with: value) as? [String: Any],
                   let viewer = (jsonObject["data"] as? [String:Any])?["viewer"] as? [String:Any],
                   let model = ZLViewersContributionModel(JSON: viewer) {
                    completeHandler(true, model,"")
                } else {
                    completeHandler(false, nil,"No data")
                }
            case .failure(let error):
                completeHandler(false, nil,"An unexpected error occurred")
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
