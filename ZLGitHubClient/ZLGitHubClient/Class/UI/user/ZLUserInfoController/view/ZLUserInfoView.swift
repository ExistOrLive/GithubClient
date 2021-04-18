//
//  ZLUserInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

protocol ZLUserInfoViewDelegateAndDataSource: ZLReadMeViewDelegate{
    
    var login: String? {get}
    var name: String? {get}
    var avatarURL: String? {get}
    var createTimeStr: String? {get}
    var bio: String? {get}
    var repositoryNum: Int {get}
    var gistsNum: Int {get}
    var followersNum: Int {get}
    var followingNum: Int {get}
    
    var company: String? {get}
    var address: String? {get}
    var email: String? {get}
    var blog: String? {get}
    
    
    func onRepositoriesButtonClicked()
    func onGistsButtonClicked()
    func onFollowersButtonClicked()
    func onFollowingsButtonClicked()
    func onBlockButtonClicked(button: UIButton)
    func onFollowActionButtonClicked(button: UIButton)
    
    func onEmailButtonClicked()
    func onBlogButtonClicked()

}


class ZLUserInfoView: ZLBaseView {
    
    weak var delegate: ZLUserInfoViewDelegateAndDataSource?
    
    @IBOutlet weak private var headImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var createTimeLabel: UILabel!
    @IBOutlet weak private var bioLabel: UILabel!
    
    @IBOutlet weak private var repositoryNum: UILabel!
    @IBOutlet weak private var gistNumLabel: UILabel!
    @IBOutlet weak private var followersNumLabel: UILabel!
    @IBOutlet weak private var followingNumLabel: UILabel!
    
    @IBOutlet weak private var repositoriesButton: UIButton!
    @IBOutlet weak private var gistsButton: UIButton!
    @IBOutlet weak private var followersButton: UIButton!
    @IBOutlet weak private var followingButton: UIButton!
    
    @IBOutlet weak private var companyLabel: UILabel!
    @IBOutlet weak private var addrLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var blogLabel: UILabel!
    
    @IBOutlet weak private var companyInfoLabel: UILabel!
    @IBOutlet weak private var addressInfoLabel: UILabel!
    @IBOutlet weak private var emailInfoLabel: UILabel!
    @IBOutlet weak private var blogInfoLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    @IBOutlet weak private var itemStackView: UIStackView!
    
    @IBOutlet weak var contributionsView: ZLUserContributionsView!
    
    var readMeView : ZLReadMeView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let readMeView : ZLReadMeView = Bundle.main.loadNibNamed("ZLReadMeView", owner: nil, options: nil)?.first as? ZLReadMeView else {
            return
        }
        self.addSubview(readMeView)
        readMeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.itemStackView.snp_bottom).offset(10)
        }
        self.readMeView = readMeView
        
        self.justUpdate();
        
    }
    
    func justUpdate()
    {
        repositoriesButton.setTitle(ZLLocalizedString(string: "repositories",comment: "仓库"), for: .normal);
        gistsButton.setTitle(ZLLocalizedString(string: "gists",comment: "代码片段"), for: .normal);
        followersButton.setTitle(ZLLocalizedString(string: "followers",comment: "粉丝"), for: .normal);
        followingButton.setTitle(ZLLocalizedString(string: "following",comment: "关注"), for: .normal);
        companyLabel.text = ZLLocalizedString(string:"company", comment: "公司")
        addrLabel.text = ZLLocalizedString(string:"location", comment: "地址")
        emailLabel.text = ZLLocalizedString(string:"email", comment: "邮箱")
        blogLabel.text = ZLLocalizedString(string:"blog", comment: "博客")
        
        followButton.setTitle(ZLLocalizedString(string: "Follow", comment: ""), for: .normal)
        followButton.setTitle(ZLLocalizedString(string: "Unfollow", comment: "Unfollow"), for: .selected)
        
        
        blockButton.setTitle(ZLLocalizedString(string: "Block", comment: ""), for: .normal)
        blockButton.setTitle(ZLLocalizedString(string: "Unblock", comment: "Unblock"), for: .selected)
        
        createTimeLabel.text = delegate?.createTimeStr
        
        readMeView?.justUpdate()
        
    }
        
    func fillWithData(delegateAndDataSource: ZLUserInfoViewDelegateAndDataSource){
        delegate = delegateAndDataSource
        readMeView?.delegate = delegateAndDataSource

        reloadData()
        
        if let login = delegate?.login {
            contributionsView.startLoad(loginName: login)
            readMeView?.startLoad(fullName: "\(login)/\(login)", branch: nil)
        }
    }
    
    func reloadData(){
        
        headImageView.sd_setImage(with: URL.init(string: delegate?.avatarURL ?? ""), placeholderImage: UIImage.init(named: "default_avatar"));
        nameLabel.text = "\(delegate?.name ?? "")(\(delegate?.login ?? ""))"
        createTimeLabel.text = delegate?.createTimeStr
        bioLabel.text = delegate?.bio
        
        repositoryNum.text = "\(delegate?.repositoryNum ?? 0)"
        gistNumLabel.text = "\(delegate?.gistsNum ?? 0)"
        followersNumLabel.text = "\(delegate?.followersNum ?? 0)"
        followingNumLabel.text = "\(delegate?.followingNum ?? 0)"
        
        companyInfoLabel.text = delegate?.company
        addressInfoLabel.text = delegate?.address
        emailInfoLabel.text = delegate?.email
        blogInfoLabel.text = delegate?.blog
        
    }
    
    
    //MARK:
    
    
    @IBAction func onRepoButtonClicked(_ sender: Any) {
        delegate?.onRepositoriesButtonClicked()
    }
    
    
    @IBAction func onGistsButtonClicked(_ sender: Any) {
        delegate?.onGistsButtonClicked()
    }
    
    
    @IBAction func onFollowersButtonClicked(_ sender: Any) {
        delegate?.onFollowersButtonClicked()
    }
    
    
    @IBAction func onFollowingsButtonClicked(_ sender: Any) {
        delegate?.onFollowingsButtonClicked()
    }
    
    
    @IBAction func onFollowButtonClicked(_ sender: UIButton) {
        delegate?.onFollowActionButtonClicked(button: sender)
    }
    
    
    @IBAction func onBlockButtonClicked(_ sender: UIButton) {
        delegate?.onBlockButtonClicked(button: sender)
    }
    
    
    @IBAction func onEmailButtonClicked(_ sender: Any) {
        delegate?.onEmailButtonClicked()
    }
    
    @IBAction func onBlogButtonClicked(_ sender: Any) {
        delegate?.onBlogButtonClicked()
    }
    
}

