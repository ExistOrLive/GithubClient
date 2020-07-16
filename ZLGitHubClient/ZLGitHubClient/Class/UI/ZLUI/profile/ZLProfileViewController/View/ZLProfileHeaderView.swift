//
//  ZLProfileHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLProfileHeaderViewButtonType: Int {
    case repositories = 0
    case gists
    case followers
    case following
    case editProfile
    case allUpdate
}

@objc protocol ZLProfileHeaderViewDelegate: NSObjectProtocol {
    func onProfileHeaderViewButtonClicked(button: UIButton)
    
    func numberOfEvent() -> Int
    
    func cellDataForEventAtIndex(index: Int) -> ZLProfileEventCollectionViewCellData
}

class ZLProfileHeaderView: ZLBaseView {
    
    weak var delegate : ZLProfileHeaderViewDelegate?

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    
    @IBOutlet weak var repositoryNum: UILabel!
    @IBOutlet weak var gistNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var latestModifiedView: UIView!
    
    @IBOutlet weak var repositoriesButton: UIButton!
    @IBOutlet weak var gistsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    @IBOutlet weak var allUpdateButton: UIButton!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.headImageView.layer.cornerRadius = 30.0;
        self.latestModifiedView.layer.cornerRadius = 10.0
        
        self.collectionViewLayout.minimumInteritemSpacing = 10
        self.collectionViewLayout.itemSize = CGSize.init(width: 200, height: 105)
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.contentInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.register(UINib.init(nibName: "ZLProfileEventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ZLProfileEventCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.init(hexString: "F6F6F6", alpha: 1.0)
        
       
        
        self.justReloadView();
    }
    
    
    @IBAction func onProfileHeaderViewButtonClicked(_ sender: Any) {
        
        if self.delegate?.responds(to: #selector(ZLProfileHeaderViewDelegate.onProfileHeaderViewButtonClicked(button:))) ?? false
        {
            let button = sender as! UIButton
            self.delegate?.onProfileHeaderViewButtonClicked(button: button)
        }
        
    }
    
    
    
    func reloadViewWithData()
    {
        self.collectionView .reloadData()
    }
    
    func justReloadView()
    {
        self.repositoriesButton.setTitle(ZLLocalizedString(string: "repositories",comment: "仓库"), for: UIControl.State.normal);
        self.gistsButton.setTitle(ZLLocalizedString(string: "gists",comment: "代码片段"), for: UIControl.State.normal);
        self.followersButton.setTitle(ZLLocalizedString(string: "followers",comment: "粉丝"), for: UIControl.State.normal);
        self.followingButton.setTitle(ZLLocalizedString(string: "following",comment: "关注"), for: UIControl.State.normal);
        
        self.latestUpdateLabel.text = ZLLocalizedString(string: "lastest update", comment: "最近修改")
        self.allUpdateButton.setTitle(ZLLocalizedString(string: "all update", comment: "查看全部修改"), for: .normal)
    }
}


extension ZLProfileHeaderView : UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.delegate?.responds(to: #selector(ZLProfileHeaderViewDelegate.numberOfEvent)) ?? false
        {
            return self.delegate?.numberOfEvent() ?? 0
        }
        else
        {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZLProfileEventCollectionViewCell", for: indexPath) as? ZLProfileEventCollectionViewCell
        
        if self.delegate?.responds(to: #selector(ZLProfileHeaderViewDelegate.cellDataForEventAtIndex(index:))) ?? false
        {
            let cellData = self.delegate?.cellDataForEventAtIndex(index: indexPath.row)
            collectionCell?.fillWithData(data: cellData)
        }
        
        return collectionCell!
    }
    
    
}
