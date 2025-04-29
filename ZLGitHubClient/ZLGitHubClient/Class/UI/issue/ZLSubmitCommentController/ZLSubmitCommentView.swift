//
//  ZLSubmitCommentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/26.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import SnapKit
import ZMMVVM

protocol ZLSubmitCommentViewDelegate: NSObjectProtocol {
    
    func onCancelButtonClicked()
    
    func onSubmitButtonClicked(comment: String)
}


class ZLSubmitCommentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: ZLSubmitCommentViewDelegate? {
        zm_viewModel as? ZLSubmitCommentViewDelegate
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(headerView)
        headerView.addSubview(cancelButton)
        headerView.addSubview(titleLabel)
        headerView.addSubview(submitButton)
        addSubview(textView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
            make.left.equalTo(80)
            make.right.equalTo(-80)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 30))
            make.bottom.equalTo(-15)
            make.left.equalTo(10)
        }
        
        submitButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 30))
            make.bottom.equalTo(-15)
            make.right.equalTo(-10)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    // MARK: Lazy View
    
    private lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
       let button = ZMButton()
        button.setTitle(ZLLocalizedString(string: "Cancel", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        button.addTarget(self, action: #selector(onCancelButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = ZMButton()
        button.setTitle(ZLLocalizedString(string: "submit", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(onSubmitButtonClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
         return button
    }()
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(named: "ZLNavigationBarTitleColor")
        label.font = UIFont(name:Font_PingFangSCMedium , size: 18)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.text = ZLLocalizedString(string: "Comment", comment: "")
        return label
    }()
    
    
    lazy var textView: UITextView = {
       let textView = UITextView()
        textView.placeholder = ZLLocalizedString(string: "EnterComment", comment: "")
        textView.font = UIFont.zlRegularFont(withSize: 13)
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false 
        return textView
    }()
}

extension ZLSubmitCommentView {
    @objc func onCancelButtonClicked() {
        delegate?.onCancelButtonClicked()
    }
    
    @objc func onSubmitButtonClicked() {
        guard let comment = self.textView.text else { return }
        if comment.isEmpty {
            ZLToastView.showMessage(ZLLocalizedString(string: "Comment is Empty", comment: "Comment is Empty"))
            return
        }
        self.textView.resignFirstResponder()
        self.delegate?.onSubmitButtonClicked(comment: comment)
    }
}


extension ZLSubmitCommentView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLSubmitCommentViewDelegate) {

    }
}
