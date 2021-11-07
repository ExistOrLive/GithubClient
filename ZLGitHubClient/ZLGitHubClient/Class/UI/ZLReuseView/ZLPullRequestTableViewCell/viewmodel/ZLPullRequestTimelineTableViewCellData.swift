//
//  ZLPullRequestTimelineTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLPullRequestTimelineTableViewCellData: ZLGithubItemTableViewCellData {
    
    typealias TimelineData = PrInfoQuery.Data.Repository.PullRequest.TimelineItem.Node
    
    let data : TimelineData
    
    private var attributedString : NSAttributedString?
    
    init(data : TimelineData) {
        self.data = data
        super.init()
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLPullRequestTimelineTableViewCell = targetView as? ZLPullRequestTimelineTableViewCell {
            cell.fillWithData(data:self)
        }
    }
    
    
    override func getCellReuseIdentifier() -> String {
        return "ZLPullRequestTimelineTableViewCell";
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension;
    }

}

extension ZLPullRequestTimelineTableViewCellData : ZLPullRequestTimelineTableViewCellDelegate {
    
    func getTimelineMessage() -> NSAttributedString {
        
        if let str = attributedString {
            return str
        }
        
        if let tmpdata = data.asAssignedEvent
        {
            var assignee : String? = nil
            if let bot = tmpdata.assignee?.asBot {
                assignee = bot.login
            } else if let user = tmpdata.assignee?.asUser {
                assignee = user.login
            } else if let mannequin = tmpdata.assignee?.asMannequin {
                assignee = mannequin.login
            } else if let org = tmpdata.assignee?.asOrganization {
                assignee = org.login
            }
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [.font:UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " assigned ",
                                             attributes: [.font:UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: assignee ?? "",
                                             attributes: [.font:UIFont.zlSemiBoldFont(withSize: 15),
                                                          .foregroundColor:UIColor(named: "ZLLabelColor1")!]))
            
            attributedString = string
            
            return string
        }
        else if let tmpdata = data.asClosedEvent
        {
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " closed pull request",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            attributedString = string
            
            return string
        }
        else if let tmpdata = data.asCommentDeletedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " deleted comment",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            attributedString = string
            
            return string
            
        }
        else if let tmpdata = data.asCrossReferencedEvent
        {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            if tmpdata.target.asIssue != nil  {
                
                string.append(NSAttributedString(string: " referenced issue  \n\n ",
                                                 attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                              NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
                
                string.append(NSAttributedString(string: "\(tmpdata.target.asIssue?.title ?? "")",
                                                 attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 14)!,
                                                              NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!]))
                
            }
            
            if tmpdata.target.asPullRequest != nil  {
                
                string.append(NSAttributedString(string: " referenced pull request  \n\n ",
                                                 attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                              NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
                
                string.append(NSAttributedString(string: "\(tmpdata.target.asPullRequest?.title ?? "")",
                                                 attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 14)!,
                                                              NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!]))
                
            }
            
            attributedString = string
            
            return string
            
        }
        else if let tmpdata = data.asHeadRefForcePushedEvent
        {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " force-pushed the branch ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.ref?.name ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor2")!]))
            
            string.append(NSAttributedString(string: " from ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.beforeCommit?.abbreviatedOid ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor1")!]))
            
            string.append(NSAttributedString(string: " to ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.afterCommit?.abbreviatedOid ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor1")!]))
            
            attributedString = string
        
            
            return string
            
        }
        else if let tmpdata = data.asHeadRefDeletedEvent
        {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " deleted branch ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
                        
            string.append(NSAttributedString(string: "\(tmpdata.headRefName)",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor2")!]))
            
            attributedString = string
            
            return string
            
        }
        else if let tmpdata = data.asLabeledEvent
        {
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " added label ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            let color = ZLRGBValueStr_H(colorValue:tmpdata.label.color)
            string.append(NSAttributedString(string: "\(tmpdata.label.name)",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 13)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor.isLightColor(color) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white,
                                                          NSAttributedString.Key.backgroundColor:color]))
            
            attributedString = string
            
            return string
            
        }
        else if let tmpdata = data.asLockedEvent{
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " locked pull request ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asMergedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " merged commit ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.nullableName?.abbreviatedOid ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor1")!]))
            
            string.append(NSAttributedString(string: " into ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.mergeRefName)",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor2")!]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asMilestonedEvent{
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " added milestone ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string:tmpdata.milestoneTitle,
                                                    attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                 NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!]))

            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asPinnedEvent{
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " pinned pull request ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))

            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asPullRequestCommit {
            
            let string = NSMutableAttributedString(string: "\(tmpdata.commit.abbreviatedOid)  ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 13)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLinkLabelColor1")!])
            
            string.append(NSAttributedString(string:tmpdata.commit.messageHeadline ,
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 14)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asPullRequestReview {
            
            let string = NSMutableAttributedString(string:tmpdata.author?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " reviewed these change ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))

            attributedString = string
            
            return string
            
            
        }
        
        else if let tmpdata = data.asReferencedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " added a commit that referenced this pull request \n\n ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            string.append(NSAttributedString(string: "\(tmpdata.nullableName?.messageHeadline ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asRenamedTitleEvent {
           
           let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                  attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                               NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
           
           string.append(NSAttributedString(string: " changed the title ",
                                            attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                         NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
                       
           string.append(NSAttributedString(string: "\(tmpdata.previousTitle) ",
                                            attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                         NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!,
                                                         NSAttributedString.Key.strikethroughStyle:NSUnderlineStyle.byWord]))
           
           string.append(NSAttributedString(string: "\(tmpdata.currentTitle)",
                                            attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                         NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor2")!]))
           
           attributedString = string
           
           return string
           
       }
        
        else if let tmpdata = data.asReopenedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " reopened pull request",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            attributedString = string
            
            return string
            
        }
        
        
        else if let tmpdata = data.asReviewRequestedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " request review from ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            var assignee : String? = nil
            if let user = tmpdata.requestedReviewer?.asUser {
                assignee = user.login
            } else if let team = tmpdata.requestedReviewer?.asTeam {
                assignee = team.name
            } else if let mannequin = tmpdata.requestedReviewer?.asMannequin {
                assignee = mannequin.login
            }
            
            string.append(NSAttributedString(string: "\(assignee ?? "")",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 15)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asUnlabeledEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " removed label  ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            let color = ZLRGBValueStr_H(colorValue:tmpdata.label.color)
            string.append(NSAttributedString(string: "\(tmpdata.label.name)",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 13)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor.isLightColor(color) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white,
                                                          NSAttributedString.Key.backgroundColor:color]))
            
            attributedString = string
            
            return string
            
        }
        
        else if let tmpdata = data.asUnpinnedEvent {
            
            let string = NSMutableAttributedString(string:tmpdata.actor?.login ?? "",
                                                   attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                                                NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
            
            string.append(NSAttributedString(string: " unpinned pull request ",
                                             attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCRegular, size: 14)!,
                                                          NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor4")!]))
            
            attributedString = string
            
            return string
            
        }
        
        
        return NSAttributedString(string:data.__typename,
                                  attributes: [NSAttributedString.Key.font:UIFont(name: Font_PingFangSCSemiBold, size: 15)!,
                                               NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!])
    }
}

