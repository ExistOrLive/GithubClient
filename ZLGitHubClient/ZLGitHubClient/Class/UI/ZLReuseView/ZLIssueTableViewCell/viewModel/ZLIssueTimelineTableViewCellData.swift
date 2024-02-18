//
//  ZLIssueTimelineTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZLGitRemoteService

class ZLIssueTimelineTableViewCellData: ZLGithubItemTableViewCellData {

    typealias IssueTimelineData = IssueTimeLineInfoQuery.Data.Repository.Issue.TimelineItem.Node

    let data: IssueTimelineData

    var attributedString: NSAttributedString?

    init(data: IssueTimelineData) {
        self.data = data
        super.init()
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell: ZLIssueTimelineTableViewCell = targetView as? ZLIssueTimelineTableViewCell {
            cell.fillWithData(data: self)
        }
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLIssueTimelineTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }

    override func clearCache() {
        super.clearCache()
        attributedString = nil
    }

}

extension ZLIssueTimelineTableViewCellData: ZLIssueTimelineTableViewCellDelegate {

    func getTimelineMessage() -> NSAttributedString {

        if let attributedString = attributedString {
            return attributedString
        }

        if let tmpdata = data.asAssignedEvent {
            var assignee: String?
            if let bot = tmpdata.assignee?.asBot {
                assignee = bot.login
            } else if let user = tmpdata.assignee?.asUser {
                assignee = user.login
            } else if let mannequin = tmpdata.assignee?.asMannequin {
                assignee = mannequin.login
            } else if let org = tmpdata.assignee?.asOrganization {
                assignee = org.login
            }

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " assigned ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            string.append(NSAttributedString(string: assignee ?? "",
                                             attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor1")]))

            attributedString = string

            return string
        } else if let tmpdata = data.asUnassignedEvent {
            
            var assignee: String?
            if let bot = tmpdata.assignee?.asBot {
                assignee = bot.login
            } else if let user = tmpdata.assignee?.asUser {
                assignee = user.login
            } else if let mannequin = tmpdata.assignee?.asMannequin {
                assignee = mannequin.login
            } else if let org = tmpdata.assignee?.asOrganization {
                assignee = org.login
            }

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " unassigned ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            string.append(NSAttributedString(string: assignee ?? "",
                                             attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor1")]))

            attributedString = string
            
            return string
            
        } else if let tmpdata = data.asClosedEvent {
            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " closed issue",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))
            attributedString = string

            return string
        } else if let tmpdata = data.asCommentDeletedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " deleted comment",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asCrossReferencedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            if tmpdata.target.asIssue != nil {

                string.append(NSAttributedString(string: " referenced issue  \n\n ",
                                                 attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                              .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

                string.append(NSAttributedString(string: "\(tmpdata.target.asIssue?.title ?? "")",
                                                 attributes: [.font: UIFont.zlMediumFont(withSize: 14),
                                                              .foregroundColor: UIColor.label(withName: "ZLLabelColor2")]))

            }

            if tmpdata.target.asPullRequest != nil {

                string.append(NSAttributedString(string: " referenced pull request  \n\n ",
                                                 attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                              .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

                string.append(NSAttributedString(string: "\(tmpdata.target.asPullRequest?.title ?? "")",
                                                 attributes: [.font: UIFont.zlMediumFont(withSize: 14),
                                                              .foregroundColor: UIColor.label(withName: "ZLLabelColor2")]))

            }

            attributedString = string

            return string

        } else if let tmpdata = data.asLabeledEvent {
            let tagColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color)
            var borderColor = UIColor.clear
            var backColor = tagColor
            var textColor = UIColor.isLightColor(tagColor) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white
            var borderWidth: CGFloat = 0.0

            if #available(iOS 12.0, *) {
                if getRealUserInterfaceStyle() == .dark {
                    backColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color, alphaValue: 0.2)
                    borderWidth = 1.0 / UIScreen.main.scale
                    borderColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color, alphaValue: 0.5)
                    textColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color)
                }
            }

            let string = NSASCContainer(

                tmpdata.actor?
                    .login
                    .asMutableAttributedString()
                    .font(.zlSemiBoldFont(withSize: 15))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor1")),

                " added label "
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 14))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor4")),

                NSTagWrapper()
                    .attributedString(tmpdata.label.name
                                        .asMutableAttributedString()
                                        .font(.zlRegularFont(withSize: 13))
                                        .foregroundColor(textColor))
                    .cornerRadius(4.0)
                    .borderColor(borderColor)
                    .borderWidth(borderWidth)
                    .backgroundColor(backColor)
                    .edgeInsets(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
                    .asImage()?
                    .asImageTextAttachmentWrapper()
                    .alignment(.centerline)

            ).asMutableAttributedString()
            
            let paragraphStyle = NSMutableParagraphStyle().lineSpacing(10)
            attributedString = string.paraghStyle(paragraphStyle)

            return string

        } else if let tmpdata = data.asLockedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " locked issue ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asUnlockedEvent {
            
            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " unlocked issue ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asMilestonedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " added milestone ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            string.append(NSAttributedString(string: tmpdata.milestoneTitle,
                                                    attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                 .foregroundColor: UIColor.label(withName: "ZLLabelColor1")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asPinnedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " pinned issue ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asReferencedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " added a commit that referenced this issue \n\n ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            string.append(NSAttributedString(string: "\(tmpdata.nullableName?.messageHeadline ?? "")",
                                             attributes: [.font: UIFont.zlMediumFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor2")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asRenamedTitleEvent {
            
            
            let string: NSMutableAttributedString = NSASCContainer(
                
                tmpdata.actor?.login ?? ""
                    .asMutableAttributedString()
                    .font(.zlSemiBoldFont(withSize: 15))
                    .foregroundColor(.label(withName:"ZLLabelColor1")),
                
                " changed title "
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 14))
                    .foregroundColor(.label(withName:"ZLLabelColor4")),
                
                "\(tmpdata.previousTitle)"
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 14))
                    .foregroundColor(.label(withName: "ZLLabelColor2"))
                    .strikethroughStyle(.single)
                    .strikethroughColor(.label(withName: "ZLLabelColor2")),
                
                " to "
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 14))
                    .foregroundColor(.label(withName:"ZLLabelColor4")),
                
                "\(tmpdata.currentTitle)"
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 14))
                    .foregroundColor(.label(withName: "ZLLabelColor2"))
                
            ).asMutableAttributedString()

           attributedString = string

           return string

       } else if let tmpdata = data.asReopenedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " reopened issue",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpdata = data.asUnlabeledEvent {

            let tagColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color)
            var borderColor = UIColor.clear
            var backColor = tagColor
            var textColor = UIColor.isLightColor(tagColor) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white
            var borderWidth: CGFloat = 0.0

            if #available(iOS 12.0, *) {
                if getRealUserInterfaceStyle() == .dark {
                    backColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color, alphaValue: 0.2)
                    borderWidth = 1.0 / UIScreen.main.scale
                    borderColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color, alphaValue: 0.5)
                    textColor = ZLRGBValueStr_H(colorValue: tmpdata.label.color)
                }
            }

            let string = NSASCContainer(

                tmpdata.actor?
                    .login
                    .asMutableAttributedString()
                    .font(.zlSemiBoldFont(withSize: 15))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor1")),

                " removed label "
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 14))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor4")),

                NSTagWrapper()
                    .attributedString(tmpdata.label.name
                                        .asMutableAttributedString()
                                        .font(.zlRegularFont(withSize: 13))
                                        .foregroundColor(textColor))
                    .cornerRadius(4.0)
                    .borderColor(borderColor)
                    .borderWidth(borderWidth)
                    .backgroundColor(backColor)
                    .edgeInsets(UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
                    .asImage()?
                    .asImageTextAttachmentWrapper()
                    .alignment(.centerline)

            ).asMutableAttributedString()

            let paragraphStyle = NSMutableParagraphStyle().lineSpacing(10)
            attributedString = string.paraghStyle(paragraphStyle)

            return string

        } else if let tmpdata = data.asUnpinnedEvent {

            let string = NSMutableAttributedString(string: tmpdata.actor?.login ?? "",
                                                   attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                                                .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])

            string.append(NSAttributedString(string: " unpinned issue ",
                                             attributes: [.font: UIFont.zlRegularFont(withSize: 14),
                                                          .foregroundColor: UIColor.label(withName: "ZLLabelColor4")]))

            attributedString = string

            return string

        } else if let tmpData = data.asAddedToProjectEvent {
            
            let string = NSASCContainer(

                tmpData.actor?
                    .login
                    .asMutableAttributedString()
                    .font(.zlSemiBoldFont(withSize: 15))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor1")),

                " added this issue to project"
                    .asMutableAttributedString()
                    .font(.zlRegularFont(withSize: 14))
                    .foregroundColor(ZLRawLabelColor(name: "ZLLabelColor4"))
                
            ).asMutableAttributedString()
            
    
            attributedString = string

            return string
        }

        return NSAttributedString(string: data.__typename,
                                  attributes: [.font: UIFont.zlSemiBoldFont(withSize: 15),
                                               .foregroundColor: UIColor.label(withName: "ZLLabelColor1")])
    }
}
