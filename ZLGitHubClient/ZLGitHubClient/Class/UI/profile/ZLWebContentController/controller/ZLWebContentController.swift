//
//  ZLWebContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZMMVVM
import ZLUtilities
import ZLUIUtilities

@objcMembers class ZLWebContentController: ZMViewController {

    var requestURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zm_addSubViewModel(webContentViewModel)
        webContentView.zm_fillWithData(data: webContentViewModel)
    }
    
    override func setupUI() {
        super.setupUI()
        title = ZLLocalizedString(string: "Loading", comment: "加载中")
        contentView.addSubview(webContentView)
        webContentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        zmNavigationBar.addRightView(rightButton)
    }
    
    //MARK: Lazy View
    private lazy var webContentView: ZLWebContentView = {
        ZLWebContentView()
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 60, height: 60))
        let attributedTitle = ZLIconFont
            .More
            .rawValue
            .asMutableAttributedString()
            .font(UIFont.zlIconFont(withSize: 30))
            .foregroundColor(UIColor.label(withName: "ICON_Common"))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(onRightButtonClicked(button:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var webContentViewModel: ZLWebContentViewModel = {
        ZLWebContentViewModel(url: self.requestURL)
    }()

    
    @objc func onRightButtonClicked(button: UIButton) {
        guard let url = webContentView.currentURL ?? requestURL else {
            return
        }
   
        let activityVC = UIActivityViewController.init(activityItems: [url], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = button
        activityVC.excludedActivityTypes = [.message, .mail, .openInIBooks, .markupAsPDF]
        self.present(activityVC, animated: true, completion: nil)
    }
}
