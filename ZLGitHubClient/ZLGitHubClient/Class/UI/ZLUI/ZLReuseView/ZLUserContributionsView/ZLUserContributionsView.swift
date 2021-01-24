//
//  ZLUserContributionsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/22.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLUserContributionsView: ZLBaseView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    // model
    private var loginName  = ""
    private var dataArray : [ZLGithubUserContributionData] = []
    
    // view
    private var collectionView : UICollectionView!
    private var label : UILabel!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        collectionView.snp.updateConstraints { (make) in
            make.width.equalTo(collectionView.contentSize.width).priority(.high)
        }
    }
    
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    private func setUpUI() {
        
        self.backgroundColor = UIColor(named: "ZLContributionBackColor")
       
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = CGSize(width: 10, height: 10)
        collectionViewLayout.minimumInteritemSpacing = 2
        collectionViewLayout.minimumLineSpacing = 2
        self.collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewLayout)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.width.equalTo(collectionView.contentSize.width).priority(.high)
        }
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        label = UILabel()
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func startLoad(loginName : String) {
        
        self.loginName = loginName
        
        ZLServiceManager.sharedInstance.userServiceModel?.getUserContributionsData(withLoginName: loginName,
                                                                                   serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel) in
            
            if resultModel.result == true {
                if let array = resultModel.data as? [ZLGithubUserContributionData] {
                    self?.dataArray = array
                } else {
                    self?.dataArray = []
                }
            } else {
                self?.dataArray = []
            }
            self?.collectionView.reloadData()
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        self.label.text = self.dataArray.count == 0  ? "No Data" : nil
        return self.dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        collectionViewCell.cornerRadius = 2.0
        let contributionData = self.dataArray[indexPath.row]
        if contributionData.contributionsNumber == 0 {
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor1")
        } else if contributionData.contributionsNumber <= 5 {
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor2")
        } else if contributionData.contributionsNumber <= 10 {
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor3")
        } else if contributionData.contributionsNumber <= 20 {
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor4")
        } else {
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor5")
        }
        
        
        return collectionViewCell
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.setNeedsUpdateConstraints()
    }
}
