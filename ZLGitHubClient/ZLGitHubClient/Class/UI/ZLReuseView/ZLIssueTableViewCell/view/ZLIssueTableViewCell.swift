//
//  ZLIssueTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/13.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import YYText
import ZLBaseExtension
import ZLUtilities

protocol ZLIssueTableViewCellDelegate: NSObjectProtocol {

    func getIssueRepoFullName() -> String?

    func getIssueTitleStr() -> String?

    func isIssueClosed() -> Bool

    func getIssueAssistStr() -> String?

    func getIssueLabels() -> [(String, String)]

    func onClickIssueRepoFullName()
    
    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
}

class ZLIssueTableViewCell: UITableViewCell {
    // view
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    private lazy var statusTag: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 20)
        return label
    }()

    private lazy var repoNameTitleLabel: YYLabel = {
       let label = YYLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ZLKeyWindowWidth - 90
        return label
    }()

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 15)
        return label
    }()

    private lazy var assitLabel: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        label2.textAlignment = .left
        label2.numberOfLines = 0
        return label2
    }()
    
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()

    weak var delegate: ZLIssueTableViewCellDelegate?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    @objc func onRepoNameClick() {
        self.delegate?.onClickIssueRepoFullName()
    }

    func setUpUI() {
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        containerView.addSubview(statusTag)
        statusTag.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }

        containerView.addSubview(repoNameTitleLabel)
        repoNameTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(statusTag.snp.right).offset(10)
            make.centerY.equalTo(statusTag)
            make.right.equalToSuperview().offset(-15)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(repoNameTitleLabel)
            make.top.equalTo(repoNameTitleLabel.snp.bottom).offset(10)
        }

        containerView.addSubview(labelStackView)
        labelStackView.snp.makeConstraints { (make) in
            make.left.equalTo(statusTag.snp.right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }

        containerView.addSubview(assitLabel)
        assitLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelStackView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.left.right.equalTo(repoNameTitleLabel)
        }
        
        containerView.addGestureRecognizer(longPressGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func fillWithData(cellData: ZLIssueTableViewCellDelegate) {

        self.delegate = cellData
        
        longPressGesture.isEnabled = cellData.hasLongPressAction()

        let title = NSMutableAttributedString(string: cellData.getIssueRepoFullName() ?? "",
                                              attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1"),
                                                           .font: UIFont.zlMediumFont(withSize: 15)])
        title.yy_setTextHighlight(NSRange(location: 0, length: title.length),
                                  color: nil,
                                  backgroundColor: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor)) { [weak self]_, _, _, _ in
            self?.onRepoNameClick()
        }
        self.repoNameTitleLabel.attributedText = title

        self.titleLabel.text = cellData.getIssueTitleStr()
        self.assitLabel.text = cellData.getIssueAssistStr()
        self.statusTag.text = cellData.isIssueClosed() ? ZLIconFont.IssueClose.rawValue : ZLIconFont.IssueOpen.rawValue
        self.statusTag.textColor = cellData.isIssueClosed() ? UIColor(named: "ZLIssueClosedColor") : UIColor(named: "ZLIssueOpenedColor")

        for view in self.labelStackView.subviews {
            view.removeFromSuperview()
        }

        var length: CGFloat = 0.0
        for (label, colorStr) in cellData.getIssueLabels() {
            let font = UIFont.zlRegularFont(withSize: 11)
            let attributes: [NSAttributedString.Key: Any]  = [.font: font]
            let attributedStr = NSAttributedString.init(string: label, attributes: attributes)
            let size = attributedStr.boundingRect(with: CGSize.init(width: ZLScreenWidth, height: ZLSCreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)

            if CGFloat(length) + 16.0 + size.width > ZLScreenWidth - 70 {
                break
            }
            length += 16.0 + size.width

            let color = ZLRGBValueStr_H(colorValue: colorStr)
            let labelView = UILabel.init()
            labelView.textAlignment = .center
            labelView.font = font
            labelView.text = label
            labelView.layer.cornerRadius = 4.0
            labelView.layer.masksToBounds = true
            labelView.backgroundColor = color
            labelView.textColor = UIColor.isLightColor(color) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white

            if #available(iOS 12.0, *) {
                if getRealUserInterfaceStyle() == .dark {
                    labelView.backgroundColor = ZLRGBValueStr_H(colorValue: colorStr, alphaValue: 0.2)
                    labelView.layer.borderWidth = 1.0 / labelView.layer.contentsScale
                    labelView.layer.borderColor = ZLRGBValueStr_H(colorValue: colorStr, alphaValue: 0.5).cgColor
                    labelView.textColor = ZLRGBValueStr_H(colorValue: colorStr)
                }
            }

            labelView.snp.makeConstraints { (make) in
                make.width.equalTo(8.0 + size.width)
            }
            self.labelStackView.addArrangedSubview(labelView)
        }

        self.labelStackView.snp.updateConstraints { (make) in
            make.height.equalTo(cellData.getIssueLabels().count == 0 ? 0 : 20)
        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        delegate?.longPressAction(view: self)
    }

}
