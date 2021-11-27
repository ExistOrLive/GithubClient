//
//  ZLLanguageView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import Foundation

protocol ZLLanguageViewDelegate: AnyObject {
    var selectIndex: Int {get}
    func onButtonClicked(index: Int)
}

class ZLLanguageView: UIView {
    
    private lazy var buttons: [UIButton] = {
       
        let button1 = UIButton(type: .custom)
        button1.setTitle(ZLLocalizedString(string: "FollowSystemSetting", comment: ""), for: .normal)
        button1.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button1.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button1.backgroundColor = .clear
        button1.contentHorizontalAlignment = .left
        button1.tag = 0
        
        let button2 = UIButton(type: .custom)
        button2.setTitle(ZLLocalizedString(string: "English", comment: ""), for: .normal)
        button2.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button2.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button2.backgroundColor = .clear
        button2.contentHorizontalAlignment = .left
        button2.tag = 1
        
        let button3 = UIButton(type: .custom)
        button3.setTitle(ZLLocalizedString(string: "SimpleChinese", comment: ""), for: .normal)
        button3.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button3.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button3.backgroundColor = .clear
        button3.contentHorizontalAlignment = .left
        button3.tag = 2
        
        return [button1,button2,button3]
    }()
    
    private lazy var seletedTags: [UILabel] = {
        let label1 = UILabel()
        label1.text = ZLIconFont.RoundSelected.rawValue
        label1.font = .zlIconFont(withSize: 20)
        label1.textColor = UIColor(named: "ICON_SelectedColor")
        label1.tag = 0
        
        let label2 = UILabel()
        label2.text = ZLIconFont.RoundSelected.rawValue
        label2.font = .zlIconFont(withSize: 20)
        label2.textColor = UIColor(named: "ICON_SelectedColor")
        label2.tag = 1
        
        let label3 = UILabel()
        label3.text = ZLIconFont.RoundSelected.rawValue
        label3.font = .zlIconFont(withSize: 20)
        label3.textColor = UIColor(named: "ICON_SelectedColor")
        label3.tag = 2
        
        return [label1,label2,label3]
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 10
        return view
    }()
    
    private weak var delegate: ZLLanguageViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(180)
        }
        
        for seletedTag in seletedTags {
            containerView.addSubview(seletedTag)
            seletedTag.isHidden = true
        }
        
        for button in buttons {
            containerView.addSubview(button)
            button.addTarget(self, action: #selector(onButtonClicked(button:)), for: .touchUpInside)
        }
        
        buttons[0].snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
        }
        
        buttons[1].snp.makeConstraints { make in
            make.top.equalTo(buttons[0].snp.bottom)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
        }
        
        buttons[2].snp.makeConstraints { make in
            make.top.equalTo(buttons[1].snp.bottom)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(60)
            make.bottom.equalToSuperview()
        }
        
        seletedTags[0].snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(buttons[0])
            make.right.equalTo(buttons[0])
        }
        
        seletedTags[1].snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(buttons[1])
            make.right.equalTo(buttons[1])
        }
        
        seletedTags[2].snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalTo(buttons[2])
            make.right.equalTo(buttons[2])
        }
        
        let singleLineView1 = UIView()
        singleLineView1.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        containerView.addSubview(singleLineView1)
        singleLineView1.snp.makeConstraints { make in
            make.left.bottom.equalTo(buttons[0])
            make.right.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
        
        let singleLineView2 = UIView()
        singleLineView2.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        containerView.addSubview(singleLineView2)
        singleLineView2.snp.makeConstraints { make in
            make.left.bottom.equalTo(buttons[1])
            make.right.equalToSuperview()
            make.height.equalTo(1.0 / UIScreen.main.scale)
        }
    }
    

    @objc private func onButtonClicked(button: UIButton){
        let tag = button.tag
        
        for seletedTag in seletedTags {
            seletedTag.isHidden = seletedTag.tag != tag
        }
        
        delegate?.onButtonClicked(index: tag)
    }
    
    func fillWithData(data: ZLLanguageViewDelegate) {
        self.delegate = data
        
        for seletedTag in seletedTags {
            seletedTag.isHidden = seletedTag.tag != data.selectIndex
        }
    }
}
