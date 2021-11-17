//
//  ZLWorkflowTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLWorkflowTableViewCellDelegate : NSObjectProtocol {
    func onConfigButtonClicked() -> Void
}

class ZLWorkflowTableViewCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()
    
    private lazy var workflowTag: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.Workflow.rawValue
        label.font = UIFont.zlIconFont(withSize: 25)
        label.textColor = UIColor(named: "ICON_Common")
        return label
    }()
    
    private lazy var workflowTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var workflowStateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont.zlRegularFont(withSize: 15)
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var configButton: UIButton = {
        let button = ZLBaseButton()
        let title = NSAttributedString(string:ZLLocalizedString(string: "config", comment: ""),
                                       attributes: [.font:UIFont.zlSemiBoldFont(withSize: 14),
                                                    .foregroundColor:UIColor.label(withName: "ZLLabelColor1")])
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    weak var delegate : ZLWorkflowTableViewCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        
        containerView.addSubview(workflowTag)
        workflowTag.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        containerView.addSubview(workflowTitleLabel)
        workflowTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerY.equalTo(workflowTag)
            make.left.equalTo(workflowTag.snp.right).offset(10)
        }
        
        containerView.addSubview(workflowStateLabel)
        workflowStateLabel.snp.makeConstraints { make in
            make.left.equalTo(workflowTitleLabel)
            make.top.equalTo(workflowTitleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-15)
        }
        
        containerView.addSubview(configButton)
        configButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 35))
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.left.equalTo(workflowTitleLabel.snp.right).offset(10)
            make.left.equalTo(workflowStateLabel.snp.right).offset(10)
        }
        configButton.addTarget(self, action: #selector(onConfigButtonClicked(_:)), for: .touchUpInside)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    @objc func onConfigButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLWorkflowTableViewCellDelegate.onConfigButtonClicked)) ?? false {
            self.delegate?.onConfigButtonClicked()
        }
    }
    
    func fillWithData(cellData : ZLWorkflowTableViewCellData) {
        self.workflowTitleLabel.text = cellData.getWorkflowTitle()
        self.workflowStateLabel.text = cellData.getWorkflowState()
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
}
