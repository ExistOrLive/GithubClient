//
//  ZLAssistController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/20.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import CircleMenu


enum ZLAssistButtonType{
    case home
    case search
    case setting
    case pasteboard
}


class ZLAssistController: ZLBaseViewController {
    
    private var pasteURL : URL?
    
    private var buttonTypes : [ZLAssistButtonType]?
    private var circleMenu : CircleMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCircleMenu()
        
        if let url = URL(string: UIPasteboard.general.string ?? "") {
            if url.host != "www.github.com" &&
                url.host != "github.com" {
                return
            }
            self.pasteURL = url
            self.setPasteURLView()
        }
    }
    
    func setPasteURLView(){
        let label = UILabel()
        label.text = ZLLocalizedString(string: "ClipBoard" , comment: "")
        label.textColor = UIColor(named: "ZLLabelColor1")
        label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(30)
        }
        
        let button = UIButton(type: .custom)
        button.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor(named: "ZLCellBack")
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "assist-pasteboard1")
        button.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20 , height: 20))
        }
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(named: "ZLLinkLabelColor1")
        titleLabel.text = self.pasteURL?.absoluteString
        titleLabel.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
        titleLabel.numberOfLines = 2
        button.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp_right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
                
        self.contentView.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(label.snp_bottom).offset(15)
            make.height.equalTo(80)
        }
        
        
        button.addTarget(self, action: #selector(ZLAssistController.onPasteURLButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func onPasteURLButtonClicked() {
        ZLAssistButtonManager.shared.dismissAssistDetailView()
        ZLUIRouter.openURL(url: self.pasteURL!)
    }
    
    func setCircleMenu() {
        
        let topVC = UIViewController.getTop()
        if topVC?.vcKey == ZLUIRouter.WorkboardViewController ||
            topVC?.vcKey == ZLUIRouter.NotificationViewController ||
            topVC?.vcKey == ZLUIRouter.ExploreViewController ||
            topVC?.vcKey == ZLUIRouter.ProfileViewController  {
            self.buttonTypes = [.pasteboard,.search,.setting]
        } else if topVC?.vcKey == ZLUIRouter.SettingController ||
                    topVC?.vcKey == ZLUIRouter.AppearanceController  {
            self.buttonTypes = [.home,.search,.pasteboard]
        } else if topVC?.vcKey == ZLUIRouter.SearchController  {
            self.buttonTypes = [.home,.pasteboard,.setting]
        } else {
            self.buttonTypes = [.home,.search,.pasteboard,.setting]
        }
        
        
        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let tmpcirclrMenu = CircleMenu(frame: frame, normalIcon: nil, selectedIcon: "assist-close", buttonsCount:self.buttonTypes?.count ?? 0, duration: 0.3, distance: 120)
        tmpcirclrMenu.backgroundColor = UIColor(named: "ZLBaseButtonBorderColor")
        tmpcirclrMenu.clipsToBounds = true
        tmpcirclrMenu.cornerRadius = 30
        tmpcirclrMenu.delegate = self
        self.contentView.addSubview(tmpcirclrMenu)
        
        tmpcirclrMenu.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.contentView.snp_bottomMargin).offset(-180);
        }
        
        tmpcirclrMenu.sendActions(for: .touchUpInside)
        circleMenu = tmpcirclrMenu
    }

    
}


extension ZLAssistController : CircleMenuDelegate {
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int){
        
        button.tag = atIndex
        switch self.buttonTypes?[atIndex] {
        case .home:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x337DDB)
            button.setImage(UIImage(named: "assist-home"), for: .normal)
        case .search:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x52A019)
            button.setImage(UIImage(named: "assist-search"), for: .normal)
        case .pasteboard:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0xCE3B40)
            button.setImage(UIImage(named: "assist-pasteboard"), for: .normal)
        case .setting:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x7445DA)
            button.setImage(UIImage(named: "assist-setting"), for: .normal)
        case .none:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x337DDB)
            button.setImage(UIImage(named: "assist-home"), for: .normal)
        }
    }

    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int){
        
    }

    /**
     Tells the delegate that the specified index is now selected.

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     - parameter button:     A selected circle menu button. Don't change button.tag
     - parameter atIndex:    Selected button index
     */
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int){
        
        ZLAssistButtonManager.shared.dismissAssistDetailView()
        
        let topVC = UIViewController.getTop()
        switch self.buttonTypes?[atIndex] {
        case .home:
            topVC?.navigationController?.popToRootViewController(animated: true)
            break
        case .search:
            if let searchVC = ZLUIRouter.getVC(key: ZLUIRouter.SearchController){
                searchVC.hidesBottomBarWhenPushed = true
                topVC?.navigationController?.pushViewController(searchVC, animated: true)
            }
            break
        case .pasteboard:
            break
        case .setting:
            if let settingVC = ZLUIRouter.getVC(key: ZLUIRouter.SettingController){
                settingVC.hidesBottomBarWhenPushed = true
                topVC?.navigationController?.pushViewController(settingVC, animated: true)
            }
            break
        case .none:
            break
        }
    }

    /**
     Tells the delegate that the menu was collapsed - the cancel action. Fires immediately on button press

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     */
    func menuCollapsed(_ circleMenu: CircleMenu){
        ZLAssistButtonManager.shared.dismissAssistDetailView()
    }

    /**
     Tells the delegate that the menu was opened. Fires immediately on button press

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     */
    func menuOpened(_ circleMenu: CircleMenu){

    }
    
}
