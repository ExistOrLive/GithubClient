//
//  ZLEditFixedRepoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/24.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLEditFixedRepoController : ZLBaseViewController,UITableViewDelegate,UITableViewDataSource{
        
    var selectedRepos : [ZLGithubCollectedRepoModel] = []
    
    var topRepositories : [ViewerTopRepositoriesQuery.Data.Viewer.TopRepository.Node?] = []
    
    var unselectedRepos : [ZLGithubCollectedRepoModel] = []
    
    var after : String?
    
    // view
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(ZLSimpleRepoTableViewCell.self, forCellReuseIdentifier: "ZLSimpleRepoTableViewCell")
        return tableView
    }()
    
    var searchViewController : ZLBaseSearchController!
    
    var searchResulController : ZLEditFixedRepoSearchController!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        selectedRepos = ZLServiceManager.sharedInstance.viewerServiceModel?.fixedRepos as? [ZLGithubCollectedRepoModel] ?? []
            
        self.title = ZLLocalizedString(string: "Repos", comment: "")
        
        let button = ZLBaseButton.init(type: .custom)
        button.titleLabel?.font = UIFont.init(name: Font_PingFangSCRegular, size: 14) ?? UIFont.systemFont(ofSize: 14)
        button.setTitle(ZLLocalizedString(string: "Save",comment: "保存"), for: .normal)
        
        button.frame = CGRect.init(x: 0, y: 0, width: 70, height: 30)
        button.addTarget(self, action: #selector(onSaveButtonClicked), for: .touchUpInside)
        
        let vc = self.viewController
        vc?.zlNavigationBar.rightButton = button
        
        
        let searchResultController = ZLEditFixedRepoSearchController()
        searchResultController.delegate = self
        self.searchResulController = searchResultController
        
        self.searchViewController = ZLBaseSearchController(resultController:searchResultController)
        self.searchViewController.sourceViewController = self
        self.searchViewController.delegate = self
        
        self.contentView.addSubview(self.searchViewController.searchBarContainerView)
        self.searchViewController.searchBarContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints{(make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.searchViewController.searchBarContainerView.snp_bottom)
        }
        self.tableView.mj_header = ZLRefresh.refreshHeader(refreshingBlock: { [weak self] in
            self?.loadNewData()
        })
        self.tableView.mj_footer = ZLRefresh.refreshFooter(refreshingBlock: { [weak self] in
            self?.loadMoreData()
        })
        self.tableView.mj_header?.beginRefreshing()
    }
    
    @objc func onSaveButtonClicked(){
        
        ZLServiceManager.sharedInstance.viewerServiceModel?.fixedRepos = self.selectedRepos
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - loadData
    func loadNewData(){
        
        self.tableView.mj_footer?.resetNoMoreData()
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyTopRepos(after: nil ,
                                                                          serialNumber: NSString.generateSerialNumber())
        { [weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.tableView.mj_header?.endRefreshing()
                weakSelf?.tableView.mj_footer?.endRefreshing()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    weakSelf?.topRepositories.removeAll()
                    weakSelf?.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes ?? [])
                    weakSelf?.tableView.mj_header?.endRefreshing()
                    weakSelf?.reloadData()
                } else {
                    weakSelf?.tableView.mj_header?.endRefreshing()
                }
            }
        }
    }
    
    func loadMoreData(){
    
        ZLServiceManager.sharedInstance.viewerServiceModel?.getMyTopRepos(after: after ,
                                                                          serialNumber: NSString.generateSerialNumber())
        { [weak weakSelf = self] (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.tableView.mj_header?.endRefreshing()
                weakSelf?.tableView.mj_footer?.endRefreshing()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    weakSelf?.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes ?? [])
                    if data.viewer.topRepositories.nodes?.count == 0 {
                        weakSelf?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        weakSelf?.tableView.mj_footer?.endRefreshing()
                    }
                    weakSelf?.reloadData()
                } else {
                    weakSelf?.tableView.mj_footer?.endRefreshing()
                }
            }
        }
        
    }
    
    func reloadData(){
        self.unselectedRepos.removeAll()
        for node in self.topRepositories{
            if let tmpNode = node {
                let simpleRepoModel = ZLGithubCollectedRepoModel()
                simpleRepoModel.full_name = tmpNode.nameWithOwner
                simpleRepoModel.owner_avatarURL = tmpNode.owner.avatarUrl
                simpleRepoModel.owner_login = tmpNode.owner.login
                if !self.selectedRepos.contains(where: { (model : ZLGithubCollectedRepoModel) -> Bool in
                    model.full_name == simpleRepoModel.full_name
                }){
                    self.unselectedRepos.append(simpleRepoModel)
                }
            }
        }
        self.tableView.reloadData()
    }
    

    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
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
        if section == 0 && self.selectedRepos.count == 0 {
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
        return view;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && self.selectedRepos.count == 0 {
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
        return 2;
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
            tableViewCell.avatarImageView.sd_setImage(with: URL(string:repoInfo.owner_avatarURL ?? ""), placeholderImage: UIImage(named: "default_avatar"))
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

extension ZLEditFixedRepoController : ZLEditFixedRepoSearchControllerDelegate{
    func onSelectResult(repo:ZLGithubRepositoryModel){
        
        self.searchViewController.endSearch(true)
        
        for selectedRepo in self.selectedRepos {
            if selectedRepo.full_name == repo.full_name{
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


extension ZLEditFixedRepoController : ZLBaseSearchControllerDelegate {
    
    func searchControllerDidEndEdit(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerDidBecomeEdit(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerDidShowResultController(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerConfirmSearch(_ searchController: ZLBaseSearchController, withSearchKey searchKey: String) {
        
    }
    
    func searchControllerCancel(_ searchController: ZLBaseSearchController){
        self.searchResulController.reset()
    }
    
   
}

// MARK: ZLEditFixedRepoSearchControllerDelegate

protocol ZLEditFixedRepoSearchControllerDelegate : NSObjectProtocol {
    func onSelectResult(repo:ZLGithubRepositoryModel)
}



class ZLEditFixedRepoSearchController : ZLBaseViewController,UITableViewDelegate,UITableViewDataSource {

    weak var delegate : ZLEditFixedRepoSearchControllerDelegate?
    
    private var tableView : UITableView!
    private var items : [ZLGithubRepositoryModel] = []
    private var searchKey : String?
    private var pageNum : UInt = 0
    
    override func onZLSearchKeyUpdate(_ searchKey: String) {
        
    }
    
    override func onZLSearchKeyConfirm(_ searchKey: String) {
        self.searchKey = searchKey
        self.tableView.mj_header?.beginRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRect.zero, style: .plain)
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints{(make) in
            make.edges.equalToSuperview()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.register(ZLSimpleRepoTableViewCell.self, forCellReuseIdentifier: "ZLSimpleRepoTableViewCell")
      
        weak var selfWeak = self
        self.tableView?.mj_header = ZLRefresh.refreshHeader(refreshingBlock: {
            selfWeak?.loadNewData()
        })
        self.tableView?.mj_footer = ZLRefresh.refreshFooter(refreshingBlock: {
            selfWeak?.loadMoreData()
        })
    }
    
    
    func loadNewData(){
        
        guard let searchKey = self.searchKey else {
            self.tableView.mj_header?.endRefreshing()
            return
        }
        
        self.items.removeAll()
        self.tableView.mj_footer?.resetNoMoreData()
        self.tableView.reloadData()
        
        ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                 type: .repositories,
                                                 filterInfo: nil,
                                                 page: 0,
                                                 per_page: 15,
                                                 serialNumber: NSString.generateSerialNumber())
        { [weak weakSelf = self](resultModel :ZLOperationResultModel) in
            
             weakSelf?.tableView.mj_header?.endRefreshing()
            
            if resultModel.result == true {
                if let searchResultModel = resultModel.data as? ZLSearchResultModel,
                   let repos = searchResultModel.data as? [ZLGithubRepositoryModel]{
                    if repos.count == 0 {
                        weakSelf?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.items.append(contentsOf: repos)
                        weakSelf?.pageNum = 1;
                        weakSelf?.tableView.reloadData()
                    }
                }
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.tableView.mj_header?.endRefreshing()
            }
        }
       
    }
    
    func loadMoreData(){
        
        guard let searchKey = self.searchKey else {
            self.tableView.mj_footer?.endRefreshing()
            return
        }
        ZLServiceManager.sharedInstance.searchServiceModel?.searchInfo(withKeyWord: searchKey,
                                                 type: .repositories,
                                                 filterInfo: nil,
                                                 page: pageNum,
                                                 per_page: 15,
                                                 serialNumber: NSString.generateSerialNumber())
        {[weak weakSelf = self] (resultModel :ZLOperationResultModel) in
            
            if resultModel.result == true {
                if let searchResultModel = resultModel.data as? ZLSearchResultModel,
                   let repos = searchResultModel.data as? [ZLGithubRepositoryModel]{
                    
                    if repos.count == 0 {
                        weakSelf?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        weakSelf?.tableView.mj_footer?.endRefreshing()
                        self.items.append(contentsOf: repos)
                        weakSelf?.pageNum += 1;
                        weakSelf?.tableView.reloadData()
                    }
                }
                
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.tableView.mj_footer?.endRefreshing()
            }
        }
    
    }
    
    // UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ZLSimpleRepoTableViewCell", for: indexPath) as? ZLSimpleRepoTableViewCell{
            cell.avatarImageView.sd_setImage(with: URL(string: self.items[indexPath.row].owner?.avatar_url ?? ""), placeholderImage: UIImage(named: "default_avatar"))
            cell.fullNameLabel.text = self.items[indexPath.row].full_name
            if indexPath.row == self.items.count - 1 {
                cell.singleLineView.isHidden = true
            } else {
                cell.singleLineView.isHidden = false
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.delegate?.onSelectResult(repo: self.items[indexPath.row])
        
        self.searchKey = nil
        self.items.removeAll()
        self.pageNum = 0
        
        self.tableView.reloadData()
    }
  
    
    func reset(){
        self.searchKey = nil
        self.items.removeAll()
        self.pageNum = 0
        
        self.tableView.reloadData()
    }
}
