//
//  ZLPageTabViewController.swift
//  ZLGitHubClient
//
//  Created by BeeCloud on 2019/12/20.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit


@objc protocol ZLPageTabViewControllerDelegate : NSObjectProtocol {
    @objc optional func didSelectViewAtIndex(index:Int, pageVC:ZLPageTabViewController);
}

class ZLPageTabViewConfig : NSObject
{
    var tabViewHeight : CGFloat  = 50
    var tabTitleSelectedFont : UIFont = UIFont.init(name: Font_PingFangSCMedium, size: 20) ?? UIFont.init()
    var tabTitleUnSelectedFont : UIFont = UIFont.init(name: Font_PingFangSCRegular, size: 18) ?? UIFont.init()
    var tabTitleSeletedColor : UIColor = UIColor.black
    var tabTitleUnSelectedColor : UIColor = UIColor.gray
    var tabTitleSpace : CGFloat = 40
    
}

@objcMembers class ZLPageTabViewController: UIViewController {
    
    private var _mainPageView : UIScrollView?
    private var _headTabView : UIScrollView?
    private var _mainPageStackView : UIStackView?
    private var _headTabStackView : UIStackView?
    
    private var titleButtonArray : [UIButton] = []
    private var pageViewArray : [UIView] = []
    private var viewHasLoad : Bool = false
    
    var config : ZLPageTabViewConfig = ZLPageTabViewConfig()
    
    var selectedIndex = 0
    
    weak var delegate : ZLPageTabViewControllerDelegate?
    
    
//MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.viewHasLoad = true
    }
    
    override func addChildViewController(_ childController: UIViewController) {
        super.addChildViewController(childController)
        
        if self.viewHasLoad
        {
            self.addViewForChildVC(childController: childController)
        }
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
        
        if self.childViewControllers.count > 0
        {
            for vc in self.childViewControllers
            {
                self.addViewForChildVC(childController: vc)
            }
            self.titleButtonArray[0].isSelected = true
        }
    }
    
    func addViewForChildVC(childController : UIViewController)
    {
        
        let selectedAttributedStr = NSAttributedString.init(string: childController.title ?? "" , attributes:[NSAttributedStringKey.font:self.config.tabTitleSelectedFont,NSAttributedStringKey.foregroundColor:self.config.tabTitleSeletedColor] )
        let unselectedAttributedStr = NSAttributedString.init(string: childController.title ?? "" , attributes:[NSAttributedStringKey.font:self.config.tabTitleUnSelectedFont,NSAttributedStringKey.foregroundColor:self.config.tabTitleUnSelectedColor] )
        let rect = selectedAttributedStr.boundingRect(with: CGSize.init(width: Int.max, height: Int(self.config.tabViewHeight)), options: .usesLineFragmentOrigin, context: nil)
        
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(selectedAttributedStr, for: .selected)
        button.setAttributedTitle(unselectedAttributedStr, for: .normal)
        button.tag = self.titleButtonArray.count
        button.addTarget(self, action: #selector(self.onTitleButtonClicked(button:)), for: .touchUpInside)
        
        self.titleButtonArray.append(button)
        self._headTabStackView?.addArrangedSubview(button)
        button.snp.makeConstraints { (make) in
            make.width.equalTo(rect.width + 20)
        }
        
        
        let view = childController.view
        self.pageViewArray.append(view!)
        self._mainPageStackView?.addArrangedSubview(view!)
        view!.snp.makeConstraints { (make) in
            make.width.equalTo(self.mainPageView().snp_width)
        }
    }
    
    
    //MARK: subView
    func headTabView() -> UIScrollView
    {
        if(self._headTabView == nil)
        {
            let scrollView = UIScrollView()
            let stackView = UIStackView.init()
            stackView.spacing = self.config.tabTitleSpace
            stackView.axis = .horizontal
            scrollView.addSubview(stackView)
            
            stackView.snp.makeConstraints({ (make) in
                make.height.equalToSuperview()
                make.edges.equalToSuperview()
            })
            
            self._headTabView = scrollView
            self._headTabStackView = stackView
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
            scrollView.bounces = false
            scrollView.backgroundColor = UIColor.clear
            scrollView.delegate = self
            
            let stackView = UIStackView.init()
            stackView.spacing = 0
            stackView.axis = .horizontal
            scrollView.addSubview(stackView)
            
            stackView.snp.makeConstraints({ (make) in
                make.height.equalToSuperview()
                make.edges.equalToSuperview()
            })
            
            self._mainPageView = scrollView
            self._mainPageStackView = stackView
        }
        return self._mainPageView!
    }
    
    
    
    @objc func onTitleButtonClicked(button:UIButton)
    {
        if(self.selectedIndex != button.tag)
        {
            self.selectedIndex = button.tag
            
            for button in self.titleButtonArray
            {
                button.isSelected = false
            }
            button.isSelected = true
            
            let contentSizeWidth = self.mainPageView().contentSize.width
            let num = self.childViewControllers.count
            let newContentOffsetX = (contentSizeWidth / CGFloat(num)) * CGFloat(self.selectedIndex)
            
            self.mainPageView().setContentOffset(CGPoint.init(x: newContentOffsetX,y: 0), animated: true)
            
            if self.delegate?.responds(to: #selector(self.delegate?.didSelectViewAtIndex(index:pageVC:))) ?? false
            {
                self.delegate?.didSelectViewAtIndex?(index: self.selectedIndex, pageVC: self)
            }
            
        }
    }
    
}




extension ZLPageTabViewController : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        ZLLog_Info(NSString.init(format: "%d %d", scrollView.contentOffset.x,scrollView.contentSize.width) as String)
        let contentOffsetX = scrollView.contentOffset.x
        let contentSizeWidth = scrollView.contentSize.width
        let num = self.childViewControllers.count
        
        if num > 0
        {
            let index = Int(contentOffsetX / (contentSizeWidth / CGFloat(num)))
            
            self.selectedIndex = index
            
            for button in self.titleButtonArray
            {
                if button.tag == self.selectedIndex
                {
                    button.isSelected = true
                }
                else
                {
                    button.isSelected = false
                }
            }
            
            
            if self.delegate?.responds(to: #selector(self.delegate?.didSelectViewAtIndex(index:pageVC:))) ?? false
            {
                self.delegate?.didSelectViewAtIndex?(index: index, pageVC: self)
            }
        }
        
        
    }

}
