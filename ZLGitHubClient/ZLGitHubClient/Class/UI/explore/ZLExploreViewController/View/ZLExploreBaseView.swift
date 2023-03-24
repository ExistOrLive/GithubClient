//
//  ZLExploreBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

@objc protocol ZLExploreBaseViewDelegate {

    func exploreTypeTitles() -> [String]
    
    func segmentedListContainerViewListDelegate() -> [JXSegmentedListContainerViewListDelegate]
    
    func onSegmentViewSelectedIndex(segmentView: JXSegmentedView, index: Int)
    
    func onSearchButtonClicked()
}

@objcMembers class ZLExploreBaseView: UIView {
    
    weak var delegate: ZLExploreBaseViewDelegate? {
        didSet {
            let titles: [String] = self.delegate?.exploreTypeTitles() ?? []
            self.segmentedViewDatasource.titles = titles
            self.segmentedView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configSegmentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        
        addSubview(headerView)
        headerView.addSubview(trendingLabel)
        headerView.addSubview(segmentedView)
        headerView.addSubview(searchButton)
        
        addSubview(segmentedListContainerView)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.top).offset(60)
        }
        
        segmentedView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(35)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(headerView.snp.bottom).offset(-10)
        }
        
        trendingLabel.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.left.equalTo(20)
            make.centerY.equalTo(segmentedView)
        }
        
        searchButton.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.size.equalTo(30)
            make.centerY.equalTo(segmentedView)
        }
        searchButton.addTarget(self, action: #selector(onSearchButtonClicked(_ :)), for: .touchUpInside)
        
        segmentedListContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
    }
    
    
    func configSegmentView() {
        
        self.segmentedView.delegate = self
        self.segmentedView.dataSource = self.segmentedViewDatasource
        self.segmentedView.indicators = [indicator]
        self.segmentedView.listContainer = self.segmentedListContainerView

        self.justReloadView()
    }
    
    func justReloadView() {
        let titles: [String] = self.delegate?.exploreTypeTitles() ?? []
        self.segmentedViewDatasource.titles = titles
        self.segmentedView.reloadData()
    }

    func onSearchButtonClicked(_ sender: Any) {
        self.delegate?.onSearchButtonClicked()
    }
    
    
    // MARK: Lazy View
    lazy var headerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLNavigationBarBackColor")
        return view
    }()
    
    lazy var trendingLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 25)
        label.text = ZLIconFont.Trending.rawValue
        label.textColor = UIColor(named:"ZLLabelColor1")
        return label
    }()
    
    lazy var searchButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLIconFont.Search.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 25)
        button.setTitleColor(UIColor(named:"ZLLabelColor1"), for: .normal)
        return button
    }()
    
    lazy var segmentedListContainerView: JXSegmentedListContainerView = {
        JXSegmentedListContainerView(dataSource: self, type: .scrollView)
    }()
    
    lazy var segmentedViewDatasource: JXSegmentedTitleDataSource = {
    
        let dataSource = JXSegmentedTitleDataSource()
        
        dataSource.titles = []
        dataSource.titleNormalColor = UIColor.label(withName: "ZLLabelColor2")
        dataSource.titleSelectedColor = UIColor.label(withName: "ZLLabelColor1")
        dataSource.titleNormalFont = UIFont.zlRegularFont(withSize: 14.0)
        dataSource.titleSelectedFont = UIFont.zlSemiBoldFont(withSize: 16.0)
        dataSource.itemWidth = 100
        dataSource.itemSpacing = 0
        
        return dataSource 
    }()
    
    lazy var indicator: JXSegmentedIndicatorBackgroundView = {
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorColor = UIColor.init(named: "SegmentedViewBackIndicator") ?? UIColor.gray
        indicator.indicatorHeight = 31.0
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorWidth = 96.0
        indicator.indicatorCornerRadius = 8.0
        return indicator
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = UIColor(named:"SegmentedViewBack")
        segmentedView.cornerRadius = 8.0
        return segmentedView
    }()
    
}

// MARK: JXSegmentedViewDelegate
extension ZLExploreBaseView: JXSegmentedViewDelegate {

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.delegate?.onSegmentViewSelectedIndex(segmentView: segmentedView, index: index)
    }

    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {

    }

    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {

    }

    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {

    }

    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        return true
    }
}

// MARK: JXSegmentedListContainerViewDataSource
extension ZLExploreBaseView: JXSegmentedListContainerViewDataSource {

    /// 返回list的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.delegate?.exploreTypeTitles().count ?? 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.delegate?.segmentedListContainerViewListDelegate()[index] ?? ZLExploreChildListController(type: .repo, superVC: nil)
    }
}

// MARK: ZLViewUpdatableWithViewData
extension ZLExploreBaseView: ZLViewUpdatableWithViewData {
    
    func fillWithViewData(viewData: ZLExploreBaseViewDelegate) {
        self.delegate = viewData
    }
    
    func justUpdateView() {
        
    }
}


