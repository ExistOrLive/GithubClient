//
//  ZLRepoInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLRepoInfoItemType : Int {
    case file                   // 仓库文件
    case pullRequest            // pullrequest
    case branch                 // 分支
}

class ZLRepoInfoViewModel: ZLBaseViewModel {
    
    // view
    private var repoInfoView : ZLRepoInfoView?
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    
    deinit {
        ZLRepoServiceModel.shared().unRegisterObserver(self, name: ZLGetSpecifiedRepoInfoResult_Notification)
        
//        self.repoInfoView?.footerView?.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLRepoInfoView)
        {
            ZLLog_Warn("targetView is not ZLRepoInfoView")
            return
        }
        
        self.repoInfoView = targetView as? ZLRepoInfoView
        self.repoInfoView?.tableView.delegate = self
        self.repoInfoView?.tableView.dataSource = self
        self.repoInfoView?.footerView?.webView.delegate  = self
        
        guard let repoInfoModel: ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else
        {
            ZLLog_Warn("targetModel is not ZLGithubRepositoryModel,so return")
            return
        }
        
        self.setViewDataForRepoInfoView(model: repoInfoModel, view: self.repoInfoView!)
        
        ZLRepoServiceModel.shared().registerObserver(self, selector: #selector(onNotificationArrived(notification:)), name: ZLGetSpecifiedRepoInfoResult_Notification)
        
        // 获取仓库的详细信息
        ZLRepoServiceModel.shared().getRepoInfo(withFullName: repoInfoModel.full_name, serialNumber: "dasda")
        
        // 加载readme
        self.loadREADME()
        
    }
    
    
    @IBAction func onBackButtonClicked(_ sender: Any) {
        
        self.viewController?.navigationController?.popViewController(animated: true)
        
    }
}


extension ZLRepoInfoViewModel
{
    func setViewDataForRepoInfoView(model:ZLGithubRepositoryModel, view:ZLRepoInfoView)
    {
        self.repoInfoModel = model
        
        view.headerView?.headImageView.sd_setImage(with: URL.init(string: model.owner.avatar_url), placeholderImage: nil);
        view.headerView?.repoNameLabel.text = model.name
        view.headerView?.descLabel.text = model.desc_Repo
        view.headerView?.issuesNumLabel.text = "\(model.open_issues_count)"
        view.headerView?.watchersNumLabel.text = "\(model.subscribers_count)"
        view.headerView?.starsNumLabel.text = "\(model.stargazers_count)"
        view.headerView?.forksNumLabel.text = "\(model.forks_count)"
        
        let timeStr = NSString.init(format: "%@%@", ZLLocalizedString(string: "update ", comment: "更新于"),(model.updated_at as NSDate).dateLocalStrSinceCurrentTime())
        view.headerView?.timeLabel.text = timeStr as String
        
    }
}

// MARK: README
extension ZLRepoInfoViewModel : UIWebViewDelegate
{
    static var httpSessionManager : AFHTTPSessionManager?
    func loadREADME()
    {
        if ZLRepoInfoViewModel.httpSessionManager == nil
        {
            ZLRepoInfoViewModel.httpSessionManager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
            ZLRepoInfoViewModel.httpSessionManager?.responseSerializer = AFHTTPResponseSerializer()
        }
        
        let URLStr = "https://raw.githubusercontent.com/\(self.repoInfoModel!.full_name)/\(self.repoInfoModel!.default_branch)/README.md"
        
        ZLRepoInfoViewModel.httpSessionManager?.get(URLStr, parameters: nil, progress:{(progess:Progress) in
            
        }, success: { (task : URLSessionTask, reponseObject:Any?) in
            
            if reponseObject != nil && reponseObject is Data
            {
                let str = String.init(data: reponseObject as! Data, encoding: .utf8)
                if(str != nil)
                {
                    do{
                        let htmlStr = try MMMarkdown.htmlString(withMarkdown: str!, extensions: MMMarkdownExtensions.gitHubFlavored)
                        self.repoInfoView?.footerView?.webView.loadHTMLString(htmlStr, baseURL: nil)
                    }
                    catch
                    {
                        
                    }
                }
                else
                {
                    ZLLog_Warn("readme data is nil");
                }
                
                
            }
            else
            {
                ZLLog_Warn("readme data is nil");
            }
        }, failure: { (task : URLSessionTask?, error :Error) in
            
            self.repoInfoView?.footerView?.webView.loadHTMLString("something error", baseURL: nil)
        })
    }
    


    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool
    {
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let contentSize = self.repoInfoView?.footerView?.webView.scrollView.contentSize
        self.repoInfoView?.footerView?.frame.size.height = contentSize!.height + 70
        
        self.repoInfoView?.tableView.reloadData()
    }
    

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        let contentSize = self.repoInfoView?.footerView?.webView.scrollView.contentSize
        self.repoInfoView?.footerView?.frame.size.height = contentSize!.height + 70
        
        self.repoInfoView?.tableView.reloadData()
    }
    
}

// MARK: UITableViewDelegate,UITableViewDataSource
extension ZLRepoInfoViewModel: UITableViewDelegate,UITableViewDataSource
{
    static let itemsTypes: [ZLRepoInfoItemType] = [.file, .pullRequest, .branch]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ZLRepoInfoViewModel.itemsTypes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell : ZLRepoInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoInfoTableViewCell", for: indexPath) as! ZLRepoInfoTableViewCell
        
        if(indexPath.row == ZLRepoInfoViewModel.itemsTypes.count - 1)
        {
           tableViewCell.singleLineView.isHidden = true
        }
        else
        {
            tableViewCell.singleLineView.isHidden = false
        }
        
        let itemType = ZLRepoInfoViewModel.itemsTypes[indexPath.row]
        
        switch(itemType)
        {
        case .file:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "code", comment: "代码")
            tableViewCell.repoInfoDetailLabel.text = self.repoInfoModel?.language
            }
        case .pullRequest:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "pull request", comment: "合并请求")
            //tableViewCell.repoInfoDetailLabel.text = "\(self.repoInfoModel)"
            }
        case .branch:do{
            tableViewCell.repoInfoTypeLabel.text = ZLLocalizedString(string: "branch", comment: "分支")
            tableViewCell.repoInfoDetailLabel.text = self.repoInfoModel?.default_branch
            }
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
}


extension ZLRepoInfoViewModel
{
    @objc func onNotificationArrived(notification: Notification)
    {
        switch(notification.name)
        {
        case ZLGetSpecifiedRepoInfoResult_Notification:do
        {
            let operationResultModel : ZLOperationResultModel = notification.params as! ZLOperationResultModel
            
            guard let repoInfo : ZLGithubRepositoryModel = operationResultModel.data as? ZLGithubRepositoryModel else
            {
                ZLLog_Warn("data of operationResultModel is not ZLGithubRepositoryModel,so return")
                return
            }
            
            self.setViewDataForRepoInfoView(model: repoInfo, view: self.repoInfoView!)
            }
        default:
            break;
        }
        
      
    }
}
