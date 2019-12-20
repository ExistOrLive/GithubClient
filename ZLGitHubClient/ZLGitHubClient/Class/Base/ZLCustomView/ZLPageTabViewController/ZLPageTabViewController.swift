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
    var tabTitleFont : UIFont = UIFont.init(name: Font_PingFangSCMedium, size: 12) ?? UIFont.init()
    var tabTitleColor : UIColor = UIColor.black
    var tabTitleSpace : CGFloat = 40
    
    
    
}



class ZLPageTabViewController: UIViewController {
    
    private var _mainPageView : UIScrollView?
    private var _headTabView : UIScrollView?
    private var titleLabelArray : [UILabel] = []
    
    var config : ZLPageTabViewConfig = ZLPageTabViewConfig()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        self.headTabView().frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.config.tabViewHeight)
        self.mainPageView().frame = CGRect.init(x: 0, y: self.config.tabViewHeight, width: self.view.frame.size.width, height: self.view.frame.size.height - self.config.tabViewHeight)
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        
        var lastLabel = self.titleLabelArray.last
        
        
        
        
    }
    
    
    func setUpUI()
    {
        self.view.addSubview(self.headTabView())
        self.view.addSubview(self.mainPageView())
        
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
            scrollView.isPagingEnabled = true
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.bounces = true
            scrollView.backgroundColor = UIColor.clear
            scrollView.delegate = self
            
            self._mainPageView = scrollView
        }
        return self._mainPageView!
    }
    
}



extension ZLPageTabViewController : UIScrollViewDelegate
{
    
}
