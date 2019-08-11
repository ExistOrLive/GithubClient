//
//  ZLSearchItemsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchItemsView: ZLBaseView {

    @IBOutlet weak var searchTypeCollectionView: UICollectionView!
    @IBOutlet weak var searchTypeCollectionLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var indicatorBackView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.searchTypeCollectionLayout.itemSize = CGSize.init(width: 70, height: 60)
        self.searchTypeCollectionView.register(UINib.init(nibName: "ZLSearchTypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ZLSearchTypeCollectionViewCell");
        self.searchTypeCollectionView.showsHorizontalScrollIndicator = false
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib.init(nibName: "ZLUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLUserTableViewCell")
        self.tableView.register(UINib.init(nibName: "ZLRepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepositoryTableViewCell")
        
    }
    
    
    
}
