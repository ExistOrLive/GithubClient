//
//  ZLUIRouter+GIthub.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/27.
//  Copyright © 2025 ZM. All rights reserved.
//

import SYDCentralPivot

enum ZLGithubPathType {
    case user(login: String)
    case repo(login: String, repoName: String)
    case pull(login: String, repoName: String,number: Int)
    case issue(login: String, repoName: String,number: Int)
    case discussion(login: String, repoName: String,number: Int)
    case release(login: String, repoName: String, tagName: String)
    case commit(login: String, repoName: String, ref: String)
    case compare(login: String, repoName: String, baseRef: String, headRef: String)
    case tree(login: String, repoName: String, ref: String, path: String)
    case blob(login: String, repoName: String, ref: String, path: String)
    
    func routerParams() -> (SYDCentralRouterModelType, ZLRouterKey, [String:Any]) {
        switch self {
            
        case .user(let login):
            return (.uiViewController,
                    .UserOrOrgInfoController,
                    ["loginName": login])
            
        case .repo(let login, let repoName):
            return (.uiViewController,
                    .RepoInfoController,
                    ["fullName": "\(login)/\(repoName)"])
            
        case .pull(let login, let repoName,let number):
            return (.uiViewController,
                    .PRInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "number": number])
            
        case .issue(let login, let repoName, let number):
            return (.uiViewController,
                    .IssueInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "number": number])
            
        case .discussion(let login,let repoName,let number):
            return (.uiViewController,
                    .DiscussionInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "number": number])
        
        case .release(let login, let repoName, let tagName):
            return (.uiViewController,
                    .ReleaseInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "tagName": tagName])
        
        case .commit(let login,let repoName,let ref):
            return (.uiViewController,
                    .CommitInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "ref": ref])
        
        case .compare(let login,let repoName,let baseRef,let headRef):
            return (.uiViewController,
                    .CompareInfoController,
                    ["login": login,
                     "repoName": repoName,
                     "baseRef": baseRef,
                     "headRef": headRef])
            
        case .tree(let login, let repoName,let ref, let path):
            return (.uiViewController,
                    .RepoContentController,
                    ["repoFullName": "\(login)/\(repoName)",
                     "branch": ref,
                     "path": path])
            
        case .blob(let login, let repoName, let ref, let path):
            return (.uiViewController,
                    .RepoCodePreview3Controller,
                    ["repoFullName": "\(login)/\(repoName)",
                     "branch": ref,
                     "path": path])
        }
    }
    
}

typealias ZLGithubKeyWord = String
extension ZLGithubKeyWord {
    static let pull: ZLGithubKeyWord = "pull"
    static let issues: ZLGithubKeyWord = "issues"
    static let discussions: ZLGithubKeyWord = "discussions"
    static let releases: ZLGithubKeyWord = "releases"
    static let commit: ZLGithubKeyWord = "commit"
    static let compare: ZLGithubKeyWord = "compare"
    static let tree: ZLGithubKeyWord = "tree"
    static let blob: ZLGithubKeyWord = "blob"
}


extension ZLUIRouter {
    
    static let GithubLoginIgnoreKeyWords = [
        "issues",
        "pulls",
        "marketplace",
        "explore",
        "topics",
        "trending",
        "collections",
        "events",
        "sponsors",
        "settings",
        "account",
        "home",
        "notifications",
        "new",
        "copilot",
        "project",
        "codespaces",
        "discussions"
    ]
    
    static func parseGithubURL(url: URL) -> ZLGithubPathType? {
        
        guard let host = url.host,
              ["github.com","www.github.com"].contains(host) else {
            return nil
        }
        
        let pathComponents = url.pathComponents   /// pathComponents ["/", "login","repoName"]
        
        let pathCount = pathComponents.count
        
        guard pathCount >= 2,
              !Self.GithubLoginIgnoreKeyWords.contains(pathComponents[1]) else {
            return nil
        }
        
        var pathType: ZLGithubPathType?
        
        if pathCount == 2 {
            /// https://github.com/ExistOrLive
            pathType = .user(login: pathComponents[1])
        } else if pathCount == 3 {
            /// https://github.com/ExistOrLive/GithubClient
            pathType = .repo(login: pathComponents[1], repoName: pathComponents[2])
        } else {
            let keyWord = pathComponents[3] as ZLGithubKeyWord
            
            switch(keyWord) {
            case .pull:
                // https://www.github.com/MengAndJie/GithubClient/pull/63
                if pathCount >= 5, let number = Int(pathComponents[4]) {
                    pathType = .pull(login: pathComponents[1],
                                     repoName: pathComponents[2],
                                     number: number)
                }
            case .issues:
                // https://www.github.com/MengAndJie/GithubClient/issues/70
                if pathCount >= 5, let number = Int(pathComponents[4]) {
                    pathType = .issue(login: pathComponents[1],
                                      repoName: pathComponents[2],
                                      number: number)
                }
            case .discussions:
                // https://www.github.com/MengAndJie/GithubClient/discussions/19
                if pathCount >= 5, let number = Int(pathComponents[4]) {
                    pathType = .discussion(login: pathComponents[1],
                                           repoName: pathComponents[2],
                                           number: number)
                }
            case .releases:
                // https://github.com/MengAndJie/GithubClient/releases/tag/1.6.0
                if pathCount >= 6,
                   "tag" == pathComponents[4] {
                    pathType = .release(login: pathComponents[1],
                                        repoName: pathComponents[2],
                                        tagName: pathComponents[5])
                }
            case .commit:
                // https://github.com/ExistOrLive/ZLGitRemoteService/commit/bf6ff8e5da6a8108360c0002811085751471b6a7
                if pathCount >= 5 {
                    pathType = .commit(login: pathComponents[1],
                                       repoName: pathComponents[2],
                                       ref: pathComponents[4])
                }
            case .compare:
                // https://github.com/ExistOrLive/ZLGitRemoteService/compare/1.1.1...%E6%B5%8B%E8%AF%95
                if pathCount >= 5 {
                    let refStr = pathComponents[4].replacingOccurrences(of: "...", with: "/")
                    let refs = refStr.split(separator: "/")
                    if refs.count == 2 {
                        pathType = .compare(login: pathComponents[1],
                                            repoName: pathComponents[2],
                                            baseRef: String(refs[0]),
                                            headRef: String(refs[1]))
                    }
                }
            case .tree:
                // https://github.com/ExistOrLive/GithubClient/tree/master/Document
                if pathCount >= 5 {
                    let ref = pathComponents[4]
                    let paths = Array(pathComponents[5...])
                    pathType = .tree(login: pathComponents[1],
                                     repoName: pathComponents[2],
                                     ref: pathComponents[4],
                                     path: paths.joined(separator: "/"))
                }
                
            case .blob:
                // https://github.com/ExistOrLive/GithubClient/blob/master/Document/GithubAction/DailyCI%E8%AF%B4%E6%98%8E.md
                if pathCount >= 5 {
                    let ref = pathComponents[4]
                    let paths = Array(pathComponents[5...])
                    pathType = .blob(login: pathComponents[1],
                                     repoName: pathComponents[2],
                                     ref: pathComponents[4],
                                     path: paths.joined(separator: "/"))
                }
                
            default:
                break
            }
        }
        return pathType
    }
    
}
