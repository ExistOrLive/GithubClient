//
//  ZLRepoHeaderInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoHeaderInfoViewModel: ZLBaseViewModel {
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    // view
    private var repoHeaderInfoView : ZLRepoHeaderInfoView?

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        guard let repoHeaderInfoView : ZLRepoHeaderInfoView = targetView as? ZLRepoHeaderInfoView else
        {
            return
        }
        self.repoHeaderInfoView = repoHeaderInfoView
        self.repoHeaderInfoView?.delegate = self
        
        self.setViewDataForRepoHeaderInfoView()
        
        self.getRepoWatchStatus()
        self.getRepoStarStatus()
    }
    
     func setViewDataForRepoHeaderInfoView()
     {
        self.repoHeaderInfoView?.headImageView.sd_setImage(with: URL.init(string: self.repoInfoModel?.owner.avatar_url ?? ""), placeholderImage: UIImage.init(named: "default_avatar"));
        self.repoHeaderInfoView?.repoNameLabel.text = self.repoInfoModel?.full_name
        self.repoHeaderInfoView?.descLabel.text = self.repoInfoModel?.desc_Repo
        self.repoHeaderInfoView?.issuesNumLabel.text = "\(self.repoInfoModel?.open_issues_count ?? 0)"
        self.repoHeaderInfoView?.watchersNumLabel.text = "\(self.repoInfoModel?.subscribers_count ?? 0)"
        self.repoHeaderInfoView?.starsNumLabel.text = "\(self.repoInfoModel?.stargazers_count ?? 0)"
        self.repoHeaderInfoView?.forksNumLabel.text = "\(self.repoInfoModel?.forks_count ?? 0)"
             
        guard let date : NSDate = self.repoInfoModel?.updated_at as NSDate? else
        {
                 return
        }
             
        let timeStr = NSString.init(format: "%@%@", ZLLocalizedString(string: "update at", comment: "更新于"),date.dateLocalStrSinceCurrentTime())
        self.repoHeaderInfoView?.timeLabel.text = timeStr as String
     }
}


extension ZLRepoHeaderInfoViewModel : ZLRepoHeaderInfoViewDelegate
{
    func onZLRepoHeaderInfoViewEvent(event: ZLRepoHeaderInfoViewEvent){
        switch event{
        case .copy: break
        case .issue: do {
            let vc : ZLRepoIssuesController = ZLRepoIssuesController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case .star: break
        case .watch: break
        case .watchAction:do{
            if self.repoHeaderInfoView?.watchButton.isSelected == true {
                self.watchRepo(watch: false)
            } else {
                self.watchRepo(watch: true)
            }
            }
        case .starAction:do {
            if self.repoHeaderInfoView?.starButton.isSelected == true {
                self.starRepo(star: false)
            } else {
                self.starRepo(star: true)
            }
        }
        case .forkAction:do {
            
        }
            
        }
    }
}

extension ZLRepoHeaderInfoViewModel{
    func getRepoWatchStatus() -> Void {
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getRepoWatchStatus(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if(resultModel.result) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                weakSelf?.repoHeaderInfoView?.watchButton.isSelected = data["isWatch"] ?? false
            } else {
                
            }
            
        })
    }
    
    
    func watchRepo(watch:Bool) -> Void {
        weak var weakSelf = self
        
        if watch == true {
            
            SVProgressHUD.show()
            ZLRepoServiceModel.shared().watchRepo(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    weakSelf?.repoHeaderInfoView?.watchButton.isSelected = true
//                    weakSelf?.repoInfoModel?.subscribers_count += 1
//                    weakSelf?.repoHeaderInfoView?.watchersNumLabel.text = "\(weakSelf?.repoInfoModel?.subscribers_count ?? 0)"
                    ZLToastView.showMessage(ZLLocalizedString(string: "Watch Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Watch Fail", comment: ""))
                }
            } )
            
        } else {
            SVProgressHUD.show()
            ZLRepoServiceModel.shared().unwatchRepo(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    weakSelf?.repoHeaderInfoView?.watchButton.isSelected = false
//                    weakSelf?.repoInfoModel?.subscribers_count -= 1
//                    weakSelf?.repoHeaderInfoView?.watchersNumLabel.text = "\(weakSelf?.repoInfoModel?.subscribers_count ?? 0)"
                    
                     ZLToastView.showMessage(ZLLocalizedString(string: "Unwatch Success", comment: ""))
                } else {
                     ZLToastView.showMessage(ZLLocalizedString(string: "Unwatch Fail", comment: ""))
                }
            })
            
        }
    }
    
    
    func getRepoStarStatus() -> Void {
        weak var weakSelf = self
        ZLRepoServiceModel.shared().getRepoStarStatus(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            
            if(resultModel.result) {
                guard let data : [String:Bool] = resultModel.data as? [String:Bool] else {
                    return
                }
                weakSelf?.repoHeaderInfoView?.starButton.isSelected = data["isStar"] ?? false
            } else {
                
            }
            
        })
    }
    
    
    func starRepo(star:Bool) -> Void {
        weak var weakSelf = self
        
        if star == true {
            
            SVProgressHUD.show()
            ZLRepoServiceModel.shared().starRepo(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                
                if resultModel.result {
                    weakSelf?.repoHeaderInfoView?.starButton.isSelected = true
//                    weakSelf?.repoInfoModel?.stargazers_count += 1
//                    weakSelf?.repoHeaderInfoView?.starsNumLabel.text = "\(weakSelf?.repoInfoModel?.stargazers_count ?? 0)"
                    ZLToastView.showMessage(ZLLocalizedString(string: "Star Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Star Fail", comment: ""))
                }
            } )
            
        } else {
            SVProgressHUD.show()
            ZLRepoServiceModel.shared().unstarRepo(withFullName: self.repoInfoModel!.full_name, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
                SVProgressHUD.dismiss()
                if resultModel.result {
                    weakSelf?.repoHeaderInfoView?.starButton.isSelected = false
//                    weakSelf?.repoInfoModel?.stargazers_count -= 1
//                    weakSelf?.repoHeaderInfoView?.starsNumLabel.text = "\(weakSelf?.repoInfoModel?.stargazers_count ?? 0)"
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unstar Success", comment: ""))
                } else {
                    ZLToastView.showMessage(ZLLocalizedString(string: "Unstar Fail", comment: ""))
                }
            })
            
        }
    }
    
}
