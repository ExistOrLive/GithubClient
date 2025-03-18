//
//  ZLRepoContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLRepoContentNode: ZLBaseObject {
    var path: String = ""
    var name: String = ""
    var content: ZLGithubContentModel?
    var subNodes: [ZLRepoContentNode]?
    var parentNode: ZLRepoContentNode?
}

class ZLRepoContentController: ZLBaseViewController {

    // model
    var repoFullName: String?
    var path: String?
    var branch: String?
    
    /// 根节点
    var rootContentNode: ZLRepoContentNode?
    /// 当前节点
    var currentContentNode: ZLRepoContentNode?

    /// view
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(), style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ZLRepoContentTableViewCell.self, forCellReuseIdentifier: "ZLRepoContentTableViewCell")
        tableView.mj_header = ZLRefresh.refreshHeader(refreshingBlock: { [weak self] in
            self?.setQueryContentRequest()
        })
        return tableView
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onCloseButtonClicked(_button:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {

        super.viewDidLoad()

        guard repoFullName != nil && path != nil else {
            return
        }

        self.generateContentTree()

        self.setUpUI()

        self.tableView.mj_header?.beginRefreshing()

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

    func setUpUI() {
        
        self.title = self.currentContentNode?.name == ""  ? "/" : self.currentContentNode?.name

        self.zlNavigationBar.backButton.isHidden = false
        self.zlNavigationBar.rightButton = closeButton

        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        })
    }

    func reloadData() {
        self.title = self.currentContentNode?.name == ""  ? "/" : self.currentContentNode?.name

        let block = {
            self.tableView.reloadData()
            if self.currentContentNode?.subNodes == nil {
                self.tableView.mj_header?.beginRefreshing()
            }
        }

        if self.tableView.mj_header?.isRefreshing ?? false {
            self.tableView.mj_header?.endRefreshing {
                block()
            }
        } else {
            block()
        }
    }

    override func onBackButtonClicked(_ button: UIButton!) {
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
            
            self.tableView.mj_header?.endRefreshing()

            if resultModel.result == false {
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query content Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }

            guard let data = resultModel.data as? [ZLGithubContentModel] else {
                ZLToastView.showMessage("ZLGithubContentModel transfer error")
                return
            }

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
            let controller = ZLRepoCodePreview3Controller(repoFullName: repoFullName ?? "",
                                                          contentModel: contentModel,
                                                          branch: branch ?? "")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
