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
    var tableView : UITableView!
    
    var searchViewController : ZLBaseSearchController!

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        self.title = ZLLocalizedString(string: "Repos", comment: "")
        
        self.searchViewController = ZLBaseSearchController(resultController: ZLEditFixedRepoSearchController())
        self.searchViewController.sourceViewController = self
        self.searchViewController.delegate = self
        
        self.contentView.addSubview(self.searchViewController.searchBarContainerView)
        self.searchViewController.searchBarContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        self.tableView = UITableView(frame: CGRect.zero, style: .grouped)
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints{(make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.searchViewController.searchBarContainerView.snp_bottom)
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

        self.tableView?.mj_header?.beginRefreshing()
    }
    
    func loadNewData(){
        
        self.tableView.mj_footer?.resetNoMoreData()
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getTopReposWith(afterCursor: nil , serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
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
                    weakSelf?.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes!)
                    weakSelf?.tableView.mj_header?.endRefreshing()
                    weakSelf?.reloadData()
                } else {
                    weakSelf?.tableView.mj_header?.endRefreshing()
                }
            }
        }
    }
    
    func loadMoreData(){
        
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getTopReposWith(afterCursor: after , serialNumber: NSString.generateSerialNumber()) { (resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                weakSelf?.tableView.mj_header?.endRefreshing()
                weakSelf?.tableView.mj_footer?.endRefreshing()
            } else {
                if let data = resultModel.data as? ViewerTopRepositoriesQuery.Data {
                    weakSelf?.after = data.viewer.topRepositories.pageInfo.endCursor
                    weakSelf?.topRepositories.append(contentsOf: data.viewer.topRepositories.nodes!)
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
    
    
    
    // UITableView
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
            make.left.equalToSuperview().offset(15)
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

extension ZLEditFixedRepoController : ZLBaseSearchControllerDelegate {
    
    func searchControllerDidEndEdit(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerDidBecomeEdit(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerDidShowResultController(_ searchController: ZLBaseSearchController) {
        
    }
    
    func searchControllerConfirmSearch(_ searchController: ZLBaseSearchController, withSearchKey searchKey: String) {
        
    }
}


class ZLEditFixedRepoSearchController : ZLBaseViewController {
    
    override func onZLSearchKey(_ searchKey: String) {
        
    }
}
