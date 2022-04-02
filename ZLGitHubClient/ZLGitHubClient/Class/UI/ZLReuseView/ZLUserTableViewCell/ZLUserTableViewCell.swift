//
//  ZLUserTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/1.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

protocol ZLUserTableViewCellDelegate: NSObjectProtocol {

    func getName() -> String?

    func getLoginName() -> String?

    func getAvatarUrl() -> String?

    func getCompany() -> String?

    func getLocation() -> String?

    func desc() -> String?

    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
}

extension ZLUserTableViewCellDelegate {

    func getName() -> String? { nil }

    func getLoginName() -> String? { nil }

    func getAvatarUrl() -> String? { nil }

    func getCompany() -> String? { nil }

    func getLocation() -> String? { nil }

    func desc() -> String? { nil }

    func hasLongPressAction() -> Bool { false }

    func longPressAction(view: UIView) { }
}

class ZLUserTableViewCell: UITableViewCell {

    weak var delegate: ZLUserTableViewCellDelegate?

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.circle = true
        return imageView
    }()

    lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")

        return label
    }()

    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()

    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.numberOfLines = 5
        return label
    }()

    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(headImageView)
        containerView.addSubview(loginNameLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descLabel)

        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        headImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(headImageView)
            make.left.equalTo(headImageView.snp.right).offset(15)
            make.right.equalTo(-15)
        }

        loginNameLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.right.equalTo(-15)
        }

        descLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.top.equalTo(headImageView.snp.bottom).offset(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }

        containerView.addGestureRecognizer(longPressGesture)
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

extension ZLUserTableViewCell {
    func fillWithData(data: ZLUserTableViewCellDelegate) {

        delegate = data

        headImageView.sd_setImage(with: URL.init(string: data.getAvatarUrl() ?? ""), placeholderImage: UIImage.init(named: "default_avatar"))
        loginNameLabel.text = data.getLoginName()
        nameLabel.text = "\(data.getName() ?? "")"
        descLabel.text = data.desc()

        longPressGesture.isEnabled = data.hasLongPressAction()
    }
}
