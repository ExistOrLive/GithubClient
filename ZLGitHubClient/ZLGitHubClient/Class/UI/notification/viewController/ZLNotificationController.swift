//
//  ZLNotificationController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUIUtilities
import ZLUtilities
import ZLGitRemoteService

@objcMembers class ZLNotificationController: ZMTableViewController {
    
    private var pageNum: UInt = 0         /// 页号

    private var showAllNotification: Bool {    /// 展示全部通知 / 展示未读
        get {
            return ZLUISharedDataManager.showAllNotifications
        }
        set {
            ZLUISharedDataManager.showAllNotifications = newValue
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc init() {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotificaiton()
        self.updateUI()
        self.viewStatus = .loading
        self.loadData(isLoadNew: true)
    }
    
    override func setupUI() {
        super.setupUI()
        
        self.setRefreshViews(types: [.header,.footer])
        
        tableView.register(ZLNotificationTableViewCell.self,
                                          forCellReuseIdentifier: "ZLNotificationTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        contentView.addSubview(filterBackView)
        
        filterBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(filterBackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func registerNotificaiton() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationArrived(notifcation:)), name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    func updateUI() {
        self.title = ZLLocalizedString(string: "Notification", comment: "通知")
        self.filterLabel.text = showAllNotification ? "all" : "unread"
    }
    

    private lazy var filterBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.back(withName: "ZLSubBarColor")
        view.addSubview(filterLabel)
        view.addSubview(filterButton)
        filterLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
        }
        filterButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(50)
        }
        return view
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(ZLIconFont.Filter.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ICON_Common"), for: .normal)
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 18)
        button.addTarget(self, action: #selector(onFilterButtonClicked), for: .touchUpInside)
        return button
    }()

    private lazy var filterLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 14)
        label.textColor = UIColor.label(withName: "ZLLabelColor3")
        label.text = "unread"
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    override func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
}

// MARK: - Request
extension ZLNotificationController {
    
    func loadData(isLoadNew: Bool) {
        
        var page: Int32 = 0
        if isLoadNew {
            page = 1
        } else {
            page = Int32(self.pageNum)
        }
        
        ZLEventServiceShared()?.getNotificationsWithShowAll(self.showAllNotification,
                                                            page: page,
                                                            per_page: 20,
                                                            serialNumber: NSString.generateSerialNumber()) { [weak self](resultModel: ZLOperationResultModel) in
            ZLProgressHUD.dismiss()
            
            guard let self else { return }
            self.endRefreshViews()
            self.viewStatus = .normal
            
            if resultModel.result == false {
                self.viewStatus = self.tableViewProxy.isEmpty ? .error : .normal
                guard let errorModel: ZLGithubRequestErrorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    ZLToastView.showMessage("query Notifications failed")
                    return
                }
                ZLToastView.showMessage("query Notifications failed statusCode[\(errorModel.statusCode)] errorMessage[\(errorModel.message)]")
            } else {
                guard let data: [ZLGithubNotificationModel] = resultModel.data as? [ZLGithubNotificationModel] else {
                    return
                }

                let cellDataArray = data.map {
                    ZLNotificationTableViewCellData(data: $0)
                }
                self.zm_addSubViewModels(cellDataArray)
                if isLoadNew {
                    self.sectionDataArray.forEach { $0.zm_removeFromSuperViewModel() }
                    self.sectionDataArray = [ZMBaseTableViewSectionData(cellDatas: cellDataArray)]
                    self.pageNum = 2
                } else {
                    self.sectionDataArray.first?.cellDatas.append(contentsOf: cellDataArray)
                    self.pageNum = self.pageNum + 1
                }
                self.tableView.reloadData()
                self.viewStatus = self.tableViewProxy.isEmpty ? .empty : .normal
                self.endRefreshViews(noMoreData: cellDataArray.count < 20)
            }
        }
    }
}

// MARK: - Action
extension ZLNotificationController {
    
    func deleteCellData(cellData: ZLNotificationTableViewCellData) {
        if self.showAllNotification == false {
            self.sectionDataArray.first?.cellDatas.removeAll(where: {
                $0 === cellData
            })
            self.tableView.reloadData()
        }
    }

    @objc func onNotificationArrived(notifcation: Notification) {
        if notifcation.name == ZLLanguageTypeChange_Notificaiton {
            self.title = ZLLocalizedString(string: "Notification", comment: "")
            self.justReloadRefreshView()
            self.tableViewProxy.reloadData()
        }
    }
    
    @objc private func onFilterButtonClicked() {
        
        guard let view = ZLMainWindow else { return }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title: ZLLocalizedString(string: "Filter",
                                                                    comment: ""),
                                           selectableTitles: ["all", "unread"],
                                           selectedTitle: showAllNotification ? "all" : "unread")
        { [weak self](index, result) in
            guard let self else { return }
            self.showAllNotification = index == 0
            self.filterLabel.text = index == 0 ? "all" : "unread"

            ZLProgressHUD.show()
            self.loadData(isLoadNew: true)
        }
    }
}
