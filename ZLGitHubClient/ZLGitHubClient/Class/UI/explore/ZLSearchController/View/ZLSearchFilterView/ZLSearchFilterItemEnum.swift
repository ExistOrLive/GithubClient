//
//  ZLSearchFilterItemEnum.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/2/26.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation
import ZLGitRemoteService


// MARK: Order Item
/// 用户排序
enum ZLSearchUserOrderItem: String, CaseIterable {
    
    case Best_macth = "Best macth"
    case Most_followers = "Most followers"
    case Fewest_followers = "Fewest followers"
    case Most_recently_joined = "Most recently joined"
    case Least_recently_joined = "Least recently joined"
    case Most_repositories = "Most repositories"
    case Fewest_repositories = "Fewest repositories"
    
    var isAsc: Bool {
        switch self {
        case .Most_followers,.Most_recently_joined,.Most_repositories:
            return false
        case .Fewest_followers,.Least_recently_joined,.Fewest_repositories:
            return true
        default:
            return false
        }
    }
    
    var order: String? {
        switch self {
        case .Most_followers,.Fewest_followers:
            return "followers"
        case .Most_repositories,.Fewest_repositories:
            return "repositories"
        case .Most_recently_joined,.Least_recently_joined:
            return "joined"
        default:
            return nil
        }
    }
}

// repo 排序
enum ZLSearchRepoOrderItem: String, CaseIterable {
    
    case Best_macth = "Best macth"
    case Most_stars = "Most stars"
    case Fewest_stars = "Fewest stars"
    case Most_forks = "Most forks"
    case Fewest_forks = "Fewest forks"
    case Recently_updated = "Recently updated"
    case Least_recently_updated = "Least recently updated"
    
    var isAsc: Bool {
        switch self {
        case .Most_stars,.Most_forks,.Recently_updated:
            return false
        case .Fewest_stars,.Fewest_forks,.Least_recently_updated:
            return true
        default:
            return false
        }
    }
    
    var order: String? {
        switch self {
        case .Most_stars,.Fewest_stars:
            return "stars"
        case .Most_forks,.Fewest_forks:
            return "forks"
        case .Recently_updated,.Least_recently_updated:
            return "updated"
        default:
            return nil
        }
    }
}

// org 排序
enum ZLSearchOrgOrderItem: String, CaseIterable {
    
    case Best_macth = "Best macth"
    case Most_recently_joined = "Most recently joined"
    case Least_recently_joined = "Least recently joined"
    case Most_repositories = "Most repositories"
    case Fewest_repositories = "Fewest repositories"
    
    var isAsc: Bool {
        switch self {
        case .Most_recently_joined,.Most_repositories:
            return false
        case .Least_recently_joined,.Fewest_repositories:
            return true
        default:
            return false
        }
    }
    
    var order: String? {
        switch self {
        case .Most_repositories,.Fewest_repositories:
            return "repositories"
        case .Most_recently_joined,.Least_recently_joined:
            return "joined"
        default:
            return nil
        }
    }
}

// IssueOrPR 排序
enum ZLSearchIssueOrPROrderItem: String, CaseIterable {
    
    case Best_macth = "Best macth"
    case Newest = "Newest"
    case Oldest = "Oldest"
    case Most_commented = "Most commented"
    case Least_commented = "Least commented"
    case Recently_updated = "Recently updated"
    case Least_recently_updated = "Least recently updated"
    
    var isAsc: Bool {
        switch self {
        case .Newest,.Most_commented,.Recently_updated:
            return false
        case .Oldest,.Least_commented,.Least_recently_updated:
            return true
        default:
            return false
        }
    }
    
    var order: String? {
        switch self {
        case .Newest,.Oldest :
            return "created"
        case .Most_commented,.Least_commented:
            return "comments"
        case .Recently_updated,.Least_recently_updated:
            return "updated"
        default:
            return nil
        }
    }
}


// MARK: Filter Section
extension ZLSearchType {
    var filterSections: [ZLSearchFilterSectionProtocol] {
        switch self {
        case .repositories:
            return ZLSearchRepoFilterSectionType.allCases
        case .users:
            return ZLSearchUserFilterSectionType.allCases
        case .organizations:
            return ZLSearchOrgFilterSectionType.allCases
        case .pullRequests:
            return ZLSearchPrFilterSectionType.allCases
        case .issues:
            return ZLSearchIssueFilterSectionType.allCases
        @unknown default:
            return ZLSearchRepoFilterSectionType.allCases
        }
    }
}

protocol ZLSearchFilterSectionProtocol {
    var titleKey: String { get }
    
    var id: String { get }
    
    var cellTypes: [ZLSearchFilterCellType] { get }
}

// Repo 排序
enum ZLSearchRepoFilterSectionType:String, ZLSearchFilterSectionProtocol, CaseIterable {
    
    case order = "order"
    case language = "language"
    case createTime = "createTime"
    case star = "star"
    case fork = "fork"
    
    var titleKey: String {
        switch self {
        case .order:
            return "Order"
        case .language:
            return "Language"
        case .createTime:
            return "CreateTime"
        case .star:
            return "StarNum"
        case .fork:
            return "ForkNum"
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var cellTypes: [ZLSearchFilterCellType] {
        switch self {
        case .order:
            return [.repoOrder]
        case .language:
            return [.language]
        case .createTime:
            return [.firstCreatedTime,.singline,.secondCreatedTime]
        case .star:
            return [.firstStar,.singline,.secondStar]
        case .fork:
            return [.firstFork,.singline,.secondFork]
        }
    }
}

enum ZLSearchUserFilterSectionType:String, ZLSearchFilterSectionProtocol, CaseIterable {
    
    case order = "order"
    case language = "language"
    case createTime = "createTime"
    case follower = "follower"
    case repo = "repo"
    
    var titleKey: String {
        switch self {
        case .order:
            return "Order"
        case .language:
            return "Language"
        case .createTime:
            return "CreateTime"
        case .follower:
            return "FollowersNum"
        case .repo:
            return "PubReposNum"
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var cellTypes: [ZLSearchFilterCellType] {
        switch self {
        case .order:
            return [.userOrder]
        case .language:
            return [.language]
        case .createTime:
            return [.firstCreatedTime,.singline,.secondCreatedTime]
        case .follower:
            return [.firstFollower,.singline,.secondFollower]
        case .repo:
            return [.firstRepo,.singline,.secondRepo]
        }
    }
}

enum ZLSearchOrgFilterSectionType:String, ZLSearchFilterSectionProtocol, CaseIterable {
    
    case order = "order"
    case language = "language"
    case createTime = "createTime"
    case repo = "repo"
    
    var titleKey: String {
        switch self {
        case .order:
            return "Order"
        case .language:
            return "Language"
        case .createTime:
            return "CreateTime"
        case .repo:
            return "PubReposNum"
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var cellTypes: [ZLSearchFilterCellType] {
        switch self {
        case .order:
            return [.orgOrder]
        case .language:
            return [.language]
        case .createTime:
            return [.firstCreatedTime,.singline,.secondCreatedTime]
        case .repo:
            return [.firstRepo,.singline,.secondRepo]
        }
    }
}

enum ZLSearchIssueFilterSectionType:String, ZLSearchFilterSectionProtocol, CaseIterable {
    
    case order = "order"
    case language = "language"
    case openStatus = "openStatus"
    
    var titleKey: String {
        switch self {
        case .order:
            return "Order"
        case .language:
            return "Language"
        case .openStatus:
            return "State"
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var cellTypes: [ZLSearchFilterCellType] {
        switch self {
        case .order:
            return [.issueOrder]
        case .language:
            return [.language]
        case .openStatus:
            return [.openStatus]
        }
    }
}

enum ZLSearchPrFilterSectionType:String, ZLSearchFilterSectionProtocol, CaseIterable {
    
    case order = "order"
    case language = "language"
    case openStatus = "openStatus"
    
    var titleKey: String {
        switch self {
        case .order:
            return "Order"
        case .language:
            return "Language"
        case .openStatus:
            return "State"
        }
    }
    
    var id: String {
        return self.rawValue
    }
    
    var cellTypes: [ZLSearchFilterCellType] {
        switch self {
        case .order:
            return [.prOrder]
        case .language:
            return [.language]
        case .openStatus:
            return [.openStatus]
        }
    }
}

// MARK: Filter Cell

enum ZLSearchFilterCellType:String, CaseIterable {
    
    case repoOrder = "repoOrder"
    case userOrder = "userOrder"
    case orgOrder = "orgOrder"
    case issueOrder = "issueOrder"
    case prOrder = "prOrder"
    case language = "language"
    case openStatus = "openStatus"
    case firstCreatedTime = "firstCreatedTime"
    case secondCreatedTime = "secondCreatedTime"
    case firstStar = "firstStar"
    case secondStar = "secondStar"
    case firstFork = "firstFork"
    case secondFork = "secondFork"
    case firstFollower = "firstFollower"
    case secondFollower = "secondFollower"
    case firstRepo = "firstRepo"
    case secondRepo = "secondRepo"
    case singline = "singline"
    
    var id: String {
        return self.rawValue
    }
    
}

