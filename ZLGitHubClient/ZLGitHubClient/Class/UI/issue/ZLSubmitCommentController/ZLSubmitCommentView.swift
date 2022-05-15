//
//  ZLSubmitCommentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/26.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import SnapKit
import RxSwift
import RxCocoa

protocol ZLSubmitCommentViewDelegate: NSObjectProtocol {
    
    func onCancelButtonClicked()
    
    func onSubmitButtonClicked(comment: String)
    
    var clearObservable: Observable<Void> { get }
}


class ZLSubmitCommentView: ZLBaseView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private weak var delagate: ZLSubmitCommentViewDelegate?
    
    private let disposeBag = DisposeBag()
    
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
        
        cancelButton.rx.tap.subscribe(onNext: { [weak self]_ in
            self?.delagate?.onCancelButtonClicked()
        },
                                      onError: nil,
                                      onCompleted: nil,
                                      onDisposed: nil)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap.subscribe(onNext: { [weak self]_ in
            guard let self = self,
                  let comment = self.textView.text else { return }
            if comment.isEmpty {
                ZLToastView.showMessage("Comment is Empty")
                return
            }
            self.delagate?.onSubmitButtonClicked(comment: comment)
        },
                                      onError: nil,
                                      onCompleted: nil,
                                      onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    // MARK: Lazy View
    
    private lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
       let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "Cancel", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.zlRegularFont(withSize: 14)
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = ZLBaseButton()
        button.setTitle(ZLLocalizedString(string: "submit", comment: ""), for: .normal)
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
    
    
    private lazy var textView: UITextView = {
       let textView = UITextView()
        textView.placeholder = ZLLocalizedString(string: "EnterComment", comment: "")
        textView.font = UIFont.zlRegularFont(withSize: 13)
        textView.textAlignment = .left
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false 
        return textView
    }()
}

extension ZLSubmitCommentView: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData: ZLSubmitCommentViewDelegate) {
        delagate = viewData
        viewData.clearObservable.subscribe(onNext: { [weak self] _ in
            self?.textView.text = nil
        }).disposed(by:disposeBag)
    }
}
