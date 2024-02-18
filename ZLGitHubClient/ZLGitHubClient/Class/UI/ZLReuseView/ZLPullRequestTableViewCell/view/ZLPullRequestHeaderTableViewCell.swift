//
//  ZLPullRequestHeaderTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/24.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import YYText
import ZLBaseExtension

protocol ZLPullRequestHeaderTableViewCellDelegate: NSObjectProtocol {

    func getPRAuthorLoginName() -> String
    func getPRAuthorAvatarURL() -> String
    func getPRRepoFullName() -> NSAttributedString
    func getPRNumber() -> Int
    func getPRState() -> String
    func getPRTitle() -> String

    func getCommitNumber() -> Int
    func getFileChangedNumber() -> Int
    func getAdditionFileNumber() -> Int
    func getDeletedFileNumber() -> Int
    func getHeaderRef() -> String
    func getBaseRef() -> String

    func onAvatarButtonClicked()
    func onFileButtonClicked()
    func onCommitButtonClicked()

}

class ZLPullRequestHeaderTableViewCell: UITableViewCell {

    private weak var delegate: ZLPullRequestHeaderTableViewCellDelegate?

    var avatarButton: UIButton!
    var fullNameLabel: YYLabel!
    var numberLabel: UILabel!
    var titleLabel: UILabel!

    var refLabel1: UILabel!
    var refLabel2: UILabel!
    var statusLabel: UILabel!

    var fileChangedLabel: UILabel!
    var commitLabel: UILabel!

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func setUpUI() {

        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")

        avatarButton = UIButton(type: .custom)
        avatarButton.cornerRadius = 15
        self.contentView.addSubview(avatarButton)
        avatarButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        avatarButton.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)

        let label1 = YYLabel()
        self.contentView.addSubview(label1)
        label1.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.centerY.equalTo(avatarButton)
        }
        fullNameLabel = label1

        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        self.contentView.addSubview(label2)
        label2.snp.makeConstraints { (make) in
            make.left.equalTo(fullNameLabel.snp.right).offset(10)
            make.centerY.equalTo(avatarButton)
        }
        numberLabel = label2

        let label3 = UILabel()
        label3.textColor = UIColor(named: "ZLLabelColor1")
        label3.font = UIFont(name: Font_PingFangSCSemiBold, size: 20)
        label3.numberOfLines = 4
        self.contentView.addSubview(label3)
        label3.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.top.equalTo(avatarButton.snp.bottom).offset(10)
        }
        titleLabel = label3

        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(label3.snp.bottom).offset(10)
        }

        let label4 = UILabel()
        label4.textColor = UIColor(named: "ZLPRRefColor")
        label4.backgroundColor = UIColor(named: "ZLPRRefBackColor")
        label4.borderColor = UIColor(named: "ZLPRRefColor")
        label4.borderWidth = 1.0 / 3
        label4.cornerRadius = 5
        label4.font = UIFont(name: Font_PingFangSCMedium, size: 12)
        scrollView.addSubview(label4)
        label4.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.height.equalTo(25)
        }
        refLabel1 = label4

        let arrowImageView = UIImageView()
        arrowImageView.image = UIImage(named: "arrow_right")
        scrollView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.left.equalTo(label4.snp.right).offset(5)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(label4)
        }

        let label6 = UILabel()
        label6.textColor = UIColor(named: "ZLPRRefColor")
        label6.backgroundColor = UIColor(named: "ZLPRRefBackColor")
        label6.borderColor = UIColor(named: "ZLPRRefColor")
        label6.borderWidth = 1.0 / 3
        label6.cornerRadius = 5
        label6.font = UIFont(name: Font_PingFangSCMedium, size: 12)
        scrollView.addSubview(label6)
        label6.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(arrowImageView.snp.right).offset(5)
            make.height.equalToSuperview()
            make.height.equalTo(25)
        }
        refLabel2 = label6

        let label5 = UILabel()
        label5.font = UIFont(name: Font_PingFangSCMedium, size: 12)
        label5.borderWidth = 1.0 / 3
        label5.cornerRadius = 5
        label5.textAlignment = .center
        self.contentView.addSubview(label5)
        label5.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(scrollView.snp.bottom).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        statusLabel = label5

        let lineview1 = UIView()
        lineview1.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(lineview1)
        lineview1.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(1.0 / 2)
        }

        let filebutton = UIButton(type: .custom)
        filebutton.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        self.contentView.addSubview(filebutton)
        filebutton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lineview1.snp.bottom)
        }
        filebutton.addTarget(self, action: #selector(onFileButtonClicked), for: .touchUpInside)

        let fileButtonLabel = UILabel()
        fileButtonLabel.numberOfLines = 0
        filebutton.addSubview(fileButtonLabel)
        fileButtonLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
        }
        fileChangedLabel = fileButtonLabel

        let fileButtonNextTag = UILabel()
        fileButtonNextTag.font = UIFont.zlIconFont(withSize: 15)
        fileButtonNextTag.textColor = UIColor(named: "ICON_Common")
        fileButtonNextTag.text = ZLIconFont.NextArrow.rawValue
        filebutton.addSubview(fileButtonNextTag)
        fileButtonNextTag.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }

        let lineview2 = UIView()
        lineview2.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(lineview2)
        lineview2.snp.makeConstraints { (make) in
            make.top.equalTo(filebutton.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.height.equalTo(1.0 / 2)
        }

        let commitButton = UIButton(type: .custom)
        commitButton.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        self.contentView.addSubview(commitButton)
        commitButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(lineview2.snp.bottom)
            make.height.equalTo(filebutton.snp.height)
            make.bottom.equalToSuperview()
        }
        commitButton.addTarget(self, action: #selector(onCommitButtonClicked), for: .touchUpInside)

        let commitButtonLabel = UILabel()
        commitButtonLabel.numberOfLines = 0
        commitButtonLabel.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        commitButtonLabel.textColor = UIColor(named: "ZLLabelColor1")
        commitButton.addSubview(commitButtonLabel)
        commitButtonLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
        }
        commitLabel = commitButtonLabel

        let commitButtonNextTag = UILabel()
        commitButtonNextTag.font = UIFont.zlIconFont(withSize: 15)
        commitButtonNextTag.textColor = UIColor(named: "ICON_Common")
        commitButtonNextTag.text = ZLIconFont.NextArrow.rawValue
        commitButton.addSubview(commitButtonNextTag)
        commitButtonNextTag.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
    }

    func fillWithData(data: ZLPullRequestHeaderTableViewCellDelegate) {

        self.delegate = data

        avatarButton.loadAvatar(login: data.getPRAuthorLoginName(), avatarUrl: data.getPRAuthorAvatarURL())
        fullNameLabel.attributedText = data.getPRRepoFullName()
        numberLabel.text = "#\(data.getPRNumber())"
        titleLabel.text = data.getPRTitle()

        let fileChangedStr = NSMutableAttributedString(string: "\(data.getFileChangedNumber()) file changed",
                                                       attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1") ,
                                                                    .font: UIFont.zlRegularFont(withSize: 14)])
        if data.getFileChangedNumber() > 0 {
            fileChangedStr.append(NSAttributedString(string: "\n"))
        }

        if data.getAdditionFileNumber() > 0 {
            let addition = NSMutableAttributedString(string: "+\(data.getAdditionFileNumber()) ",
                                                     attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLPROpenedColor"),
                                                                  .font: UIFont.zlRegularFont(withSize: 14)])
            fileChangedStr.append(addition)
        }
        if data.getDeletedFileNumber() > 0 {
            let deleted = NSMutableAttributedString(string: "-\(data.getDeletedFileNumber())",
                                                    attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLPRClosedColor") ,
                                                                 .font: UIFont.zlRegularFont(withSize: 14)])
            fileChangedStr.append(deleted)
        }
        fileChangedLabel.attributedText = fileChangedStr

        commitLabel.text = "\(data.getCommitNumber()) commit"

        refLabel1.text = data.getHeaderRef()
        refLabel2.text = data.getBaseRef()

        statusLabel.text = " \(data.getPRState()) "
        if data.getPRState() == "OPEN" {
            statusLabel.textColor = UIColor(named: "ZLPROpenedColor")
            statusLabel.backgroundColor = UIColor(named: "ZLPROpenedBackColor")
            statusLabel.borderColor = UIColor(named: "ZLPROpenedColor")
        } else if data.getPRState() == "CLOSED" {
            statusLabel.textColor = UIColor(named: "ZLPRClosedColor")
            statusLabel.backgroundColor = UIColor(named: "ZLPRClosedBackColor")
            statusLabel.borderColor = UIColor(named: "ZLPRClosedColor")
        } else if data.getPRState() == "MERGED" {
            statusLabel.textColor = UIColor(named: "ZLPRMergedColor")
            statusLabel.backgroundColor = UIColor(named: "ZLPRMergedBackColor")
            statusLabel.borderColor = UIColor(named: "ZLPRMergedColor")
        }
     }

    @objc func onAvatarButtonClicked() {
        self.delegate?.onAvatarButtonClicked()
    }

    @objc func onFileButtonClicked() {
        self.delegate?.onFileButtonClicked()
    }

    @objc func onCommitButtonClicked() {
        self.delegate?.onCommitButtonClicked()
    }

}
