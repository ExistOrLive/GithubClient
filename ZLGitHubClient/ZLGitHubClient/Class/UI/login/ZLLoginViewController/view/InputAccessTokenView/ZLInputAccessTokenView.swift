//
//  ZLInputAccessTokenView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/6/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLBaseUI
import ZLGitRemoteService
import Foundation

class ZMPopContainerViewDelegate_AccessToken: NSObject, ZMPopContainerViewDelegate {

    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }
    
    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        return ZLScreenBoundsAdjustWithScreenOrientation
    }
    
    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        guard let contentView = view.content else {
            return .zero
        }
        let origin = CGPoint(x: (view.frame.width - contentView.frame.width) / 2,
                             y: 200)
        return CGRect(origin: origin, size: contentView.frame.size)
    }
    
    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        guard let contentView = view.content else {
            return .zero
        }
        let origin = CGPoint(x: (view.frame.width - contentView.frame.width) / 2 ,
                             y: 0 - contentView.frame.size.height )
        return CGRect(origin: origin, size: contentView.frame.size)
    }
    
}


class ZLInputAccessTokenView: ZLBaseView {
    
    weak var popView: ZMPopContainerView?
    var resultBlock: ((String?) -> Void)?

    static func showInputAccessTokenView(resultBlock: @escaping ((String?) -> Void) ) {
        
        guard let window = ZLMainWindow else { return }
        
        let view = ZLInputAccessTokenView()
        view.resultBlock = resultBlock
        
        let popView = ZMPopContainerView()
        view.popView = popView
        popView.frame = UIScreen.main.bounds
        popView.popDelegate = view.popDelegateAccessToken
        popView.show(window,
                     contentView: view,
                     contentInitFrame: CGRect(x: (ZLKeyWindowWidth - 300.0) / 2.0,
                                              y: -190,
                                              width: 300,
                                              height: 190),
                     contentTargetFrame: CGRect(x: (ZLKeyWindowWidth - 300.0) / 2.0,
                                                y: 200,
                                                width: 300,
                                                height: 190),
                     animationDuration: 0.25,
                     completion: {
            view.textField.becomeFirstResponder()
        })
    }

    @objc func onConfirmButtonClicked(_ sender: Any) {
        resultBlock?(self.textField.text)
        popView?.dismiss()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        backgroundColor = UIColor(named: "ZLPopUpTitleBackView")
        layer.cornerRadius = 8
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(confirmButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(10)
        }
        
        textField.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 250, height: 40))
            make.bottom.equalTo(-20)
            make.centerX.equalToSuperview()
        }
        
        
    }
    
    lazy var popDelegateAccessToken: ZMPopContainerViewDelegate_AccessToken  = {
        ZMPopContainerViewDelegate_AccessToken()
    }()
    
    // MARK: Lazy View
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ZLLocalizedString(string: "Input Access Token",
                                       comment: "Input Access Token")
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = UIColor(named:"ZLPopUpTextFieldBackColor")
        textField.font = .zlRegularFont(withSize: 14)
        textField.textColor = UIColor(named: "ZLLabelColor1")
        textField.borderStyle = .roundedRect
        textField.placeholder = "Access Token"
        return textField
    }()
    
    lazy var confirmButton: UIButton = {
        let button = ZLBaseButton()
        button.titleLabel?.font = .zlMediumFont(withSize: 15)
        button.setTitle(ZLLocalizedString(string: "Confirm", comment: ""),
                        for: .normal)
        button.setTitleColor(UIColor(named: "ZLBaseButtonDisabledTitleColor"), for: .disabled)
        button.addTarget(self, action: #selector(onConfirmButtonClicked(_:)), for: .touchUpInside)
        button.isEnabled = false 
        return button
    }()
}

extension ZLInputAccessTokenView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }

        let textStr: NSString? = self.textField.text as NSString?
        let text: String = textStr?.replacingCharacters(in: range, with: string) ?? ""

        self.confirmButton.isEnabled = text.count > 0

        return true
    }

}
