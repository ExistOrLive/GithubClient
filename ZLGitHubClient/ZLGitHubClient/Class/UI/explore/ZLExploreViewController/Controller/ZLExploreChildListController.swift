//
//  ZLExploreChildListController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLUIUtilities
import ZLBaseExtension
import UIKit
import JXSegmentedView
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

enum ZLExploreChildListType: Int, CaseIterable {
    case repo = 0
    case user = 1
}

class ZLExploreChildListController: ZMTableViewController {
    
    let type: ZLExploreChildListType
    
    weak var superVC: UIViewController?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    init(type: ZLExploreChildListType, superVC: UIViewController?) {
        self.type = type
        self.superVC = superVC
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        viewStatus = .loading
        refreshLoadNewData()
    }

    override func setupUI() {
        super.setupUI()
        isZmNavigationBarHidden = true
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        tableView.snp.remakeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.register(ZLUserTableViewCell.self, forCellReuseIdentifier: "ZLUserTableViewCell")
        tableView.register(ZLRepositoryTableViewCell.self, forCellReuseIdentifier: "ZLRepositoryTableViewCell")
    
        setRefreshViews(types: [.header])
    }
    
    func setButtonTitle(button: UIButton, title: String) {
        var attributedStr = "".asMutableAttributedString()
        
        if button == languageButton {
            
            attributedStr = NSASCContainer(
                
                ZLLocalizedString(string: "Language: ", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
                
                title
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 12))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
                
                " "
                    .asMutableAttributedString(),
                
                ZLIconFont.DownArrow.rawValue
                    .asMutableAttributedString()
                    .font(.iconFont(size: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))
                
            ).asMutableAttributedString()
            
        } else if button == dateButton {
            
            attributedStr = NSASCContainer(
                
                ZLLocalizedString(string: "Date Range: ", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
                
                title
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 12))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
                
                " "
                    .asMutableAttributedString(),
                
                ZLIconFont.DownArrow.rawValue
                    .asMutableAttributedString()
                    .font(.iconFont(size: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))
                
            ).asMutableAttributedString()
            
        } else if button == spokenLanguageButton {
            
            attributedStr = NSASCContainer(
                
                ZLLocalizedString(string: "Spoken Language: ", comment: "")
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor2")),
                
                title
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 12))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1")),
                
                " "
                    .asMutableAttributedString(),
                
                ZLIconFont.DownArrow.rawValue
                    .asMutableAttributedString()
                    .font(.iconFont(size: 10))
                    .foregroundColor(UIColor.label(withName: "ZLLabelColor1"))
                
            ).asMutableAttributedString()
            
        }
        
        let titleWidth = attributedStr
            .boundingRect(with: CGSize(width: CGFloat.infinity, height: CGFloat.infinity), options: .usesLineFragmentOrigin, context: nil)
            .width + 30
        button.snp.updateConstraints { make in
            make.width.equalTo(max(titleWidth,60))
        }
        button.setAttributedTitle(attributedStr, for: .normal)
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
            
            spokenLanguageButton.isHidden = false
        }
            
        case .user: do {
            let dateTitle = titleForDateRange(dateRange: ZLUISharedDataManager.dateRangeForTrendingUser)
            setButtonTitle(button: dateButton, title: dateTitle)
            
            let language = ZLUISharedDataManager.languageForTrendingUser ?? "Any"
            setButtonTitle(button: languageButton, title: language)
            
            spokenLanguageButton.isHidden = true
        }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notication:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
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
    
    lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(headerScrollView)
        view.backgroundColor = UIColor(named: "ZLNavigationBarBackColor")
        headerScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    
    lazy var headerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.bounces = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.addArrangedSubview(dateButton)
        stackView.addArrangedSubview(languageButton)
        stackView.addArrangedSubview(spokenLanguageButton)
        
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        
        languageButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
        
        spokenLanguageButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
 
        return stackView
    }()
    
    lazy var filterManager: ZLTrendingFilterManager = {
       return ZLTrendingFilterManager()
    }()
    

    override func refreshLoadNewData() {
        switch type {
        case .repo:
            getTrendRepo()
        case .user:
            getTrendUser()
        }
    }
}

// MARK: ZLBaseViewModel
extension ZLExploreChildListController {
    override var zm_viewController: UIViewController? {
        self.superVC
    }
}

// MARK: Action
extension ZLExploreChildListController {
    
    @objc func onLanguageButtonClicked() {
        guard let view = ZLMainWindow else { return }
        var developLanguage: String? = nil
        switch self.type {
        case .repo:
            developLanguage = ZLUISharedDataManager.languageForTrendingRepo
        case .user:
            developLanguage = ZLUISharedDataManager.languageForTrendingUser
        }
        
        ZMLanguageSelectView.showDevelopLanguageSelectView(to: view,
                                                           developeLanguage: developLanguage)
        { [weak self] newLanguage in
            guard let self = self else { return }
            
            let languageTitle = newLanguage ?? "Any"
            self.setButtonTitle(button: self.languageButton, title: languageTitle)
            
            switch self.type {
            case .repo:
                ZLUISharedDataManager.languageForTrendingRepo = newLanguage
            case .user:
                ZLUISharedDataManager.languageForTrendingUser = newLanguage
            }
            ZLProgressHUD.show()
            self.refreshLoadNewData()
        }
    }
    
    @objc func onDateButtonClicked() {
        guard let view = ZLMainWindow else { return }
        var dateRange: ZLDateRange = ZLDateRangeDaily
        switch self.type {
        case .repo:
            dateRange = ZLUISharedDataManager.dateRangeForTrendingRepo
        case .user:
            dateRange = ZLUISharedDataManager.dateRangeForTrendingUser
        }
        
        filterManager.showTrendingDateRangeSelectView(to: view,
                                                      initDateRange: dateRange) { dateRange in
            let dateTitle = self.titleForDateRange(dateRange: dateRange)
            self.setButtonTitle(button: self.dateButton, title: dateTitle)
            
            switch self.type {
            case .repo:
                ZLUISharedDataManager.dateRangeForTrendingRepo = dateRange
            case .user:
                ZLUISharedDataManager.dateRangeForTrendingUser = dateRange
            }
            
            ZLProgressHUD.show()
            self.refreshLoadNewData()
        }
    }
    
    @objc func onSpokenLanguageButtonClicked() {
        
        guard let view = ZLMainWindow else { return }
        
        ZMLanguageSelectView.showSpokenLanguageSelectView(to: view,
                                                          spokenLanguage: ZLUISharedDataManager.spokenLanguageForTrendingRepo)
        { [weak self] newLanguage in
            guard let self = self else { return }
            
            let languageTitle = newLanguage ?? "Any"
            self.setButtonTitle(button: self.spokenLanguageButton, title: languageTitle)
            ZLUISharedDataManager.spokenLanguageForTrendingRepo = newLanguage
            ZLProgressHUD.show()
            self.refreshLoadNewData()
        }
    }
    
}

// MARK: Request
extension ZLExploreChildListController {
    
    func getTrendRepo() {
        
        let dateRange = ZLUISharedDataManager.dateRangeForTrendingRepo
        let language = ZLUISharedDataManager.languageForTrendingRepo
        var spokenLanguageCode: String? = nil
        if let spokenLanguague = ZLUISharedDataManager.spokenLanguageForTrendingRepo {
            spokenLanguageCode = ZMLanguageSelectView.spokenLanguagueDic[spokenLanguague] ?? nil
        }
         
        
        let array = ZLSearchServiceShared()?.trending(with: .repositories,
                                                      language: language,
                                                      dateRange: dateRange,
                                                      spokenLanguageCode: spokenLanguageCode,
                                                      serialNumber: NSString.generateSerialNumber())
        {[weak self] (model: ZLOperationResultModel) in
            
            guard let self = self else { return }
            self.viewStatus = .normal
            self.endRefreshViews()
            ZLProgressHUD.dismiss()
            
            if dateRange != ZLUISharedDataManager.dateRangeForTrendingRepo ||
                language != ZLUISharedDataManager.languageForTrendingRepo ||
                spokenLanguageCode != ZMLanguageSelectView.spokenLanguagueDic[ZLUISharedDataManager.spokenLanguageForTrendingRepo ?? ""] {
                /// 筛选项不一致，return
                return
            }
            
            if model.result == true,
               let repoArray: [ZLGithubRepositoryModel] = model.data as?  [ZLGithubRepositoryModel]  {
            
                self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                
                let repoCellDatas: [ZLRepositoryTableViewCellDataV3] = repoArray.map {
                    ZLRepositoryTableViewCellDataV3(data: $0)
                }
                self.zm_addSubViewModels(repoCellDatas)
                self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: repoCellDatas)]
                self.tableView.reloadData()
                
                self.viewStatus = repoArray.isEmpty ? .empty : .normal
            
            } else {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
                // ZLToastView.showMessage("Query Trending Repo Failed errorMessage[\(errorModel.message)]")
            }
            
        }
        
    
        if let array = array as? [ZLGithubRepositoryModel] {
            
            self.viewStatus = array.isEmpty ? .empty : .normal
            self.endRefreshViews()
            ZLProgressHUD.dismiss()
            
            self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
            
            let repoCellDatas: [ZLRepositoryTableViewCellDataV3] = array.map {
                ZLRepositoryTableViewCellDataV3(data: $0)
            }
            self.zm_addSubViewModels(repoCellDatas)
            self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: repoCellDatas)]
            self.tableView.reloadData()
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
            self.viewStatus = .normal
            self.endRefreshViews()
            ZLProgressHUD.dismiss()
            
            if dateRange != ZLUISharedDataManager.dateRangeForTrendingUser || language != ZLUISharedDataManager.languageForTrendingUser {
                /// 筛选项不一致，return
                return
            }
            
            if model.result, let userArray = model.data as?  [ZLGithubUserModel] {
               
            
                self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                
                let userCellDatas: [ZLUserTableViewCellDataV3] = userArray.map {
                    ZLUserTableViewCellDataV3(model: $0)
                }
                self.zm_addSubViewModels(userCellDatas)
                self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: userCellDatas)]
                self.tableView.reloadData()

                self.viewStatus = userCellDatas.isEmpty ? .empty : .normal
        
            } else {
                
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                guard let errorModel: ZLGithubRequestErrorModel = model.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLLog_Info("Query Trending user Failed errorMessage[\(errorModel.message)]")
                ZLToastView.showMessage("Query Trending user Failed errorMessage[\(errorModel.message)]",
                                        sourceView: self.view)
            }
        }
        
        if let array = array as? [ZLGithubUserModel] {
            
            self.viewStatus = array.isEmpty ? .empty : .normal
            self.endRefreshViews()
            ZLProgressHUD.dismiss()
            
            self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
            
            let userCellDatas: [ZLUserTableViewCellDataV3] = array.map {
                ZLUserTableViewCellDataV3(model: $0)
            }
            self.zm_addSubViewModels(userCellDatas)
            self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: userCellDatas)]
            self.tableView.reloadData()
        }
    }
}

// MARK: JXSegmentedListContainerViewListDelegate
extension ZLExploreChildListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self.view 
    }
}


// MARK: Notificaiton
extension ZLExploreChildListController {
    @objc func onNotificationArrived(notication: Notification) {

        switch notication.name {
        case ZLLanguageTypeChange_Notificaiton:do {
 
            self.justReloadRefreshView()
            self.tableView.reloadData()
            
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
        default:
            break
        }

    }
}
