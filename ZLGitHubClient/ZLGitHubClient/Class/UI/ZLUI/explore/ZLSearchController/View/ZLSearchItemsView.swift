//
//  ZLSearchItemsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView

@objc protocol ZLSearchItemsViewDelegate : NSObjectProtocol
{
    func onFilterButtonClicked(button : UIButton)
    
    func onSearchTypeChanged(searchType : ZLSearchType)
}

class ZLSearchItemsView: ZLBaseView {
    
    static let ZLSearchItemsTypes : [ZLSearchType] = [.repositories,.users]
    
    weak var delegate : ZLSearchItemsViewDelegate?
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var segmentedView: JXSegmentedView!
    var segmentedViewDatasource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    var segmentedListContainerView : JXSegmentedListContainerView?
    var githubItemListViewArray: [ZLGithubItemListView] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.filterButton.setTitle(ZLLocalizedString(string: "Filter", comment: ""), for: .normal)
        
        self.segmentedView.delegate = self
        
        var titles : [String] = []
        for searchType in ZLSearchItemsView.ZLSearchItemsTypes {
            self.githubItemListViewArray.append(ZLGithubItemListView())
            switch searchType {
            case .repositories:do{
                titles.append(ZLLocalizedString(string: "repositories",comment: ""))
            }
            case .users:do{
                titles.append(ZLLocalizedString(string: "users",comment: ""))
            }
            case .topics:do{
                titles.append(ZLLocalizedString(string: "topics", comment: ""))
            }
            case .code:do{
                titles.append(ZLLocalizedString(string: "code", comment: ""))
                }
            case .issues:do{
                titles.append(ZLLocalizedString(string: "issues", comment: ""))
                }
            case .commits:do{
                titles.append(ZLLocalizedString(string: "commit", comment: ""))
                }
            @unknown default:
                break
            }
        }
        
        self.segmentedViewDatasource.titles = titles
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
        self.containerView.addSubview(self.segmentedListContainerView!)
        self.segmentedListContainerView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.segmentedView.listContainer = self.segmentedListContainerView
    
    }

    
    @IBAction func onFilterViewClicked(_ sender: Any) {
        
        if self.delegate?.responds(to: #selector(ZLSearchItemsViewDelegate.onFilterButtonClicked(button:))) ?? false
        {
            self.delegate?.onFilterButtonClicked(button: sender as! UIButton)
        }
        
    }
    
    
}




extension ZLSearchItemsView : JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int){
        let searchType = ZLSearchItemsView.ZLSearchItemsTypes[index]
        if self.delegate?.responds(to: #selector(ZLSearchItemsViewDelegate.onSearchTypeChanged(searchType:))) ?? false {
            self.delegate?.onSearchTypeChanged(searchType: searchType)
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


extension ZLSearchItemsView : JXSegmentedListContainerViewDataSource{
    
    /// 返回list的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return ZLSearchItemsView.ZLSearchItemsTypes.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.githubItemListViewArray[index]
    }
}

extension ZLSearchItemsView : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}








