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
        self.repoHeaderInfoView?.headImageButton.sd_setImage(with: URL.init(string: self.repoInfoModel?.owner.avatar_url ?? ""), for: .normal, placeholderImage: UIImage.init(named: "default_avatar"))
        
        
        self.repoHeaderInfoView?.descLabel.text = self.repoInfoModel?.desc_Repo
        self.repoHeaderInfoView?.issuesNumLabel.text = "\(self.repoInfoModel?.open_issues_count ?? 0)"
        self.repoHeaderInfoView?.watchersNumLabel.text = "\(self.repoInfoModel?.subscribers_count ?? 0)"
        self.repoHeaderInfoView?.starsNumLabel.text = "\(self.repoInfoModel?.stargazers_count ?? 0)"
        self.repoHeaderInfoView?.forksNumLabel.text = "\(self.repoInfoModel?.forks_count ?? 0)"
        
        
        self.repoHeaderInfoView?.repoNameLabel.text = self.repoInfoModel?.full_name
        
        
        
        if self.repoInfoModel?.sourceRepoFullName?.count ?? 0 != 0 {
            let attributedStr = NSMutableAttributedString.init(string: self.repoInfoModel?.full_name ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor1") ?? ZLRGBValue_H(colorValue: 0x333333),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 16) ?? UIFont.systemFont(ofSize: 16)])
            
            let forkStr = NSMutableAttributedString.init(string: "\nforked from ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor3") ?? ZLRGBValue_H(colorValue:0x666666),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 13) ?? UIFont.systemFont(ofSize: 13)])
            
            attributedStr.append(forkStr)
            
            let sourceRepoStr = NSMutableAttributedString.init(string: self.repoInfoModel?.sourceRepoFullName ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor.init(named: "ZLLabelColor1") ?? ZLRGBValue_H(colorValue: 0x333333),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCMedium, size: 13) ?? UIFont.systemFont(ofSize: 13)])
            
            weak var weakSelf = self
            sourceRepoStr.yy_setTextHighlight(NSRange.init(location: 0, length: self.repoInfoModel?.sourceRepoFullName?.count ?? 0), color: UIColor.init(named: "ZLLinkLabelColor1") ?? ZLRGBValue_H(colorValue: 0x0666D6), backgroundColor: UIColor.init(named: "ZLLinkLabelColor1") ?? ZLRGBValue_H(colorValue: 0x0666D6), tapAction: {(containerView : UIView, text : NSAttributedString, range: NSRange, rect : CGRect) in
                let repoVC = ZLRepoInfoController.init(repoFullName: weakSelf?.repoInfoModel?.sourceRepoFullName ?? "")
                weakSelf?.viewController?.navigationController?.pushViewController(repoVC, animated: true)
            })
            attributedStr.append(sourceRepoStr)
            
            self.repoHeaderInfoView?.repoNameLabel.attributedText = attributedStr
        }
        
             
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
        case .copy: do {
            let vc : ZLRepoForkedReposController = ZLRepoForkedReposController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .issue: do {
            let vc : ZLRepoIssuesController = ZLRepoIssuesController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
        case .star: do {
            let vc : ZLRepoStargazersController = ZLRepoStargazersController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        case .watch: do {
            let vc : ZLRepoWatchedUsersController = ZLRepoWatchedUsersController.init()
            vc.repoFullName = self.repoInfoModel?.full_name
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
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
            self.forkRepo()
        }
        case .imageAction:do{
            if self.repoInfoModel?.owner.loginName != nil {
                let vc = ZLUserInfoController.init(loginName: self.repoInfoModel!.owner.loginName, type: self.repoInfoModel!.owner.type)
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
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
    
    
    func forkRepo() {
        SVProgressHUD.show()
        
        ZLRepoServiceModel.shared().forkRepository(withFullName: self.repoInfoModel!.full_name, org: nil, serialNumber: NSString.generateSerialNumber(), completeHandle: {(resultModel : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            
            if(resultModel.result) {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Success", comment: "拷贝成功"))
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Fork Fail", comment: "拷贝失败"))
            }
            
        })
    }
    
}
