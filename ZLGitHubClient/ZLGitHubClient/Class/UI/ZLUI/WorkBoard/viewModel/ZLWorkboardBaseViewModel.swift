//
//  ZLWorkboardBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLWorkboardBaseViewModel: ZLBaseViewModel {
    
    //
    weak var baseView : ZLWorkboardBaseView!
    
    // subViewModel
    var sectionArray :  [ZLWorkboardClassicType]?
    var cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]]?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let view = targetView as? ZLWorkboardBaseView else {
            return
        }
        baseView = view
        
        self.generateSubViewMode()
        self.baseView.resetData(sectionArray: self.sectionArray, cellDataDic: self.cellDataDic)
        
    }
    
    
    func generateSubViewMode(){
        let sectionArray : [ZLWorkboardClassicType] = [.work,.fixRepo]
        let cellDataArray1 = [ZLWorkboardTableViewCellData(type: .issues),
                              ZLWorkboardTableViewCellData(type: .pullRequest),
                              ZLWorkboardTableViewCellData(type: .orgs),
                              ZLWorkboardTableViewCellData(type: .repos),
                              ZLWorkboardTableViewCellData(type: .starRepos),
                              ZLWorkboardTableViewCellData(type: .events)]
        for cellData in cellDataArray1{
            self.addSubViewModel(cellData)
        }
        let cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellData]] = [.work:cellDataArray1,.fixRepo:[]]
        
        self.sectionArray = sectionArray
        self.cellDataDic = cellDataDic
    }
    

}
