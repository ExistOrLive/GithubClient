//
//  ZLAssistButtonManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/5.
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



@objcMembers class ZLAssistButtonManager: NSObject {
    
    private let floatButtonView : ZLFloatView
    private let assistButton : UIButton
    
    private var floatCircleWindow : ZLFloatWindow?
    
    private var buttonTypes : [ZLAssistButtonType]?
    
    override init() {
        floatButtonView = ZLFloatView.init()
        assistButton = UIButton.init(type: .custom)
        super.init()
        
        let config = ZLFloatViewConfig()
        config.bounces = true
        floatButtonView.config = config
        floatButtonView.frame = CGRect(x: 0, y: ZLKeyWindowHeight / 2, width: 60, height: 60)
        
        assistButton.setImage(UIImage(named:"assitbutton"), for: .normal)
        assistButton.addTarget(self, action: #selector(onAssistButtonClicked), for: .touchUpInside)
        assistButton.bounds = CGRect(x: 0, y: 0, width: 55, height: 55)
        assistButton.center = CGPoint(x: 30, y: 30)
        assistButton.backgroundColor = UIColor.clear
        floatButtonView.addSubview(assistButton)
    }
    
    func setHidden(_ hidden : Bool){
        self.floatButtonView.isHidden = hidden
    }
    
    
    deinit {
        self.floatButtonView.isHidden = true
        self.floatButtonView.removeFromSuperview()
    }
    
    
    func onAssistButtonClicked(){
        
        if(self.floatCircleWindow == nil){
            
            self.floatButtonView.isHidden = true
            
            let topVC = UIViewController.getTop()
            if topVC?.isKind(of: UITabBarController.self) ?? false {
                self.buttonTypes = [.pasteboard,.search,.setting]
            } else if topVC?.isKind(of: ZLSettingController.self) ?? false {
                self.buttonTypes = [.home,.search,.pasteboard]
            } else if topVC?.isKind(of: ZLSearchController.self) ?? false {
                self.buttonTypes = [.home,]
            }
            
            
            self.floatCircleWindow = ZLFloatWindow()
            self.floatCircleWindow?.backgroundColor = ZLRGBValueStr_H(colorValue: "000000", alphaValue: 0.2)
            self.floatCircleWindow?.frame = UIApplication.shared.delegate?.window??.bounds ?? UIScreen.main.bounds
            
            let width = self.floatCircleWindow!.frame.size.width
            let height = self.floatCircleWindow!.frame.size.height
            let frame = CGRect(x: width / 2 - 25, y: height / 2 - 25, width: 50, height: 50)
            let circlrMenu = CircleMenu(frame: frame, normalIcon: nil, selectedIcon: "assist-close", buttonsCount: 4, duration: 0.3, distance: 100)
            circlrMenu.delegate = self
            self.floatCircleWindow?.rootViewController?.view.addSubview(circlrMenu)

            self.floatCircleWindow?.isHidden = false
            
            circlrMenu.sendActions(for: .touchUpInside)
        }
    }
    
    
}

extension ZLAssistButtonManager : CircleMenuDelegate {
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int){
        button.backgroundColor = UIColor.red
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
        self.floatButtonView.isHidden = false
        self.floatCircleWindow?.isHidden = true
        self.floatCircleWindow = nil
    }

    /**
     Tells the delegate that the menu was collapsed - the cancel action. Fires immediately on button press

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     */
    func menuCollapsed(_ circleMenu: CircleMenu){
        self.floatButtonView.isHidden = false
        self.floatCircleWindow?.isHidden = true
        self.floatCircleWindow = nil
    }

    /**
     Tells the delegate that the menu was opened. Fires immediately on button press

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     */
    func menuOpened(_ circleMenu: CircleMenu){

    }
}
