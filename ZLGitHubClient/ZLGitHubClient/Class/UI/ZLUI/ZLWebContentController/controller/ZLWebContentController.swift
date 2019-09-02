//
//  ZLWebContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLWebContentController: ZLBaseViewController {
    
    var requestURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ZLWebContentViewModel.init(viewController: self)
        
        guard let baseView = Bundle.main.loadNibNamed("ZLWebContentView", owner: self.viewModel, options: nil)?.first as? ZLWebContentView else
        {
            ZLLog_Warn("ZLWebContentView load failed,so return")
            return
        }
        
        baseView.frame = ZLScreenBounds
        self.view.addSubview(baseView)
        
        self.viewModel.bindModel(self.requestURL, andView: baseView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
