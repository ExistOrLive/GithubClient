//
//  ZLRepoHeaderInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc enum ZLRepoHeaderInfoViewEvent : Int {         // 在enum之前加@objc 可以转换为objc enum
    case issue = 1
    case star = 2
    case copy = 3
    case watch = 4
}

@objc protocol ZLRepoHeaderInfoViewDelegate: NSObjectProtocol
{
    func onZLRepoHeaderInfoViewEvent(event: ZLRepoHeaderInfoViewEvent)
}

class ZLRepoHeaderInfoView: ZLBaseView {

    @IBOutlet  weak var headImageView: UIImageView!
    @IBOutlet  weak var repoNameLabel: UILabel!
    @IBOutlet  weak var timeLabel: UILabel!
    @IBOutlet  weak var descLabel: UILabel!
    
    @IBOutlet private weak var issuesButton: UIButton!
    @IBOutlet private weak var starsButton: UIButton!
    @IBOutlet private weak var forksButton: UIButton!
    @IBOutlet private weak var watchersButton: UIButton!
    
    @IBOutlet weak var issuesNumLabel: UILabel!
    @IBOutlet weak var starsNumLabel: UILabel!
    @IBOutlet weak var forksNumLabel: UILabel!
    @IBOutlet weak var watchersNumLabel: UILabel!
    
    weak var delegate : ZLRepoHeaderInfoViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headImageView.layer.cornerRadius = 30.0
        self.headImageView.layer.masksToBounds = true
        
        self.issuesButton.setTitle(ZLLocalizedString(string: "issues", comment: "问题"), for: .normal)
        self.starsButton.setTitle(ZLLocalizedString(string: "star", comment: "标星"), for: .normal)
        self.forksButton.setTitle(ZLLocalizedString(string: "fork", comment: "拷贝"), for: .normal)
        self.watchersButton.setTitle(ZLLocalizedString(string: "watcher", comment: "关注"), for:.normal)
    }
    
    
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        if self.delegate?.responds(to: #selector(ZLRepoHeaderInfoViewDelegate.onZLRepoHeaderInfoViewEvent(event:))) ?? false
        {
            self.delegate?.onZLRepoHeaderInfoViewEvent(event: ZLRepoHeaderInfoViewEvent.init(rawValue: sender.tag) ?? .issue)
        }
        
    }
    
}
