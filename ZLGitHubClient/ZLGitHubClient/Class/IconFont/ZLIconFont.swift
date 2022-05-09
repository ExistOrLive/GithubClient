//
//  ZLIconFont.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/30.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation

// iconfont
public struct ZLIconFont {
    let rawValue: String

    static let IssueOpen = ZLIconFont(rawValue: "\u{e70f}")
    static let IssueClose = ZLIconFont(rawValue: "\u{e737}")
    static let IssueMerge = ZLIconFont(rawValue: "\u{e70f}")

    static let NextArrow = ZLIconFont(rawValue: "\u{e688}")
    static let BackArrow = ZLIconFont(rawValue: "\u{e686}")
    static let Reload = ZLIconFont(rawValue: "\u{e62f}")

    static let Add = ZLIconFont(rawValue: "\u{e685}")
    static let Close = ZLIconFont(rawValue: "\u{e687}")

    static let PR = ZLIconFont(rawValue: "\u{e76e}")
    static let RepoStar = ZLIconFont(rawValue: "\u{e68a}")
    static let RepoFork = ZLIconFont(rawValue: "\u{e799}")
    static let RepoPrivate = ZLIconFont(rawValue: "\u{e7c9}")

    static let DownArrow = ZLIconFont(rawValue: "\u{e68c}")

    static let File = ZLIconFont(rawValue: "\u{e674}")
    static let DirClose = ZLIconFont(rawValue: "\u{e675}")
    static let DirOpen = ZLIconFont(rawValue: "\u{e677}")

    static let Filter = ZLIconFont(rawValue: "\u{e676}")

    static let More = ZLIconFont(rawValue: "\u{e7e3}")

    static let Workflow = ZLIconFont(rawValue: "\u{e77b}")

    static let Notification = ZLIconFont(rawValue: "\u{e629}")

    static let NoData = ZLIconFont(rawValue: "\u{e60e}")

    static let Commit = ZLIconFont(rawValue: "\u{e857}")

    static let Tag = ZLIconFont(rawValue: "\u{e738}")

    static let Alert = ZLIconFont(rawValue: "\u{e637}")

    static let Discussion = ZLIconFont(rawValue: "\u{e638}")

    static let Edit = ZLIconFont(rawValue: "\u{e66f}")

    static let GithubRunSuccess = ZLIconFont(rawValue: "\u{e73c}")

    static let GithubRunCancel = ZLIconFont(rawValue: "\u{e614}")

    static let GithubRunFail = ZLIconFont(rawValue: "\u{e6d9}")

    static let GithubRunInProgress = ZLIconFont(rawValue: "\u{e7e0}")

    static let RoundSelected = ZLIconFont(rawValue: "\u{e73c}")

    static let LineSelected = ZLIconFont(rawValue: "\u{e689}")

    static let PasteBoard = ZLIconFont(rawValue: "\u{e983}")

    static let Search = ZLIconFont(rawValue: "\u{e67d}")

    static let Share = ZLIconFont(rawValue: "\u{e68d}")

    static let Home = ZLIconFont(rawValue: "\u{e6b8}")

    static let Setting = ZLIconFont(rawValue: "\u{e78e}")
    
    static let Safari = ZLIconFont(rawValue: "\u{e69c}")
    
    static let Comment = ZLIconFont(rawValue: "\u{e68d}")
    
    static let ThumbsUP = ZLIconFont(rawValue: "\u{ec7f}")
}
