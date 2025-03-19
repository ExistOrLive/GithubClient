//
//  ZLPinnedRepositoriesTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/12/5.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLBaseExtension

protocol ZLPinnedRepositoriesTableViewCellDelegateAndDataSource: AnyObject {
    var cellDatas: [ZLPinnedRepositoryCollectionViewCellDataSourceAndDelegate] {get}
}

class ZLPinnedRepositoriesTableViewCell: UITableViewCell {

    var delegate: ZLPinnedRepositoriesTableViewCellDelegateAndDataSource? {
        zm_viewModel as? ZLPinnedRepositoriesTableViewCellDelegateAndDataSource
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }

        collectionView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.top.equalTo(60)
            make.bottom.equalTo(-20)
            make.height.equalTo(180)
        }
    }

    // MARK: View

     lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300, height: 180)
        layout.minimumInteritemSpacing = 20
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = UIColor(named: "ZLVCBackColor")
        collectionView.register(ZLPinnedRepositoryCollectionViewCell.self, forCellWithReuseIdentifier: "ZLPinnedRepositoryCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ZLLocalizedString(string: "pinned", comment: "")
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.textColor = UIColor(named: "ZLLabelColor1")
       return label
    }()
}

extension ZLPinnedRepositoriesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.cellDatas.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellData = self.delegate?.cellDatas[indexPath.row] else {
            return UICollectionViewCell()
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellData.getCellReuseIdentifier(), for: indexPath) as? ZLPinnedRepositoryCollectionViewCell else {
            return  UICollectionViewCell()
        }

        cell.fillWithData(viewData: cellData)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellData = self.delegate?.cellDatas[indexPath.row] else {
            return
        }
        cellData.onCellSingleTap()
    }

}

extension ZLPinnedRepositoriesTableViewCell: ZMBaseViewUpdatableWithViewData {
   
    func zm_fillWithViewData(viewData: ZLPinnedRepositoriesTableViewCellDelegateAndDataSource) {
        self.collectionView.reloadData()
    }
}
