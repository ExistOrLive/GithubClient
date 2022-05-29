//
//  ZLExploreChildListController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension
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
        
        itemListView.startLoad()
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
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        
        languageButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        
        itemListView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        if type == .repo {
            stackView.addArrangedSubview(spokenLanguageButton)
            spokenLanguageButton.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.height.equalTo(25)
            }
        }
    }
    
    func setButtonTitle(button: UIButton, title: String) {
        let titleWidth = title
            .asMutableAttributedString()
            .font(UIFont.zlMediumFont(withSize: 10))
            .boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
            .width + 30
        button.snp.updateConstraints { make in
            make.width.equalTo(max(titleWidth,60))
        }
        button.setTitle(title, for: .normal)
    }
    
    func bindData() {
        
        switch type {
        case .repo: do {
            let dateTitle = titleForDateRange(dateRange: ZLUISharedDataManager.dateRangeForTrendingRepo)
            setButtonTitle(button: dateButton, title: dateTitle)
            
            let language = ZLUISharedDataManager.languageForTrendingRepo ?? "Any"
            setButtonTitle(button: languageButton, title: language)
            
            let spokenLanguage = ZLUISharedDataManager.spokenLanguageForTrendingRepo ?? "Any"
            setButtonTitle(button: spokenLanguageButton, title: spokenLanguage)
        }
            
        case .user: do {
            let dateTitle = titleForDateRange(dateRange: ZLUISharedDataManager.dateRangeForTrendingUser)
            setButtonTitle(button: dateButton, title: dateTitle)
            
            let language = ZLUISharedDataManager.languageForTrendingUser ?? "Any"
            setButtonTitle(button: languageButton, title: language)
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
    lazy var itemListView: ZLTableContainerView = {
        let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        view.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
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
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
        button.addTarget(self, action: #selector(onLanguageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var dateButton: UIButton = {
        let button = ZLBaseButton(type: .custom)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
        button.addTarget(self, action: #selector(onDateButtonClicked), for: .touchUpInside)
        return button
    }()
    
    lazy var spokenLanguageButton: UIButton = {
        let button = ZLBaseButton(type: .custom)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 11)
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
            
            let languageTitle = language ?? "Any"
            self.setButtonTitle(button: self.languageButton, title: languageTitle)
            
            switch self.type {
            case .repo:
                ZLUISharedDataManager.languageForTrendingRepo = language
            case .user:
                ZLUISharedDataManager.languageForTrendingUser = language
            }
            
            self.itemListView.startLoad()
        })
    }
    
    @objc func onDateButtonClicked() {
        
        ZLTrendingDateRangeSelectView.showTrendingDateRangeSelectView(initDateRange: ZLUISharedDataManager.dateRangeForTrendingRepo, resultBlock: {(dateRange: ZLDateRange) in
            
            let dateTitle = self.titleForDateRange(dateRange: dateRange)
            self.setButtonTitle(button: self.dateButton, title: dateTitle)
  
            switch self.type {
            case .repo:
                ZLUISharedDataManager.dateRangeForTrendingRepo = dateRange
            case .user:
                ZLUISharedDataManager.dateRangeForTrendingUser = dateRange
            }
            
            self.itemListView.startLoad()
    
        })
    }
    
    @objc func onSpokenLanguageButtonClicked() {
        
        ZLSpokenLanguageSelectView.showSpokenLanguageSelectView { language, code in
            
            let languageTitle = language ?? "Any"
            self.setButtonTitle(button: self.spokenLanguageButton, title: languageTitle)
            
            ZLUISharedDataManager.spokenLanguageForTrendingRepo = language
            self.itemListView.startLoad()
        }
    }
    
}

// MARK: ZLGithubItemListViewDelegate
extension ZLExploreChildListController: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        switch type {
        case .repo:
            getTrendRepo()
        case .user:
            getTrendUser()
        }
    }
    
    func zlLoadMoreData() {
        
    }
}

// MARK: Request
extension ZLExploreChildListController {
    
    func getTrendRepo() {
        
        let dateRange = ZLUISharedDataManager.dateRangeForTrendingRepo
        let language = ZLUISharedDataManager.languageForTrendingRepo
        var spokenLanguageCode: String? = nil
        if let spokenLanguague = ZLUISharedDataManager.spokenLanguageForTrendingRepo {
            spokenLanguageCode = ZLSpokenLanguageSelectView.spokenLanguagueDic[spokenLanguague]
        }
         
        
        let array = ZLSearchServiceShared()?.trending(with: .repositories,
                                                      language: language,
                                                      dateRange: dateRange,
                                                      spokenLanguageCode: spokenLanguageCode,
                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self] (model: ZLOperationResultModel) in
            
            guard let self = self else { return }
            
            if model.result == true {
                
                guard let repoArray: [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel] else {
                    ZLLog_Info("ZLGithubRepositoryModel transfer failed")
                    self.itemListView.endRefresh()
                    return
                }
                
                for subViewModel in self.subViewModels {
                    subViewModel.removeFromSuperViewModel()
                }
                
                var repoCellDatas: [ZLRepositoryTableViewCellDataV2] = []
                for item in repoArray {
                    let cellData = ZLRepositoryTableViewCellDataV2(data: item)
                    self.addSubViewModel(cellData)
                    repoCellDatas.append(cellData)
                }
                
                self.itemListView.resetCellDatas(cellDatas: repoCellDatas, hasMoreData: true)
            } else {
                self.itemListView.endRefresh()
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
                // ZLToastView.showMessage("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
            }
            
        }
        
    
        if let array = array as? [ZLGithubRepositoryModel] {
            
            for subViewModel in subViewModels {
                subViewModel.removeFromSuperViewModel()
            }
            
            var repoCellDatas: [ZLRepositoryTableViewCellDataV2] = []
            for repo in array {
                let cellData = ZLRepositoryTableViewCellDataV2(data: repo)
                self.addSubViewModel(cellData)
                repoCellDatas.append(cellData)
            }
            self.itemListView.resetCellDatas(cellDatas: repoCellDatas, hasMoreData: true)
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
                    self.itemListView.endRefresh()
                    return
                }
                
                for subViewModel in self.subViewModels {
                    subViewModel.removeFromSuperViewModel()
                }
                
                var userCellDatas: [ZLUserTableViewCellDataV2] = []
                for item in userArray {
                    let cellData = ZLUserTableViewCellDataV2(model: item)
                    self.addSubViewModel(cellData)
                    userCellDatas.append(cellData)
                }
                self.itemListView.resetCellDatas(cellDatas: userCellDatas, hasMoreData: true)
        
            } else {
                self.itemListView.endRefresh()
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending user Failed errorMessage[\(errorModel.message)]")
                ZLToastView.showMessage("Query Trending user Failed errorMessage[\(errorModel.message)]",
                                        sourceView: self.view)
            }
        }
        
        if let array = array as? [ZLGithubUserModel] {
            
            for subViewModel in subViewModels {
                subViewModel.removeFromSuperViewModel()
            }
            
            var userCellDatas: [ZLUserTableViewCellDataV2] = []
            for user in array {
                let cellData = ZLUserTableViewCellDataV2(model: user)
                self.addSubViewModel(cellData)
                userCellDatas.append(cellData)
            }
            self.itemListView.resetCellDatas(cellDatas: userCellDatas, hasMoreData: true)
        }
    }
}

// MARK: JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view 
    }
}
