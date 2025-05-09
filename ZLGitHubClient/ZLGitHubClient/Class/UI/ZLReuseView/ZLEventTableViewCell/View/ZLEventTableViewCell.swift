//
//  ZLEventTableViewCell.swift
//  ZLGitHubClient
//
//  Created by ZM on 2019/11/25.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import YYText
import ZLUtilities
import ZMMVVM


class ZLEventTableViewCell: UITableViewCell, ZMBaseViewUpdatableWithViewData {

    var delegate: ZLEventTableViewCellData? {
        zm_viewModel as? ZLEventTableViewCellData
    }

    var containerView: UIView?

    var headImageButton: UIButton?

    var actorNameLabel: UILabel?

    var timeLabel: UILabel?

    var eventDesLabel: YYLabel?

    var assistInfoView: UIView?

    var reportMoreButton: UIButton?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.setUpUI()
    }

    func setUpUI() {
        selectionStyle = .none
        // containerView
        let view = UIView.init()
        view.backgroundColor = UIColor.init(named: "ZLCellBack")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8.0
        self.contentView.addSubview(view)
        view.snp.makeConstraints({(make) -> Void in
            make.edges.equalTo(self.contentView).inset(UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10))
        })
        self.containerView = view

        // headImageButton
        let headImageButton = UIButton.init(type: .custom)
        headImageButton.layer.cornerRadius = 20.0
        headImageButton.layer.masksToBounds = true
        self.containerView?.addSubview(headImageButton)
        headImageButton.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.containerView!.snp.left).offset(10)
            make.top.equalTo(self.containerView!.snp.top).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        })
        self.headImageButton = headImageButton
        self.headImageButton?.addTarget(self, action: #selector(self.onAvatarButtonClicked(button:)), for: .touchUpInside)

        let actorNameLabel = UILabel.init()
        actorNameLabel.textColor = UIColor.init(named: "ZLLabelColor1") ?? UIColor.black
        actorNameLabel.font = UIFont.init(name: Font_PingFangSCMedium, size: 16.0)
        self.containerView?.addSubview(actorNameLabel)
        actorNameLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.headImageButton!.snp.right).offset(10)
            make.centerY.equalTo(self.headImageButton!.snp.centerY)
        })
        self.actorNameLabel = actorNameLabel

        let timeLabel = UILabel.init()
        timeLabel.textColor = UIColor.init(named: "ZLLabelColor2") ?? UIColor.init(hexString: "#878787", alpha: 1.0)
        timeLabel.font = UIFont.init(name: Font_PingFangSCMedium, size: 15.0)
        self.containerView?.addSubview(timeLabel)
        timeLabel.snp.makeConstraints({(make) -> Void in
            make.right.equalTo(self.containerView!.snp.right).offset(-10)
            make.centerY.equalTo(self.actorNameLabel!.snp.centerY)
        })
        self.timeLabel = timeLabel

        let eventDesLabel = YYLabel.init()
        eventDesLabel.numberOfLines = 0
        eventDesLabel.preferredMaxLayoutWidth = ZLScreenWidth - 50
        self.containerView?.addSubview(eventDesLabel)
        eventDesLabel.snp.makeConstraints({(make) -> Void in
            make.left.equalTo(self.containerView!.snp.left).offset(15)
            make.right.equalTo(self.containerView!.snp.right).offset(-10)
            make.top.equalTo(self.headImageButton!.snp.bottom).offset(10)
        })
        self.eventDesLabel = eventDesLabel

        let assistInfoView = UIView.init()
        self.containerView?.addSubview(assistInfoView)
        assistInfoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.eventDesLabel!.snp.bottom).offset(20)
            make.left.equalTo(self.containerView!.snp.left).offset(10)
            make.right.equalTo(self.containerView!.snp.right).offset(-10)
            make.height.equalTo(20).priority(.medium)
        }
        self.assistInfoView = assistInfoView

        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(ZLEventTableViewCell.onReportButtonClicked), for: .touchUpInside)
        let str = NSAttributedString(string: ZLIconFont.More.rawValue, attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                                    .foregroundColor: UIColor.label(withName: "ICON_Common")])
        button.setAttributedTitle(str, for: .normal)
        self.containerView?.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(45)
            make.height.equalTo(30)
            make.right.equalTo(self.containerView!.snp.right).offset(-10)
            make.bottom.equalTo(self.containerView!.snp.bottom).offset(-10)
            make.top.equalTo(self.assistInfoView!.snp.bottom).offset(0)
        }
        self.reportMoreButton = button
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

    func hiddenReportButton(hidden: Bool) {
        self.reportMoreButton?.isHidden = hidden
        if hidden {
            self.reportMoreButton!.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        } else {
            self.reportMoreButton!.snp.updateConstraints { (make) in
                make.height.equalTo(30)
            }
        }
    }
    
    func zm_fillWithViewData(viewData cellData: ZLEventTableViewCellData) {
        self.headImageButton?.loadAvatar(login:cellData.getActorName() ,
                                         avatarUrl: cellData.getActorAvaterURL())
        self.actorNameLabel?.text = cellData.getActorName()
        self.timeLabel?.text = cellData.getTimeStr()
        self.eventDesLabel?.attributedText = cellData.getEventDescrption()
        self.hiddenReportButton(hidden: !cellData.showReportButton)
    }
}

// MARK: action
extension ZLEventTableViewCell {
    @objc func onAvatarButtonClicked(button: UIButton) {
       self.delegate?.onAvatarClicked()
    }

    @objc func onReportButtonClicked() {
        self.delegate?.onReportClicked()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView?.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView?.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView?.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
}
