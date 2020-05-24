//
//  ZLExploreBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView

@objc protocol ZLExploreBaseViewDelegate : ZLGithubItemListViewDelegate {
    
    func exploreTypeTitles() -> [String]
    
    func onSearchButtonClicked() -> Void
    
    func onLanguageButtonClicked() -> Void
    
    func onDateRangeButtonClicked() -> Void
    
    func onSegmentViewSelectedIndex(segmentView: JXSegmentedView, index : Int) -> Void
}


@objcMembers class ZLExploreBaseView: UIView {

    @IBOutlet weak var trendingLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var dateRangeButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var segmentedView: JXSegmentedView!
    @IBOutlet weak var languageLabel: UILabel!
    var segmentedListContainerView: JXSegmentedListContainerView?
    var githubItemListViewArray : [ZLGithubItemListView] = []
    var segmentedViewDatasource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    
    weak var delegate : ZLExploreBaseViewDelegate? {
        didSet{
            self.githubItemListViewArray.removeAll()
            var titles : [String] = []
            if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.exploreTypeTitles)) ?? false {
                titles = self.delegate!.exploreTypeTitles()
            }
            self.segmentedViewDatasource.titles = titles
            self.githubItemListViewArray.removeAll()
            for i in 0..<titles.count{
                let listView = ZLGithubItemListView.init()
                listView.setTableViewHeader()
                listView.tag = i
                listView.delegate = self
                self.githubItemListViewArray.append(listView)
            }
            self.segmentedView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.segmentedView.delegate = self
       
        self.segmentedViewDatasource.titles = []
        self.segmentedViewDatasource.itemWidthIncrement = 10
        self.segmentedViewDatasource.titleNormalColor = ZLRGBValue_H(colorValue: 0x999999)
        self.segmentedViewDatasource.titleSelectedColor = UIColor.black
        self.segmentedViewDatasource.titleNormalFont =  UIFont.init(name: Font_PingFangSCRegular, size:14.0) ?? UIFont.systemFont(ofSize: 15)
        self.segmentedViewDatasource.titleSelectedFont = UIFont.init(name: Font_PingFangSCSemiBold, size:16.0)
 
        self.segmentedView.dataSource = self.segmentedViewDatasource

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.black
        indicator.indicatorHeight = 1.0
        self.segmentedView.indicators = [indicator]
        
        self.segmentedListContainerView = JXSegmentedListContainerView.init(dataSource: self, type: .scrollView)
        self.addSubview(self.segmentedListContainerView!)
        self.segmentedListContainerView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.bottom)
            make.top.equalTo(self.headerView.snp_bottom)
        }
        self.segmentedView.listContainer = self.segmentedListContainerView
        
        self.justReloadView()
    }
        
    func justReloadView(){
        self.searchButton.setTitle(ZLLocalizedString(string: "Search", comment: "搜索"), for: .normal)
        self.trendingLabel.text = ZLLocalizedString(string: "trending", comment: "趋势")
    }
    
    
    @IBAction func onLanguageButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.onLanguageButtonClicked)) ?? false {
            self.delegate?.onLanguageButtonClicked()
        }
    }
    
    
    @IBAction func onDateRangeButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.onDateRangeButtonClicked)) ?? false {
            self.delegate?.onDateRangeButtonClicked()
        }
    }
    
    
    @IBAction func onSearchButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.onSearchButtonClicked)) ?? false {
            self.delegate?.onSearchButtonClicked()
        }
    }
    
}


extension ZLExploreBaseView : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) -> Void{
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.githubItemListViewRefreshDragDown(pullRequestListView:))) ?? false {
            self.delegate?.githubItemListViewRefreshDragDown(pullRequestListView: pullRequestListView)
        }
    }
       
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        
    }
}


extension ZLExploreBaseView : JXSegmentedViewDelegate {
 
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int){
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.onSegmentViewSelectedIndex(segmentView:index:))) ?? false {
            self.delegate?.onSegmentViewSelectedIndex(segmentView: segmentedView, index: index)
        }
    }

    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int){
        
    }

    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int){
        
    }

    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat){
        
    }

    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool{
        return true
    }
}


extension ZLExploreBaseView : JXSegmentedListContainerViewDataSource{
    
    /// 返回list的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if self.delegate?.responds(to: #selector(ZLExploreBaseViewDelegate.exploreTypeTitles)) ?? false {
            return self.delegate?.exploreTypeTitles().count ?? 0
        } else {
            return 0
        }
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.githubItemListViewArray[index]
    }
}

extension ZLGithubItemListView : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
