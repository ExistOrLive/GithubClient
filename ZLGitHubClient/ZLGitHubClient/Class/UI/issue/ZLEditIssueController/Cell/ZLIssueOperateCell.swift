//
//  ZLIssueOperateCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/9.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueOperateCellDataSource {
   
    var opeationType: ZLEditIssueOperationType { get }
    
    var on: Bool { get }
    
    var clickBlock: ((UIButton) -> Void)? { get }
}

class ZLIssueOperateCell: UITableViewCell {
    
    var clickBlock: ((UIButton) -> Void)?
    var opeationType: ZLEditIssueOperationType = .subscribe
    var on: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private var button: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true 
        return button
    }()
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 250, height: 45))
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
    }
    
    @objc private func onButtonClicked(button: UIButton) {
        clickBlock?(button)
    }
    
    override func tintColorDidChange() {
        switch opeationType {
        case .subscribe:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Unsubscribe", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Subscribe", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            }
        case .lock:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Unlock", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Lock", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            }
        case .closeOrOpen:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Close", comment: ""), for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "WarningOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Reopen", comment: ""), for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "RecommandOperationColor")), for: .normal)
            }
        }
    }
}

extension ZLIssueOperateCell: ViewUpdatable {
    
    func fillWithData(viewData: ZLIssueOperateCellDataSource) {
        clickBlock = viewData.clickBlock
        opeationType = viewData.opeationType
        on = viewData.on
        
        switch viewData.opeationType {
        case .subscribe:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Unsubscribe", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Subscribe", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            }
        case .lock:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Unlock", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Lock", comment: ""), for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setTitleColor(.white, for: .normal)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "CommonOperationColor")), for: .normal)
            }
        case .closeOrOpen:
            if on {
                button.setTitle(ZLLocalizedString(string: "Issue_Close", comment: ""), for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "WarningOperationColor")), for: .normal)
            } else {
                button.setTitle(ZLLocalizedString(string: "Issue_Reopen", comment: ""), for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.titleLabel?.font = .zlMediumFont(withSize: 14)
                button.setBackgroundImage(UIImage(color:UIColor.back(withName: "RecommandOperationColor")), for: .normal)
            }
        }
    }
}
