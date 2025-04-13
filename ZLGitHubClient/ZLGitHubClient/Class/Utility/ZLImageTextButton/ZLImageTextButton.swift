//
//  ZLImageTextButton.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/4/12.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import SnapKit

open class ZLImageTextButton: UIButton {

    public enum ZLContentAlignType {
        case imageTop
        case imageBottom
        case imageLeft
        case imageRight
    }

    private var alignType: ZLContentAlignType = .imageLeft
    @objc public dynamic var contentInset = UIEdgeInsets() {
        didSet {
            if alignType == .imageLeft || alignType == .imageRight {
                let aligment = self.contentHorizontalAlignment
                self.contentHorizontalAlignment = aligment
            } else {
                let aligment = self.contentVerticalAlignment
                self.contentVerticalAlignment = aligment
            }
        }
    }

    @objc private lazy dynamic var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.axis = .horizontal
        self.addSubview(stackView)
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    @objc lazy dynamic var iconImg: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        self.contentView.addSubview(imageView)
        return imageView
    }()

    @objc public lazy dynamic var titleLb: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        self.contentView.addSubview(label)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    public override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        willSet {
            switch newValue {
            case .left:
                contentView.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentInset.left)
                    make.top.equalTo(contentInset.top)
                    make.bottom.equalTo(-contentInset.bottom)
                    make.right.lessThanOrEqualTo(-contentInset.right)
                }
            case .right:
                contentView.snp.remakeConstraints { (make) in
                    make.left.greaterThanOrEqualTo(contentInset.left)
                    make.top.equalTo(contentInset.top)
                    make.bottom.equalTo(-contentInset.bottom)
                    make.right.equalTo(-contentInset.right)
                }
            case .center:
                contentView.snp.remakeConstraints { (make) in
                    make.center.equalToSuperview()

                    make.left.greaterThanOrEqualTo(contentInset.left)
                    make.top.greaterThanOrEqualTo(contentInset.top)
                }
            case .fill:
                contentView.snp.remakeConstraints { (make) in
                    make.centerY.equalToSuperview()

                    make.left.equalTo(contentInset.left)
                    make.right.equalTo(-contentInset.right)
                    make.top.greaterThanOrEqualTo(contentInset.top)
                }
            default:
                break;
            }
        }
    }

    public override var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        willSet {
            switch newValue {
            case .top:
                contentView.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentInset.left)
                    make.top.equalTo(contentInset.top)
                    make.right.equalTo(-contentInset.right)
                    make.bottom.lessThanOrEqualTo(-contentInset.bottom)
                }
            case .bottom:
                contentView.snp.remakeConstraints { (make) in
                    make.left.equalTo(contentInset.left)
                    make.top.greaterThanOrEqualTo(contentInset.top)
                    make.right.equalTo(-contentInset.right)
                    make.bottom.equalTo(-contentInset.bottom)
                }
            case .center:
                contentView.snp.remakeConstraints { (make) in
                    make.center.equalToSuperview()

                    make.left.greaterThanOrEqualTo(contentInset.left)
                    make.top.greaterThanOrEqualTo(contentInset.top)
                    make.right.lessThanOrEqualTo(-contentInset.right)
                    make.bottom.lessThanOrEqualTo(-contentInset.bottom)
                }
            case .fill:
                contentView.snp.remakeConstraints { (make) in
                    make.edges.equalTo(contentInset)
                }
            default:
                break;
            }
        }
    }

    public init(alignType: ZLContentAlignType = .imageLeft) {
        super.init(frame: CGRect())

        setupSubViews()

        self.alignType = alignType

        if alignType == .imageLeft || alignType == .imageRight {
            self.contentView.axis = .horizontal
            self.contentHorizontalAlignment = .fill
        } else {
            self.contentView.axis = .vertical
            self.contentVerticalAlignment = .fill
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private dynamic func setupSubViews() {
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentInset)
        }
    }

    @objc open dynamic var image: UIImage? {
        didSet {
            self.iconImg.image = image

            if let _ = image {
                if alignType == .imageTop || alignType == .imageLeft {
                    self.contentView.insertArrangedSubview(self.iconImg, at: 0)
                } else {
                    self.contentView.addArrangedSubview(self.iconImg)
                }
            } else {
                self.contentView.removeArrangedSubview(self.iconImg)
                self.iconImg.removeFromSuperview()
            }
        }
    }

    @objc public dynamic var title: String? {
        didSet {
            self.titleLb.text = title
            if title == nil {
                self.contentView.removeArrangedSubview(self.titleLb)
                self.titleLb.removeFromSuperview()
            } else {
                if alignType == .imageBottom || alignType == .imageRight {
                    self.contentView.insertArrangedSubview(self.titleLb, at: 0)
                } else {
                    self.contentView.addArrangedSubview(self.titleLb)
                }
            }
        }
    }

    @objc public dynamic var attributedTitle: NSAttributedString? {
        didSet {
            self.titleLb.attributedText = attributedTitle
            if attributedTitle == nil {
                self.contentView.removeArrangedSubview(self.titleLb)
                self.titleLb.removeFromSuperview()
            } else {
                if alignType == .imageBottom || alignType == .imageRight {
                    self.contentView.insertArrangedSubview(self.titleLb, at: 0)
                } else {
                    self.contentView.addArrangedSubview(self.titleLb)
                }
            }
        }
    }

    @objc public dynamic var gap: CGFloat = 3 {
        didSet {
            self.contentView.spacing = gap
        }
    }
}
