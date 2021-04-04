//
//  ZLIssueInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLIssueInfoController: ZLBaseViewController {

    // input model
    @objc var login : String?
    @objc var repoName : String?
    @objc var number : Int = 0
    
    var after : String?
    
    // view
    var itemListView : ZLGithubItemListView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "Issue", comment: "")
        
        self.zlNavigationBar.backButton.isHidden = false
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "run_more"), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        
        self.zlNavigationBar.rightButton = button
        
        // view
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewHeader()
        itemListView.setTableViewFooter()
        itemListView.delegate = self
        self.contentView.addSubview(itemListView)
        itemListView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.itemListView = itemListView
        
        self.itemListView.beginRefresh()
    }
    
    @objc func onMoreButtonClick(button: UIButton) {
        
        let path = "https://www.github.com/\(login ?? "")/\(repoName ?? "")/issues/\(number )"
        let alertVC = UIAlertController.init(title: path, message: nil, preferredStyle: .actionSheet)
        alertVC.popoverPresentationController?.sourceView = button
        let alertAction1 = UIAlertAction.init(title: ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let webContentVC = ZLWebContentController.init()
            webContentVC.requestURL = URL.init(string: path)
            self.navigationController?.pushViewController(webContentVC, animated: true)
        }
        let alertAction2 = UIAlertAction.init(title:ZLLocalizedString(string:  "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: path)
            if url != nil {
                UIApplication.shared.open(url!, options: [:], completionHandler: {(result : Bool) in})
            }
        }
        
        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { (action : UIAlertAction) in
            let url =  URL.init(string: path)
            if url != nil {
                let activityVC = UIActivityViewController.init(activityItems: [url!], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = button
                activityVC.excludedActivityTypes = [.message,.mail,.openInIBooks,.markupAsPDF]
                self.present(activityVC, animated: true, completion: nil)
            }
        }
        
        let alertAction4 = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)
        
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        alertVC.addAction(alertAction4)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }

}


extension ZLIssueInfoController {
    override func getEvent(_ event: Any?, fromSubViewModel subViewModel: ZLBaseViewModel) {
        self.itemListView.reloadData()
    }
}

extension ZLIssueInfoController : ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        
        if login == nil ||
            repoName == nil  {
            self.itemListView.endRefreshWithError()
        }
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryIssueInfo(withLoginName: login!,
                                                                                 repoName: repoName!,
                                                                                 number: Int32(number),
                                                                                 after: nil,
                                                                                 serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                self?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? IssueInfoQuery.Data {
                   
                    self?.title = data.repository?.issue?.title
                    self?.after = data.repository?.issue?.timelineItems.pageInfo.endCursor
                    
                    let cellDatas : [ZLGithubItemTableViewCellData] = ZLIssueTableViewCellData.getCellDatasWithIssueModel(data: data, firstPage: true)
                    
                    self?.addSubViewModels(cellDatas)
                    self?.itemListView.resetCellDatas(cellDatas: cellDatas)
                    
                } else {
                    self?.itemListView.endRefreshWithError()
                }
            }
        }
    }
    
  
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) -> Void{
        
        if login == nil ||
            repoName == nil {
            self.itemListView.endRefreshWithError()
        }
        
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryIssueInfo(withLoginName: login!,
                                                                                 repoName: repoName!,
                                                                                 number: Int32(number),
                                                                                 after: after,
                                                                                 serialNumber: NSString.generateSerialNumber())
        { [weak self](resultModel : ZLOperationResultModel) in
            
            if resultModel.result == false {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel{
                    ZLToastView.showMessage(errorModel.message)
                }
                self?.itemListView.endRefreshWithError()
            } else {
                if let data = resultModel.data as? IssueInfoQuery.Data {
                   
                    self?.title = data.repository?.issue?.title
                    self?.after = data.repository?.issue?.timelineItems.pageInfo.endCursor
                    
                    let cellDatas : [ZLGithubItemTableViewCellData] = ZLIssueTableViewCellData.getCellDatasWithIssueModel(data: data, firstPage: false)
                    
                    self?.addSubViewModels(cellDatas)
                    self?.itemListView.appendCellDatas(cellDatas: cellDatas)
                    
                } else {
                    self?.itemListView.endRefreshWithError()
                }
            }
        }
        
        
    }
    
}

