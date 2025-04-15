//
//  ZLEditFixedRepoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLGitRemoteService

class ZLEditFixedRepoController: ZMViewController, ZLRefreshProtocol {
   
    var selectedRepos: [ZLGithubCollectedRepoModel] = []
    
    var topRepositories: [ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node?] = []
    
    var unselectedRepos: [ZLGithubCollectedRepoModel] = []
    
    var after: String?
    
    // view
    var scrollView: UIScrollView {
        tableView
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ZLSimpleRepoTableViewCell.self, forCellReuseIdentifier: "ZLSimpleRepoTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedRepos = ZLViewerServiceShared()?.fixedRepos as? [ZLGithubCollectedRepoModel] ?? []
        
        viewStatus = .loading
        refreshLoadNewData()
    }
    
    override func setupUI() {
        super.setupUI()
        title = ZLLocalizedString(string: "repository", comment: "")
        
        contentView.addSubview(searchBackView)
        contentView.addSubview(tableView)
        searchBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBackView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        setRefreshViews(types: [.header,.footer])
        
        zmNavigationBar.addRightView(saveButton)
    }
    
    lazy var searchBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SearchBarBack")
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(15)
            make.right.equalTo(-20)
            make.bottom.equalTo(-15)
            make.height.equalTo(40)
        }
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4.0
        button.backgroundColor = UIColor(named: "ZLExploreTextFieldBackColor")
        button.addSubview(searchButtonText)
        button.addTarget(self, action: #selector(onSearchButtonClicked), for: .touchUpInside)
        searchButtonText.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
        }
        return button
    }()
    
    lazy var searchButtonText: UILabel = {
        let label = UILabel()
        label.font = .zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.text = ZLLocalizedString(string: "Search", comment: "")
        return label
    }()
    
    
    lazy var saveButton: UIButton = {
        let button = ZMButton()
        button.titleLabel?.font = UIFont.init(name: Font_PingFangSCRegular, size: 14) ?? UIFont.systemFont(ofSize: 14)
        button.setTitle(ZLLocalizedString(string: "Save", comment: "保存"), for: .normal)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
        return button
    }()
    
    
    func refreshLoadNewData() {
        loadData(isLoadNew: true)
    }
    
    func refreshLoadMoreData() {
        loadData(isLoadNew: false)
    }
    

    
    func reloadData() {
        self.unselectedRepos.removeAll()
        for node in self.topRepositories {
            if let tmpNode = node {
                let simpleRepoModel = ZLGithubCollectedRepoModel()
                simpleRepoModel.full_name = tmpNode.nameWithOwner
                simpleRepoModel.owner_avatarURL = tmpNode.owner.avatarUrl
                simpleRepoModel.owner_login = tmpNode.owner.login
                if !self.selectedRepos.contains(where: { (model: ZLGithubCollectedRepoModel) -> Bool in
                    model.full_name == simpleRepoModel.full_name
                }) {
                    self.unselectedRepos.append(simpleRepoModel)
                }
            }
        }
        self.tableView.reloadData()
    }
}

extension ZLEditFixedRepoController {
    
    func loadData(isLoadNew: Bool) {
        var after: String? = nil
        if !isLoadNew {
            after = self.after
        }
        ZLViewerServiceShared()?.getMyTopRepos(after: after ,
                                               serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel: ZLOperationResultModel) in
            guard let self else { return }
            self.viewStatus = .normal
            if resultModel.result,
               let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                if isLoadNew {
                    self.topRepositories.removeAll()
                    self.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes ?? [])
                } else {
                    self.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes ?? [])
                }
                self.after = data.viewer.topRepositories.pageInfo.endCursor
                self.endRefreshViews(noMoreData: !data.viewer.topRepositories.pageInfo.hasNextPage)
                self.reloadData()
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
                self.endRefreshViews()
            
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ZLEditFixedRepoController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedRepos.remove(at: indexPath.row)
            self.reloadData()
        } else {
            self.selectedRepos.append(self.unselectedRepos.remove(at: indexPath.row))
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && self.selectedRepos.isEmpty {
            return 40
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 14)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(15)
            make.bottom.equalToSuperview().offset(-5)
        }

        label.text = section == 0 ? ZLLocalizedString(string: "SELECTED", comment: "") : ZLLocalizedString(string: "UNSELECTED", comment: "")
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && self.selectedRepos.isEmpty {
            let label = UILabel()
            label.backgroundColor = UIColor(named: "ZLCellBack")
            label.textColor = UIColor(named: "ZLLabelColor2")
            label.font = UIFont(name: Font_PingFangSCRegular, size: 14)
            label.textAlignment = .center
            label.text = ZLLocalizedString(string: "No Repository Selected", comment: "")
            return label
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return selectedRepos.count
        } else {
            return unselectedRepos.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLSimpleRepoTableViewCell") as? ZLSimpleRepoTableViewCell {
            let repoInfo = indexPath.section == 0 ? selectedRepos[indexPath.row] : unselectedRepos[indexPath.row]
            tableViewCell.avatarImageView.loadAvatar(login: repoInfo.owner_login ?? "",
                                                     avatarUrl: repoInfo.owner_avatarURL ?? "")
            tableViewCell.fullNameLabel.text = repoInfo.full_name
            tableViewCell.singleLineView.isHidden = (indexPath.row == (indexPath.section == 0 ? selectedRepos : unselectedRepos).count - 1)
            return tableViewCell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - Action
extension ZLEditFixedRepoController {
    @objc func onSaveButtonClicked() {
        ZLServiceManager.sharedInstance.viewerServiceModel?.fixedRepos = self.selectedRepos
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onSearchButtonClicked() {
        let vc = ZLEditFixedRepoSearchController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - ZLEditFixedRepoSearchControllerDelegate
extension ZLEditFixedRepoController: ZLEditFixedRepoSearchControllerDelegate {
    func onSelectResult(repo: ZLGithubRepositoryModel) {
        for selectedRepo in self.selectedRepos {
            if selectedRepo.full_name == repo.full_name {
                return
            }
        }
        let collectedRepo = ZLGithubCollectedRepoModel()
        collectedRepo.full_name = repo.full_name
        collectedRepo.owner_login = repo.owner?.loginName
        collectedRepo.owner_avatarURL = repo.owner?.avatar_url
        selectedRepos.append(collectedRepo)
        self.tableView.reloadData()
    }
}
