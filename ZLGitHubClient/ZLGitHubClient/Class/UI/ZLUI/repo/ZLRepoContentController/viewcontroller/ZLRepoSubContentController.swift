//
//  ZLRepoSubContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoSubContentController: ZLBaseViewController {

    // model
    let repoFullName : String
    let path : String
    let branch : String
    
    // view
    var tableView : UITableView?
    var contentArray : [ZLGithubContentModel]?
    
    
    init(repoFullName : String, path : String, branch : String)
    {
        self.repoFullName = repoFullName
        self.path = path
        self.branch = branch
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
        self.tableView?.mj_header?.beginRefreshing()
        
    }
    
    func setUpUI()
    {
        self.title = self.path == "" ? "/" : self.path
        
        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onCloseButtonClicked(_button:)), for: .touchUpInside)
        
        self.zlNavigationBar.rightButton = button
        
        
        let tableView = UITableView.init(frame: CGRect.init(), style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ZLRepoContentTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLRepoContentTableViewCell")
        
        weak var weakSelf = self
        tableView.mj_header = ZLRefresh.refreshHeader(refreshingBlock: {
            weakSelf?.setQueryContentRequest()
        })
        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints ({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        })
        self.tableView = tableView
    }
    
    
    func setQueryContentRequest()
    {
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryContentsInfo(withFullName: self.repoFullName,path: self.path,branch:self.branch,serialNumber: NSString.generateSerialNumber(),completeHandle: {(resultModel : ZLOperationResultModel) in
            
            weakSelf?.tableView?.mj_header?.endRefreshing()
            
            if resultModel.result == false
            {
                let errorModel = resultModel.data as? ZLGithubRequestErrorModel
                ZLToastView.showMessage("Query content Failed Code [\(errorModel?.statusCode ?? 0)] Message[\(errorModel?.message ?? "")]")
                return
            }
            
            guard let data : [ZLGithubContentModel] = resultModel.data as? [ZLGithubContentModel] else
            {
                ZLToastView.showMessage("ZLGithubContentModel transfer error")
                return;
            }
            
            weakSelf?.contentArray = data
            
            weakSelf?.tableView?.reloadData()
            
        })
    }
    
    override func onBackButtonClicked(_ button: UIButton!) {
        if self == self.navigationController?.viewControllers.first
        {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        else
        {
            super.onBackButtonClicked(button)
        }
    }
    
    
    @objc func onCloseButtonClicked(_button: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

}



extension ZLRepoSubContentController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewCell : ZLRepoContentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoContentTableViewCell", for: indexPath)  as? ZLRepoContentTableViewCell else
        {
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }
        
        tableViewCell.setCellData(cellData: self.contentArray?[indexPath.row])
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let contentModel : ZLGithubContentModel = self.contentArray?[indexPath.row] else
        {
            return
        }
        
        if "dir" == contentModel.type
        {
            let nextController = ZLRepoSubContentController.init(repoFullName: self.repoFullName, path: contentModel.path, branch: self.branch)
            self.navigationController?.pushViewController(nextController, animated: true)
        }
        else if "file" == contentModel.type
        {
            let controller = ZLRepoCodePreview3Controller.init(repoFullName: self.repoFullName, contentModel: contentModel, branch: self.branch)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
