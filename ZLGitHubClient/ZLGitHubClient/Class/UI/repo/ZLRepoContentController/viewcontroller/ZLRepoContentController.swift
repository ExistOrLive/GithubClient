//
//  ZLRepoContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoContentNode : ZLBaseObject {
    var path : String = ""
    var name : String = ""
    var content : ZLGithubContentModel?
    var subNodes : [ZLRepoContentNode]?
    var parentNode : ZLRepoContentNode?
}

class ZLRepoContentController: ZLBaseViewController {
    
    // model
    var repoFullName : String?
    var path : String?
    var branch : String?
    

    // view
    
    var rootContentNode : ZLRepoContentNode?
    var currentContentNode : ZLRepoContentNode?
    
    var tableView : UITableView?
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        guard repoFullName != nil && path != nil else {
            return
        }
        
        self.generateContentTree()
        
        self.setUpUI()
        
        self.tableView?.mj_header?.beginRefreshing()
        
    }
    
    func generateContentTree() {
        
        self.rootContentNode = ZLRepoContentNode()
        self.currentContentNode = rootContentNode
 
        let nameArray : [Substring] =  path!.split(separator: "/")
        
        var tmpPath = ""
        for name in nameArray{
            tmpPath.append(contentsOf: name)
            let node = ZLRepoContentNode()
            node.name = String(name)
            node.path = tmpPath
            node.parentNode = self.currentContentNode
            self.currentContentNode = node
            tmpPath.append("/")
        }
    }
    
    func setUpUI()
    {
        self.title = self.currentContentNode?.name == ""  ? "/" : self.currentContentNode?.name
        
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
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryContentsInfo(withFullName: self.repoFullName!,path: self.currentContentNode!.path,branch:self.branch!,serialNumber: NSString.generateSerialNumber(),completeHandle: {[weak weakSelf = self](resultModel : ZLOperationResultModel) in
            
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
            
            var nodeArray : [ZLRepoContentNode] = []
            for tmpData in data {
                let contentNode = ZLRepoContentNode()
                contentNode.name = tmpData.name
                contentNode.path = tmpData.path
                contentNode.parentNode = weakSelf?.currentContentNode
                contentNode.content = tmpData
                nodeArray.append(contentNode)
            }
            weakSelf?.currentContentNode?.subNodes = nodeArray
    
            weakSelf?.tableView?.reloadData()
        })
    }
    
    
    func reloadData() {
        self.title = self.currentContentNode?.name == ""  ? "/" : self.currentContentNode?.name
        
        let block = {
            self.tableView?.reloadData()
            if self.currentContentNode?.subNodes == nil {
                self.tableView?.mj_header?.beginRefreshing()
            }
        }
        
        if self.tableView?.mj_header?.isRefreshing ?? false {
            self.tableView?.mj_header?.endRefreshing {
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



extension ZLRepoContentController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentContentNode?.subNodes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let tableViewCell : ZLRepoContentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoContentTableViewCell", for: indexPath)  as? ZLRepoContentTableViewCell else
        {
            return UITableViewCell.init(style: .default, reuseIdentifier: "")
        }
        
        tableViewCell.setCellData(cellData: self.currentContentNode?.subNodes?[indexPath.row].content)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let contentModel : ZLGithubContentModel = self.currentContentNode?.subNodes?[indexPath.row].content else{
            return
        }

        if "dir" == contentModel.type {
            self.currentContentNode = self.currentContentNode?.subNodes?[indexPath.row]
            self.reloadData()
        }
        else if "file" == contentModel.type
        {
            let controller = ZLRepoCodePreview3Controller.init(repoFullName: self.repoFullName!, contentModel: contentModel, branch: self.branch!)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
