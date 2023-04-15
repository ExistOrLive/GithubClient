//
//  ZLUserContributionsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/22.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseUI

class ZLUserContributionsView: ZLBaseView, UICollectionViewDataSource, UICollectionViewDelegate {

    // model
    private var loginName  = ""
    private var dataArray: [ZLGithubUserContributionData] = []

    // view
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.estimatedItemSize = CGSize(width: 10, height: 10)
        collectionViewLayout.minimumInteritemSpacing = 2
        collectionViewLayout.minimumLineSpacing = 2
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        return label
    }()

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
            make.width.equalTo(collectionView.contentSize.width + 10).priority(.high)
        }
    }

    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }

    private func setUpUI() {

        self.backgroundColor = UIColor(named: "ZLContributionBackColor")

        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.width.equalTo(collectionView.contentSize.width + 10).priority(.high)
        }
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)

        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func update(loginName: String, force: Bool = false ) {

        if force ||
            loginName != self.loginName ||
            self.dataArray.isEmpty {

            self.startLoad(loginName: loginName)
        }
    }

    func startLoad(loginName: String) {

        self.loginName = loginName

        let contributionsDatas = ZLUserServiceShared()?
            .getUserContributionsData(withLoginName: loginName,
                                      serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel) in

            if resultModel.result == true {
                if let array = resultModel.data as? [ZLGithubUserContributionData] {
                    self?.dataArray = array
                    self?.collectionView.reloadData()
                }
            }

            self?.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.reloadData()
            } completion: { [weak self] _ in
                guard let self = self else {return}
                let count = self.dataArray.count
                if count > 0 && self.collectionView.contentOffset.x <= 0 {
                    let indexPath = IndexPath(row: count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
                }
            }
        }

        self.dataArray = contributionsDatas ?? []
        self.collectionView.reloadData()
        
        self.collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.reloadData()
        } completion: { [weak self] _ in
            guard let self = self else {return}
            let count = self.dataArray.count
            if count > 0 && self.collectionView.contentOffset.x <= 0 {
                let indexPath = IndexPath(row: count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.right, animated: false)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.label.text = self.dataArray.count == 0  ? "No Data" : nil
        return self.dataArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        collectionViewCell.cornerRadius = 2.0
        let contributionData = self.dataArray[indexPath.row]
        switch contributionData.contributionsLevel {
        case 0:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor1")
        case 1:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor2")
        case 2:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor3")
        case 3:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor4")
        case 4:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor5")
        default:
            collectionViewCell.backgroundColor = UIColor(named: "ZLContributionColor1")
        }
        return collectionViewCell
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        self.setNeedsUpdateConstraints()
    }
}
