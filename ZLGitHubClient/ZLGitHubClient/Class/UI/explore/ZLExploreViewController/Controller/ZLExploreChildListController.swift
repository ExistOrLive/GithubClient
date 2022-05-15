//
//  ZLExploreChildListController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseUI
import UIKit
import JXSegmentedView

enum ZLExploreChildListType: Int, CaseIterable {
    case repo = 0
    case user = 1
}

class ZLExploreChildListController: ZLBaseViewController {
    
    let type: ZLExploreChildListType
    
    weak var superVC: UIViewController?
    
    init(type: ZLExploreChildListType, superVC: UIViewController?) {
        self.type = type
        self.superVC = superVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        bindData()
        
        itemListView.beginRefresh()
    }

    func setUpUI() {
                
        contentView.addSubview(headerView)
        contentView.addSubview(itemListView)
        headerView.addSubview(stackView)
        stackView.addArrangedSubview(dateButton)
        stackView.addArrangedSubview(languageButton)
        
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
        }
        
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        languageButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        itemListView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
//        if type == .repo {
//            stackView.addArrangedSubview(spokenLanguageButton)
//            spokenLanguageButton.snp.makeConstraints { make in
//                make.width.equalTo(100)
//                make.height.equalTo(30)
//            }
//        }
    }
    
    func bindData() {
        
        switch type {
        case .repo: do {
            let dateTitle = titleForDateRange(dateRange: ZLUISharedDataManager.dateRangeForTrendingRepo)
            dateButton.setTitle(dateTitle, for: .normal)
            
            let language = ZLUISharedDataManager.languageForTrendingRepo ?? "Any"
            languageButton.setTitle(language, for: .normal)
        }
            
        case .user: do {
            let dateTitle = titleForDateRange(dateRange: ZLUISharedDataManager.dateRangeForTrendingUser)
            dateButton.setTitle(dateTitle, for: .normal)
            
            let language = ZLUISharedDataManager.languageForTrendingUser ?? "Any"
            languageButton.setTitle(language, for: .normal)
        }
        }
        
        
    }
    
    
    func titleForDateRange(dateRange: ZLDateRange) -> String {
        var title = ZLLocalizedString(string: "Today", comment: "")
        switch dateRange {
        case ZLDateRangeDaily : title = ZLLocalizedString(string: "Today", comment: "")
            break
        case ZLDateRangeWeakly : title = ZLLocalizedString(string: "This Week", comment: "")
            break
        case ZLDateRangeMonthly : title = ZLLocalizedString(string: "This Month", comment: "")
            break
        default:
            break
        }
        return title
    }
    
    
    // MARK: View
    lazy var itemListView: ZLGithubItemListView = {
        let view = ZLGithubItemListView()
        view.setTableViewHeader()
        view.delegate = self
       return view 
    }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLNavigationBarBackColor")
        return view
    }()
    
    lazy var languageButton: UIButton = {
        let button = ZLBaseButton(type: .custom)
        button.addTarget(self, action: #selector(onLanguageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var dateButton: UIButton = {
        let button = ZLBaseButton(type: .custom)
        button.addTarget(self, action: #selector(onDateButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var spokenLanguageButton: UIButton = {
        let button = ZLBaseButton(type: .custom)
        button.addTarget(self, action: #selector(onSpokenLanguageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
}

// MARK: ZLBaseViewModel
extension ZLExploreChildListController {
    override var viewController: ZLBaseViewController? {
        if let vc = self.superVC as? ZLBaseViewController  {
            return vc
        } else {
            return nil
        }
    }
}

// MARK: Action
extension ZLExploreChildListController {
    
    @objc func onLanguageButtonClicked() {
        
        ZLLanguageSelectView.showLanguageSelectView(resultBlock: { (language: String?) in
            
            self.languageButton.setTitle(language ?? "Any", for: .normal)
            
            switch self.type {
            case .repo:
                ZLUISharedDataManager.languageForTrendingRepo = language
            case .user:
                ZLUISharedDataManager.languageForTrendingUser = language
            }
            
            self.itemListView.beginRefresh()
        })
    }
    
    @objc func onDateButtonClicked() {
        ZLTrendingDateRangeSelectView.showTrendingDateRangeSelectView(initDateRange: ZLUISharedDataManager.dateRangeForTrendingRepo, resultBlock: {(dateRange: ZLDateRange) in
            
            self.dateButton.setTitle(self.titleForDateRange(dateRange: dateRange), for: .normal)
  
            switch self.type {
            case .repo:
                ZLUISharedDataManager.dateRangeForTrendingRepo = dateRange
            case .user:
                ZLUISharedDataManager.dateRangeForTrendingUser = dateRange
            }
            
            self.itemListView.beginRefresh()
    
        })
    }
    
    @objc func onSpokenLanguageButtonClicked() {
        
    }
    
}

// MARK: ZLGithubItemListViewDelegate
extension ZLExploreChildListController: ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        switch type {
        case .repo:
            getTrendRepo()
        case .user:
            getTrendUser()
        }
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        
    }
}

// MARK: Request
extension ZLExploreChildListController {
    
    func getTrendRepo() {
        
        let dateRange = ZLUISharedDataManager.dateRangeForTrendingRepo
        let language = ZLUISharedDataManager.languageForTrendingRepo
        
        let array = ZLSearchServiceShared()?.trending(with: .repositories,
                                                      language: language,
                                                      dateRange: dateRange,
                                                      spokenLanguageCode: "zh",
                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self] (model: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if model.result == true {
                
                guard let repoArray: [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel] else {
                    ZLLog_Info("ZLGithubRepositoryModel transfer failed")
                    self.itemListView.endRefreshWithError()
                    return
                }
                
                var repoCellDatas: [ZLRepositoryTableViewCellData] = []
                for item in repoArray {
                    let cellData = ZLRepositoryTableViewCellData.init(data: item, needPullData: false)
                    self.addSubViewModel(cellData)
                    repoCellDatas.append(cellData)
                }
                
                self.itemListView.resetCellDatas(cellDatas: repoCellDatas)
            } else {
                self.itemListView.endRefreshWithError()
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
                // ZLToastView.showMessage("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
            }
            
        }
        
        if let array = array as? [ZLGithubRepositoryModel] {
            var repoCellDatas: [ZLRepositoryTableViewCellData] = []
            for repo in array {
                let cellData = ZLRepositoryTableViewCellData.init(data: repo, needPullData: false)
                self.addSubViewModel(cellData)
                repoCellDatas.append(cellData)
            }
            self.itemListView.resetCellDatas(cellDatas: repoCellDatas)
        }
        
    }

    func getTrendUser() {
        
        let dateRange = ZLUISharedDataManager.dateRangeForTrendingUser
        let language = ZLUISharedDataManager.languageForTrendingUser
        
        let array = ZLSearchServiceShared()?.trending(with: .users,
                                                      language: language,
                                                      dateRange: dateRange,
                                                      spokenLanguageCode: nil,
                                                      serialNumber: NSString.generateSerialNumber())
        { [weak self](model: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if model.result == true {
                guard let userArray: [ZLGithubUserModel] = model.data as?  [ZLGithubUserModel] else {
                    ZLLog_Info("ZLGithubUserModel transfer failed")
                    self.itemListView.endRefreshWithError()
                    return
                }
                
                var userCellDatas: [ZLUserTableViewCellData] = []
                for item in userArray {
                    let cellData = ZLUserTableViewCellData.init(userModel: item)
                    self.addSubViewModel(cellData)
                    userCellDatas.append(cellData)
                }
                self.itemListView.resetCellDatas(cellDatas: userCellDatas)
        
            } else {
                self.itemListView.endRefreshWithError()
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending user Failed errorMessage[\(errorModel.message)]")
                //  ZLToastView.showMessage("Query Trending user Failed errorMessage[\(errorModel.message)]")
            }
            
        }
        
        if let array = array as? [ZLGithubUserModel] {
            var userCellDatas: [ZLUserTableViewCellData] = []
            for user in array {
                let cellData = ZLUserTableViewCellData.init(userModel: user)
                self.addSubViewModel(cellData)
                userCellDatas.append(cellData)
            }
            self.itemListView.resetCellDatas(cellDatas: userCellDatas)
        }
    }
}

// MARK: JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view 
    }
}
