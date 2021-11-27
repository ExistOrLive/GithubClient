//
//  ZLRepoBranchesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoBranchesView: ZLBaseView {

    // view
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // model
    private var branches : [ZLGithubRepositoryBranchModel]?
    private var currentBranch : String?
    private var handle : ((String) -> Void)?
    private weak var popup : FFPopup?
    
    class func showRepoBranchedView(repoFullName: String, currentBranch: String, handle:((String) -> Void)?)
    {
        SVProgressHUD.show()
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepositoryBranchesInfo(withFullName: repoFullName, serialNumber: NSString.generateSerialNumber(), completeHandle: { (model : ZLOperationResultModel) in
           
            SVProgressHUD.dismiss()
            
            if model.result == false{
                guard let errorModel : ZLGithubRequestErrorModel = model.data as?  ZLGithubRequestErrorModel else
                {
                    return
                }
                ZLToastView.showMessage("query branches status[\(errorModel.statusCode)] message[\(errorModel.message)]");
                return
            }
            
            guard let branches : [ZLGithubRepositoryBranchModel] = model.data as? [ZLGithubRepositoryBranchModel] else{
                return
            }
            
            guard let view : ZLRepoBranchesView = Bundle.main.loadNibNamed("ZLRepoBranchesView", owner: nil, options: nil)?.first as? ZLRepoBranchesView else{
                return;
            }

            view.showWith(repoFullName: repoFullName, currentBranch: currentBranch, branches: branches, handle: handle)
        })
    }
    
    func showWith(repoFullName: String, currentBranch: String, branches : [ZLGithubRepositoryBranchModel],handle:((String) -> Void)?)
    {
        self.branches = branches
        self.handle = handle
        self.currentBranch = currentBranch
        self.tableView.reloadData()
        
        self.frame = CGRect.init(x: 0, y: 0, width: 280, height: 320)
        let popup = FFPopup(contentView: self, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        self.popup = popup
        popup.show(layout: .Center)
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.titleLabel.text = ZLLocalizedString(string: "branch", comment: "分支")
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(ZLRepoBranchTableViewCell.self, forCellReuseIdentifier: "ZLRepoBranchTableViewCell")
        self.tableView.separatorStyle = .none
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        
    }
    

}

extension ZLRepoBranchesView : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.branches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLRepoBranchTableViewCell", for: indexPath)
        guard let cell : ZLRepoBranchTableViewCell = tableViewCell as? ZLRepoBranchTableViewCell else
        {
            return tableViewCell
        }
        
        cell.branchNameLabel.text = self.branches?[indexPath.row].name
        cell.isSelected = ((self.branches?[indexPath.row].name) == self.currentBranch)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data : ZLGithubRepositoryBranchModel = self.branches?[indexPath.row] else
        {
            return
        }
        
        if self.handle != nil
        {
            self.handle?(data.name)
        }
        
        self.popup?.dismiss(animated: true)
        
    }
}
