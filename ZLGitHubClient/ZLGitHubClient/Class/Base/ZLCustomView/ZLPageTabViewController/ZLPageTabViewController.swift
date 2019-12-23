//
//  ZLPageTabViewController.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/20.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLPageTabViewConfig : NSObject
{
    var tabViewHeight : CGFloat  = 50
    var tabTitleSelectedFont : UIFont = UIFont.init(name: Font_PingFangSCMedium, size: 12) ?? UIFont.init()
    var tabTitleUnSelectedFont : UIFont = UIFont.init(name: Font_PingFangSCRegular, size: 12) ?? UIFont.init()
    var tabTitleSeletedColor : UIColor = UIColor.black
    var tabTitleUnSelectedColor : UIColor = UIColor.gray
    var tabTitleSpace : CGFloat = 40
    
}

@objcMembers class ZLPageTabViewController: UIViewController {
    
    private var _mainPageView : UIScrollView?
    private var _headTabView : UIScrollView?
    private var titleButtonArray : [UIButton] = []
    private var pageViewArray : [UIView] = []
    
    var config : ZLPageTabViewConfig = ZLPageTabViewConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        
    }
        
    override func addChildViewController(_ childController: UIViewController) {
        
        super.addChildViewController(childController)
        
        let lastButton = self.titleButtonArray.last
       
        let selectedAttributedStr = NSAttributedString.init(string: childController.title ?? "" , attributes:[NSAttributedStringKey.font:self.config.tabTitleSelectedFont,NSAttributedStringKey.foregroundColor:self.config.tabTitleSeletedColor] )
        let unselectedAttributedStr = NSAttributedString.init(string: childController.title ?? "" , attributes:[NSAttributedStringKey.font:self.config.tabTitleUnSelectedFont,NSAttributedStringKey.foregroundColor:self.config.tabTitleUnSelectedColor] )
        let rect = selectedAttributedStr.boundingRect(with: CGSize.init(width: Int.max, height: Int(self.config.tabViewHeight)), options: .usesLineFragmentOrigin, context: nil)
        
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(selectedAttributedStr, for: .selected)
        button.setAttributedTitle(unselectedAttributedStr, for: .normal)
        
        self.headTabView().addSubview(button)
        
        if lastButton == nil
        {
            button.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(self.config.tabTitleSpace / 2)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(rect.width)
            }
        }
        else
        {
            button.snp.makeConstraints { (make) in
                make.left.equalTo(lastButton!.snp_right).offset(self.config.tabTitleSpace)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(rect.width)
            }
        }

        self.titleButtonArray.append(button)
        
        let lastView = self.pageViewArray.last
        let view = childController.view
        self.mainPageView().addSubview(view!)
        
        if lastView == nil
        {
            view!.snp.makeConstraints { (make) in
                make.left.top.width.height.equalToSuperview()
            }
        }
        else
        {
            view!.snp_makeConstraints { (make) in
                make.leading.equalTo(lastView!.snp_trailing)
                make.top.width.height.equalToSuperview()
            }
        }
        
        self.pageViewArray.append(view!)
        
    }
    
    func setUpUI()
    {
        self.view.addSubview(self.headTabView())
          self.headTabView().snp.makeConstraints { (make) in
              make.top.left.right.equalToSuperview()
              make.height.equalTo(self.config.tabViewHeight)
          }
          
          self.view.addSubview(self.mainPageView())
          self.mainPageView().snp.makeConstraints { (make) in
              make.left.bottom.right.equalToSuperview()
              make.top.equalTo(self.headTabView().snp_bottom)
          }
        
    }

    func headTabView() -> UIScrollView
    {
        if(self._headTabView == nil)
        {
            let scrollView = UIScrollView()
            
            self._headTabView = scrollView
        }
        return self._headTabView!
    }
    
    func mainPageView() -> UIScrollView
    {
        if(self._mainPageView == nil)
        {
            let scrollView = UIScrollView()
//            scrollView.isPagingEnabled = true
//            scrollView.showsVerticalScrollIndicator = false
//            scrollView.showsHorizontalScrollIndicator = false
//            scrollView.bounces = true
//            scrollView.backgroundColor = UIColor.clear
//            scrollView.delegate = self
            
            self._mainPageView = scrollView
        }
        return self._mainPageView!
    }
    
}



extension ZLPageTabViewController : UIScrollViewDelegate
{
    
}
