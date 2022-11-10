//
//  ZLSearchFilterViewManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/1.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

class ZLSearchFilterViewManager {
    
    // MARK: ViewData
    lazy var userDatas: [ZMInputCollectionSectionData] = {
        return generateUserDatas()
    }()
    
    
    // MARK: Lazy View
    lazy var searchFilterViewForUser: ZMInputConfirmPopView = {
        let view = ZMInputConfirmPopView()
        view.contentWidth = 300
        view.contentHeight = ZLSCreenHeight
        view.collectionView.register(sectionHeaderType: ZMInputCollectionViewSectionTitleHeader.self, withReuseIdentifier: "ZMInputCollectionViewSectionTitleHeader")
        view.collectionView.register(cellType: ZLSearchFilterButtonCell.self, forCellWithReuseIdentifier: "ZLSearchFilterButtonCell")
        view.collectionView.register(cellType: ZLSearchFilterTextFieldCell.self, forCellWithReuseIdentifier: "ZLSearchFilterTextFieldCell")
        view.collectionView.register(cellType: ZLSearchFilterSingleLineCell.self, forCellWithReuseIdentifier: "ZLSearchFilterSingleLineCell")
        view.collectionView.policy = self
        view.collectionView.delegate = self
        view.collectionView.uiDelegate = self
        view.collectionView.headerReferenceSize = CGSize(width: ZLScreenWidth, height: 35)
        view.contentInset = UIEdgeInsets(top: ZLSafeAreaTopHeight, left: 0, bottom: ZLSafeAreaBottomHeight, right: 0)
        return view
    }()
}

extension ZLSearchFilterViewManager {
    
    func showSearchFilterViewForUser() {
        guard let view = ZLMainWindow else { return }
        searchFilterViewForUser.frame = UIScreen.main.bounds
        searchFilterViewForUser.collectionView.setSectionDatas(sectionDatas: userDatas)
        searchFilterViewForUser.show(view,
                                     contentPoition: .right,
                                     animationDuration: 0.25)
    }
}



extension ZLSearchFilterViewManager {
    func generateUserDatas() -> [ZMInputCollectionSectionData] {
      
        // order
        let orderSectionViewData = ZMInputCollectionViewSectionTitleHeaderData(
            title: ZLLocalizedString(string: "Order", comment: "排序"),
            titleColor: UIColor.label(withName: "ZLLabelColor1"),
            titleLeftPadding: 20)
        let orderCellData = ZLSearchFilterButtonCellData(buttonValue: nil,
                                                         buttonTitle: nil,
                                                         defaultButtonTitle: "Best Match",
                                                         id: "order")

        let orderSectionData = ZMInputCollectionSectionData(cellDatas: [orderCellData],
                                                            sectionHeaderData: orderSectionViewData)
        
        // Language
        let lanSectionViewData = ZMInputCollectionViewSectionTitleHeaderData(
            title: ZLLocalizedString(string: "Language", comment: "语言"),
            titleColor: UIColor.label(withName: "ZLLabelColor1"),
            titleLeftPadding: 20)
        let lanCellData = ZLSearchFilterButtonCellData(buttonValue: nil,
                                                       buttonTitle: nil,
                                                       defaultButtonTitle: "Any",
                                                       id: "language")
        
        let lanSectionData = ZMInputCollectionSectionData(cellDatas: [lanCellData],
                                                          sectionHeaderData: lanSectionViewData)
        
        // 创建时间
        let createSectionViewData = ZMInputCollectionViewSectionTitleHeaderData(
            title: ZLLocalizedString(string: "CreateTime", comment: "创建于"),
            titleColor: UIColor.label(withName: "ZLLabelColor1"),
            titleLeftPadding: 20)
        let createTimeCellData1 = ZLSearchFilterButtonCellData(buttonValue: nil,
                                                               buttonTitle: nil,
                                                               id: "firstCreatedTimeStr")
        
        let createTimeSingleLineCellDatas = ZLSearchFilterSingleLineCellData(id:"singline")
        
        let createTimeCellData2 = ZLSearchFilterButtonCellData(buttonValue: nil,
                                                               buttonTitle: nil,
                                                               id: "secondCreatedTimeStr")
        
        let createTimeSectionData = ZMInputCollectionSectionData(cellDatas: [createTimeCellData1,createTimeSingleLineCellDatas,createTimeCellData2],
                                                          sectionHeaderData: createSectionViewData)
        
        
        // 粉丝
        
        let followerSectionViewData = ZMInputCollectionViewSectionTitleHeaderData(
            title: ZLLocalizedString(string: "FollowersNum", comment: "粉丝"),
            titleColor: UIColor.label(withName: "ZLLabelColor1"),
            titleLeftPadding: 20)
        let followerCellData1 = ZLSearchFilterTextFieldCellData(textValue: nil,
                                                                placeHolder: "",
                                                                id: "firstFollowersNum")
        
        let followerSingleLineCellDatas = ZLSearchFilterSingleLineCellData(id:"singline")
        
        let followerCellData2 = ZLSearchFilterTextFieldCellData(textValue: nil,
                                                                placeHolder: nil,
                                                                id: "secondFollowersNum")
        
        let followerSectionData = ZMInputCollectionSectionData(cellDatas: [followerCellData1,followerSingleLineCellDatas,followerCellData2],
                                                          sectionHeaderData: followerSectionViewData)
        
        // 公共仓库
        
        let pubRepoSectionViewData = ZMInputCollectionViewSectionTitleHeaderData(
            title: ZLLocalizedString(string: "PubReposNum", comment: "公共仓库"),
            titleColor: UIColor.label(withName: "ZLLabelColor1"),
            titleLeftPadding: 20)
        let pubRepoCellData1 = ZLSearchFilterTextFieldCellData(textValue: nil,
                                                               placeHolder: nil,
                                                               id: "firstPubReposNum")
        
        let pubRepoSingleLineCellDatas = ZLSearchFilterSingleLineCellData(id:"singline")
        
        let pubRepoCellData2 = ZLSearchFilterTextFieldCellData(textValue: nil,
                                                               placeHolder: nil,
                                                               id: "secondPubReposNum")
        
        let pubRepoSectionData = ZMInputCollectionSectionData(cellDatas: [pubRepoCellData1,pubRepoSingleLineCellDatas,pubRepoCellData2],
                                                          sectionHeaderData: pubRepoSectionViewData)
        
        return [orderSectionData,
                lanSectionData,
                createTimeSectionData,
                followerSectionData,
                pubRepoSectionData]
    }
}


// MARK: -  ZMInputCollectionViewPolicyProtocol
extension ZLSearchFilterViewManager: ZMInputCollectionViewPolicyProtocol {
 
    /// 按钮策略
    ///  - Parameters:
    ///    - collectionView: ZMInputCollectionView
    ///    - didClickIndexPath: 点击的cell的indexPath
    ///    - cellDataForClickedCell: 点击的cell的cellData
    ///    - sectionCellDatas: 点击的cell的section的celldata数组
    ///    - sectionDatas: 所有的sectionData
    ///    - completionHandler: 处理回调 changes:  数据是否修改  needFlush 是否需要flush cellData的缓存数据
    ///    请在主线程回调 completionHandler
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didClickIndexPath indexPath: IndexPath,
                             cellDataForClickedCell cellData: ZMInputCollectionViewButtonCellDataType,
                             sectionCellDatas: [ZMInputCollectionViewBaseCellDataType],
                             sectionDatas: [ZMInputCollectionViewSectionDataType],
                             completionHandler: @escaping (_ changed:Bool, _ needFlush:Bool) -> Void) {
        if cellData.id == "order" {
            
            ZLSearchFilterPickerView.showUserOrderPickerView(initTitle: cellData.buttonValue as? String, resultBlock: {[weak cellData](result: String) in
                cellData?.buttonValue = result
            })
        } else if cellData.id == "language" {
            
        } else if cellData.id == "firstCreatedTimeStr" {
            
        } else if cellData.id == "secondCreatedTimeStr" {
            
        }
    }
}


// MARK: -  ZMInputCollectionDelegate
extension ZLSearchFilterViewManager: ZMInputCollectionDelegate {
    /// 当缓存中的数据修改时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             allSectionDatasDidChanged sectionDatas: [ZMInputCollectionViewSectionDataType]) {
        
    }
    
    /// 当缓存的数据flush时，回调
    func inputCollectionView(_ collectionView: ZMInputCollectionView,
                             didFlushData cellDatas: [[ZMInputCollectionViewBaseCellDataType]]) {
        
    }
}

// MARK: - ZMInputCollectionViewUIDelegate
extension ZLSearchFilterViewManager: ZMInputCollectionViewUIDelegate {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionData = collectionView.sectionDatas[indexPath.section]
        let cellData = sectionData.cellDatas[indexPath.row]
        
        switch cellData.id {
        case "order", "language":
            return CGSize(width: 260, height: 35)
        case "firstCreatedTimeStr",
             "secondCreatedTimeStr",
             "firstFollowersNum",
             "secondFollowersNum",
             "firstPubReposNum",
             "secondPubReposNum":
            return CGSize(width: 100, height: 35)
        case "singline":
            return CGSize(width: 40, height: 35)
        default:
            return .zero
        }
    }
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20 )
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 300, height: 50)
    }
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, lineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.lineSpacing
    }

    func inputCollectionView(_ collectionView: ZMInputCollectionView, interitemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
