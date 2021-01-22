//
//  ZLAppearanceController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLAppearanceController: ZLBaseViewController {
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var seletedTags: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "Appearance", comment: "")
        
        guard let view : UIView = Bundle.main.loadNibNamed("ZLAppearanceView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        
        buttons[0].setTitle(ZLLocalizedString(string: "FollowSystemSetting", comment: ""), for: .normal)
        buttons[1].setTitle(ZLLocalizedString(string: "Light Mode", comment: ""), for: .normal)
        buttons[2].setTitle(ZLLocalizedString(string: "Dark Mode", comment: ""), for: .normal)
        
        if #available(iOS 13.0, *){
            let interfaceStyle = ZLSharedDataManager.sharedInstance().currentUserInterfaceStyle
            for seletedTag in seletedTags{
                seletedTag.isHidden = (seletedTag.tag != interfaceStyle.rawValue)
            }
        }
    }
    
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        if #available(iOS 13.0, *){
            let interfaceStyle : UIUserInterfaceStyle  = UIUserInterfaceStyle.init(rawValue: sender.tag) ?? UIUserInterfaceStyle.unspecified
            UIApplication.shared.delegate?.window??.overrideUserInterfaceStyle = interfaceStyle
            ZLSharedDataManager.sharedInstance().currentUserInterfaceStyle = interfaceStyle
            for seletedTag in seletedTags{
                seletedTag.isHidden = (seletedTag.tag != interfaceStyle.rawValue)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
