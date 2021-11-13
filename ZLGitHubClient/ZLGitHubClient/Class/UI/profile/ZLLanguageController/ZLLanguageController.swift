//
//  ZLAppearanceController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLLanguageController: ZLBaseViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var seletedTags: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "Language", comment: "")
        
        guard let view : UIView = Bundle.main.loadNibNamed("ZLLanguageView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.top.bottom.equalTo(self.contentView)
        }
        
        
        buttons[0].setTitle(ZLLocalizedString(string: "FollowSystemSetting", comment: ""), for: .normal)
        buttons[1].setTitle(ZLLocalizedString(string: "English", comment: ""), for: .normal)
        buttons[2].setTitle(ZLLocalizedString(string: "SimpleChinese", comment: ""), for: .normal)
        
        let languageChoice = LANMODULE?.currentLanguageType() ?? ZLLanguageType.auto
        
        for seletedTag in seletedTags{
            seletedTag.isHidden = (languageChoice.rawValue + 1 != seletedTag.tag)
        }
    
    }
    
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        guard let languageChoice = ZLLanguageType(rawValue: sender.tag - 1) else {
            return
        }
        for seletedTag in seletedTags{
            seletedTag.isHidden =  (seletedTag.tag != sender.tag)
        }
        LANMODULE?.setLanguageType(languageChoice, error: nil)

        self.title = ZLLocalizedString(string: "Language", comment: "")
        buttons[0].setTitle(ZLLocalizedString(string: "FollowSystemSetting", comment: ""), for: .normal)
        buttons[1].setTitle(ZLLocalizedString(string: "English", comment: ""), for: .normal)
        buttons[2].setTitle(ZLLocalizedString(string: "SimpleChinese", comment: ""), for: .normal)

        self.navigationController?.popViewController(animated: true)
    }
    
}
