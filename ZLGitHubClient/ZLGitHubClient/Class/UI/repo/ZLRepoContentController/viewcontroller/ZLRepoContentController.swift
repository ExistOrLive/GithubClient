//
//  ZLRepoContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZMMVVM

class ZLRepoContentNode: ZLBaseObject {
    var path: String = ""
    var name: String = ""
    var content: ZLGithubContentModel?
    var subNodes: [ZLRepoContentNode]?
    var parentNode: ZLRepoContentNode?
}

class ZLRepoContentController: ZMViewController, ZLRefreshProtocol {
    
    // model
    @objc var repoFullName: String?
    @objc var path: String?
    @objc var branch: String?
    
    /// 根节点
    var rootContentNode: ZLRepoContentNode?
    /// 当前节点
    var currentContentNode: ZLRepoContentNode?

    @objc init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onCloseButtonClicked(_button:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        if #available(iOS 11, *) {
            tableView.estimatedRowHeight = UITableView.automaticDimension
            tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
            tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        } else {
            tableView.estimatedRowHeight = 44
            tableView.estimatedSectionFooterHeight = 44
            tableView.estimatedSectionHeaderHeight = 44
        }
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        let nRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01)
        tableView.tableHeaderView = UIView(frame: nRect)
        tableView.tableFooterView = UIView(frame: nRect)
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(ZLRepoContentTableViewCell.self, forCellReuseIdentifier: "ZLRepoContentTableViewCell")
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        return tableView
    }()

    var scrollView: UIScrollView {
        tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.generateContentTree()
        self.viewStatus = .loading
        self.refreshLoadNewData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationVC = navigationController as? ZMNavigationController {
            navigationVC.forbidGestureBack = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navigationVC = navigationController as? ZMNavigationController {
            navigationVC.forbidGestureBack = true
        }
    }

    func generateContentTree() {

        self.rootContentNode = ZLRepoContentNode()
        self.currentContentNode = rootContentNode

        let nameArray: [Substring] =  path?.split(separator: "/") ?? []

        var tmpPath = ""
        for name in nameArray {
            tmpPath.append(contentsOf: name)
            let node = ZLRepoContentNode()
            node.name = String(name)
            node.path = tmpPath
            node.parentNode = self.currentContentNode
            self.currentContentNode = node
            tmpPath.append("/")
        }
    }

    override func setupUI() {
        super.setupUI()
        
        if let name = self.currentContentNode?.name,
           !name.isEmpty {
            self.title = self.currentContentNode?.name
        } else {
            self.title = "/"
        }
   
        self.zmNavigationBar.backButton.isHidden = false
        self.zmNavigationBar.addRightView(closeButton)

        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setRefreshView(type: .header)
    
    }

    func reloadData() {
        if let name = self.currentContentNode?.name,
           !name.isEmpty {
            self.title = self.currentContentNode?.name
        } else {
            self.title = "/"
        }

        if self.tableView.mj_header?.isRefreshing ?? false {
            self.endRefreshViews()
        }
        self.tableView.reloadData()
        if self.currentContentNode?.subNodes == nil {
            self.viewStatus = .loading
            self.refreshLoadNewData()
        }
    }
    
    func refreshLoadNewData() {
        self.setQueryContentRequest()
    }
    
    func refreshLoadMoreData() {
        //
    }
    
    // MARK: - Action
    override func onBackButtonClicked(_ button: UIButton) {
        if self.currentContentNode?.parentNode != nil {
            self.currentContentNode = self.currentContentNode?.parentNode
            self.reloadData()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func onCloseButtonClicked(_button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Request
extension ZLRepoContentController {
    func setQueryContentRequest() {
        ZLRepoServiceShared()?.getRepositoryContentsInfo(withFullName: repoFullName ?? "",
                                                         path: currentContentNode?.path ?? "",
                                                         branch: branch ?? "",
                                                         serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            guard let self = self else { return }
            self.viewStatus = .normal
            self.endRefreshViews()

            if resultModel.result, let data = resultModel.data as? [ZLGithubContentModel] {
                var dirArray: [ZLRepoContentNode] = []
                var fileArray: [ZLRepoContentNode] = []
                for tmpData in data {
                    let contentNode = ZLRepoContentNode()
                    contentNode.name = tmpData.name
                    contentNode.path = tmpData.path
                    contentNode.parentNode = self.currentContentNode
                    contentNode.content = tmpData
                    if tmpData.type == "dir" {
                        dirArray.append(contentNode)
                    } else {
                        fileArray.append(contentNode)
                    }
                }
                dirArray = dirArray.sorted { node1, node2 in
                    node1.name < node2.name
                }
                fileArray = fileArray.sorted { node1, node2 in
                    node1.name < node2.name
                }
            
                self.currentContentNode?.subNodes = dirArray + fileArray
                self.tableView.reloadData()
            } else {
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query content Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
            }
        }
    }
}

// MARK: - UITableView
extension ZLRepoContentController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentContentNode?.subNodes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoContentTableViewCell",
                                                                for: indexPath)  as? ZLRepoContentTableViewCell else {
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }

        if let contentModel = self.currentContentNode?.subNodes?[indexPath.row].content {
            tableViewCell.setCellData(cellData: contentModel) { [weak self] view in

                if let self = self,
                   let url = URL(string: contentModel.html_url) {
                    view.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self)
                }
            }
        } else {
            tableViewCell.setCellData(cellData: nil)
        }

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let contentModel = self.currentContentNode?.subNodes?[indexPath.row].content else {
            return
        }

        if "dir" == contentModel.type {
            self.currentContentNode = self.currentContentNode?.subNodes?[indexPath.row]
            self.reloadData()
        } else if "file" == contentModel.type {
            let controller = ZLRepoCodePreview3Controller()
            controller.repoFullName = repoFullName ?? ""
            controller.path = contentModel.path
            controller.branch = branch ?? ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
