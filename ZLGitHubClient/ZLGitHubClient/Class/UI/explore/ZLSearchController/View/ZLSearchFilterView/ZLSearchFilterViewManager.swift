//
//  ZLSearchFilterViewManager.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/11/1.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit
import ZLGitRemoteService

class ZLSearchFilterViewManager {
    
    init(viewModel: ZLSearchItemsViewModel) {
        self.viewModel = viewModel
    }
    
    weak var viewModel: ZLSearchItemsViewModel?

    var filterBlock: ((ZLSearchFilterInfoModel) -> Void)?
    
    // MARK: ViewData
    lazy var repoDatas: [ZMInputCollectionSectionData] = {
        return generateFilterSectionDatas(searchType: .repositories)
    }()

    lazy var userDatas: [ZMInputCollectionSectionData] = {
        return generateFilterSectionDatas(searchType: .users)
    }()
    
    lazy var orgDatas: [ZMInputCollectionSectionData] = {
        return generateFilterSectionDatas(searchType: .organizations)
    }()
    
    lazy var prDatas: [ZMInputCollectionSectionData] = {
        return generateFilterSectionDatas(searchType: .pullRequests)
    }()
    
    lazy var issueDatas: [ZMInputCollectionSectionData] = {
        return generateFilterSectionDatas(searchType: .issues)
    }()

    
    // MARK: Lazy View
    var searchFilterView: ZMInputConfirmPopView {
        let view = ZMInputConfirmPopView()
        view.contentWidth = 300
        view.contentHeight = ZLSCreenHeight
        view.collectionView.register(sectionHeaderType: ZMInputCollectionViewSectionTitleHeader.self,
                                     withReuseIdentifier: "ZMInputCollectionViewSectionTitleHeader")
        view.collectionView.register(cellType: ZLSearchFilterButtonCell.self,
                                     forCellWithReuseIdentifier: "ZLSearchFilterButtonCell")
        view.collectionView.register(cellType: ZLSearchFilterNumberFieldCell.self,
                                     forCellWithReuseIdentifier: "ZLSearchFilterNumberFieldCell")
        view.collectionView.register(cellType: ZLSearchFilterSingleLineCell.self,
                                     forCellWithReuseIdentifier: "ZLSearchFilterSingleLineCell")
        view.collectionView.policy = self
        view.collectionView.delegate = self
        view.collectionView.uiDelegate = self
        view.popDelegate = self
        view.collectionView.headerReferenceSize = CGSize(width: ZLScreenWidth, height: 35)
        view.contentInset = UIEdgeInsets(top: ZLSafeAreaTopHeight, left: 0, bottom: ZLSafeAreaBottomHeight, right: 0)
        view.frame = UIScreen.main.bounds
        return view
    }
}

extension ZLSearchFilterViewManager {
    
    func showSearchFilterViewFor(searchType: ZLSearchType,
                                 filterBlock: @escaping (ZLSearchFilterInfoModel) -> Void) {
        guard let view = viewModel?.viewController?.view else { return }
        self.filterBlock = filterBlock
        let searchFilterView = self.searchFilterView
        searchFilterView
            .collectionView
            .setSectionDatas(sectionDatas: getFilterSectionDatas(searchType: searchType))
        searchFilterView.show(view,
                              contentPoition: .right,
                              animationDuration: 0.25)
    }
}

extension ZLSearchFilterViewManager {
    
    func getFilterSectionDatas(searchType: ZLSearchType) -> [ZMInputCollectionSectionData] {
        switch searchType {
        case .repositories:
            return repoDatas
        case .users:
            return userDatas
        case .issues:
            return issueDatas
        case .pullRequests:
            return prDatas
        case .organizations:
            return orgDatas
        @unknown default:
            return repoDatas
        }
    }
    
    /// 生成不同搜索类型的过滤选项SectionData
    func generateFilterSectionDatas(searchType: ZLSearchType) -> [ZMInputCollectionSectionData] {
    
        searchType.filterSections.map { section -> ZMInputCollectionSectionData in
            let sectionHeaderData = ZMInputCollectionViewSectionTitleHeaderData(
                title: ZLLocalizedString(string: section.titleKey, comment: ""),
                titleColor: UIColor.label(withName: "ZLLabelColor1"),
                titleLeftPadding: 20)
            
            let cellDatas =  section.cellTypes.map { cellType -> ZMInputCollectionViewBaseCellDataType in
                switch cellType {
                case .repoOrder,.userOrder,.orgOrder,.prOrder,.issueOrder:
                    return ZLSearchFilterButtonCellData(buttonValue: nil,
                                                        buttonTitle: "Best Match",
                                                        defaultButtonTitle: "Best Match",
                                                        id: cellType.id)
                case .language:
                    return ZLSearchFilterButtonCellData(buttonValue: nil,
                                                        buttonTitle: "Any",
                                                        defaultButtonTitle: "Any",
                                                        id: cellType.id)
                case .firstCreatedTime,.secondCreatedTime:
                    return ZLSearchFilterButtonCellData(buttonValue: nil,
                                                        buttonTitle: nil,
                                                        id: cellType.id)
                case .firstFork,
                        .firstStar,
                        .secondFork,
                        .secondStar,
                        .firstRepo,
                        .secondRepo,
                        .firstFollower,
                        .secondFollower:
                    return ZLSearchFilterNumberFieldCellData(textValue: nil,
                                                           placeHolder: ZLLocalizedString(string: "input number",
                                                                                          comment: "输入数字"),
                                                           id: cellType.id)
                case .openStatus:
                    return ZLSearchFilterButtonCellData(buttonValue: true,
                                                        buttonTitle: "Open",
                                                        defaultButtonTitle: "Open",
                                                        id: cellType.id)
                case .singline:
                    return ZLSearchFilterSingleLineCellData(id:cellType.id)
                }
            }
            
            return ZMInputCollectionSectionData(cellDatas: cellDatas,
                                                sectionHeaderData: sectionHeaderData)
        }
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
        guard let cellType = ZLSearchFilterCellType(rawValue: cellData.id) else {
            completionHandler(false,false)
            return
        }
        
        switch cellType {
        case .repoOrder:
            guard let window = ZLMainWindow else { return }
            let selectedOrder = cellData.buttonValue as? String
            ZMSingleSelectTitlePopView
                .showCenterSingleSelectTickBox(to: window,
                                               title: ZLLocalizedString(string: "OrderSelect",
                                                                        comment: ""),
                                               selectableTitles: ZLSearchRepoOrderItem.allCases.map({$0.rawValue}),
                                               selectedTitle: selectedOrder ?? "")
            {[weak cellData] (index: Int,result: String) in
                cellData?.buttonValue = result
                cellData?.buttonTitle = result
                completionHandler(true,false)
            }
        case .userOrder:
            guard let window = ZLMainWindow else { return }
            let selectedOrder = cellData.buttonValue as? String
            ZMSingleSelectTitlePopView
                .showCenterSingleSelectTickBox(to: window,
                                               title: ZLLocalizedString(string: "OrderSelect",
                                                                        comment: ""),
                                               selectableTitles: ZLSearchUserOrderItem.allCases.map({$0.rawValue}),
                                               selectedTitle: selectedOrder ?? "")
            {[weak cellData] (index: Int,result: String) in
                cellData?.buttonValue = result
                cellData?.buttonTitle = result
                completionHandler(true,false)
            }
        case .orgOrder:
            guard let window = ZLMainWindow else { return }
            let selectedOrder = cellData.buttonValue as? String
            ZMSingleSelectTitlePopView
                .showCenterSingleSelectTickBox(to: window,
                                               title: ZLLocalizedString(string: "OrderSelect",
                                                                        comment: ""),
                                               selectableTitles: ZLSearchOrgOrderItem.allCases.map({$0.rawValue}),
                                               selectedTitle: selectedOrder ?? "")
            {[weak cellData] (index: Int,result: String) in
                cellData?.buttonValue = result
                cellData?.buttonTitle = result
                completionHandler(true,false)
            }
        case .issueOrder:
            guard let window = ZLMainWindow else { return }
            let selectedOrder = cellData.buttonValue as? String
            ZMSingleSelectTitlePopView
                .showCenterSingleSelectTickBox(to: window,
                                               title: ZLLocalizedString(string: "OrderSelect",
                                                                        comment: ""),
                                               selectableTitles: ZLSearchIssueOrPROrderItem.allCases.map({$0.rawValue}),
                                               selectedTitle: selectedOrder ?? "")
            {[weak cellData] (index: Int,result: String) in
                cellData?.buttonValue = result
                cellData?.buttonTitle = result
                completionHandler(true,false)
            }
        case .prOrder:
            guard let window = ZLMainWindow else { return }
            let selectedOrder = cellData.buttonValue as? String
            ZMSingleSelectTitlePopView
                .showCenterSingleSelectTickBox(to: window,
                                               title: ZLLocalizedString(string: "OrderSelect",
                                                                        comment: ""),
                                               selectableTitles: ZLSearchIssueOrPROrderItem.allCases.map({$0.rawValue}),
                                               selectedTitle: selectedOrder ?? "")
            {[weak cellData] (index: Int,result: String) in
                cellData?.buttonValue = result
                cellData?.buttonTitle = result
                completionHandler(true,false)
            }
        case .language:
            guard let window = ZLMainWindow else { return }
            let language = cellData.buttonValue as? String
            ZMLanguageSelectView.showDevelopLanguageSelectView(to: window,
                                                                  developeLanguage: language) { [weak cellData] language in
                cellData?.buttonTitle = language ?? "Any"
                cellData?.buttonValue = language
                completionHandler(true,false)
            }
        case .openStatus:
            let openStatus = cellData.buttonValue as? Bool ?? true
            cellData.buttonValue = !openStatus
            cellData.buttonTitle = !openStatus ? "Open" : "Close"
            completionHandler(true,false)
        case .firstCreatedTime, .secondCreatedTime:
            guard let window = ZLMainWindow else { return }
            let currentDate = (cellData.buttonValue as? String)?.toDate()
            ZMDatePickerPopView.showDatePickerPopView(to: window,
                                                      title: ZLLocalizedString(string: "DateRange", comment: ""),
                                                      startDate: Date(year: 2008, month: 1, day: 1),
                                                      endDate: Date(),
                                                      currentDate: currentDate) { [weak cellData] date in
                
                cellData?.buttonValue = date.toString()
                cellData?.buttonTitle = date.toString()
                completionHandler(true,false)
            }
        default:
            break
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
        
        let model: ZLSearchFilterInfoModel = ZLSearchFilterInfoModel()
        for sectionCellDatas in cellDatas {
            for cellData in sectionCellDatas {
                guard let cellType = ZLSearchFilterCellType(rawValue: cellData.id) else {
                    continue
                }
                
                switch cellType {
                case .repoOrder:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String,
                       let orderType = ZLSearchRepoOrderItem(rawValue: value){
                        model.isAsc = orderType.isAsc
                        model.order = orderType.order
                    }
                case .userOrder:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String,
                       let orderType = ZLSearchUserOrderItem(rawValue: value){
                        model.isAsc = orderType.isAsc
                        model.order = orderType.order
                    }
                case .orgOrder:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String,
                       let orderType = ZLSearchOrgOrderItem(rawValue: value){
                        model.isAsc = orderType.isAsc
                        model.order = orderType.order
                    }
                case .issueOrder,.prOrder:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String,
                       let orderType = ZLSearchIssueOrPROrderItem(rawValue: value){
                        model.isAsc = orderType.isAsc
                        model.order = orderType.order
                    }
                case .language:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String {
                        model.language = value
                    }
                case .openStatus:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType {
                        model.issueOrPRClosed = !(buttonCellData.buttonValue as? Bool ?? true)
                    }
                case .firstCreatedTime:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String {
                        model.firstCreatedTimeStr = value
                    }
                case .secondCreatedTime:
                    if let buttonCellData = cellData as? ZMInputCollectionViewButtonCellDataType,
                       let value = buttonCellData.buttonValue as? String {
                        model.secondCreatedTimeStr = value
                    }
                case .firstStar:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.firstStarNum = UInt(value) ?? 0
                    }
                case .secondStar:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.secondStarNum = UInt(value) ?? 0
                    }
                case .firstFork:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.firstForkNum = UInt(value) ?? 0
                    }
                case .secondFork:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.secondForkNum = UInt(value) ?? 0
                    }
                case .firstFollower:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.firstFollowersNum = UInt(value) ?? 0
                    }
                case .secondFollower:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.secondFollowersNum = UInt(value) ?? 0
                    }
                case .firstRepo:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.firstPubReposNum = UInt(value) ?? 0
                    }
                case .secondRepo:
                    if let textCellData = cellData as? ZMInputCollectionViewTextFieldCellDataType,
                       let value = textCellData.textValue {
                        model.secondPubReposNum = UInt(value) ?? 0
                    }
                default:
                    break
                }
            }
        }
        filterBlock?(model)
    }
}

// MARK: - ZMInputCollectionViewUIDelegate
extension ZLSearchFilterViewManager: ZMInputCollectionViewUIDelegate {
    
    func inputCollectionView(_ collectionView: ZMInputCollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionData = collectionView.sectionDatas[indexPath.section]
        let cellData = sectionData.cellDatas[indexPath.row]
        guard let cellType = ZLSearchFilterCellType(rawValue: cellData.id ) else {
            return .zero
        }
        switch cellType {
        case .repoOrder,.userOrder,.orgOrder,.issueOrder,.prOrder,.language,.openStatus:
            return CGSize(width: 260, height: 35)
        case .firstFork,.firstRepo,.firstFollower,.firstStar,.firstCreatedTime,
                .secondFork,.secondRepo,.secondFollower,.secondStar,.secondCreatedTime:
            return CGSize(width: 100, height: 35)
        case .singline:
            return CGSize(width: 40, height: 35)
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

// MARK: - ZMPopContainerViewDelegate
extension ZLSearchFilterViewManager: ZMPopContainerViewDelegate {
    
    func popContainerViewShouldChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }

    func popContainerViewShouldChangeContentViewFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> Bool {
        ZLDeviceInfo.isIpad()
    }

    func popContainerViewChangeFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        if let view = view as? ZMInputConfirmPopView {
            view.contentInset = UIEdgeInsets(top: ZLSafeAreaTopHeight, left: 0, bottom: ZLSafeAreaBottomHeight, right: 0)
        }
        return ZLScreenBoundsAdjustWithScreenOrientation
    }

    func popContainerViewChangeContentViewTargetFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        let size = CGSize(width: 300, height: view.frame.height)
        let origin = CGPoint(x: view.frame.width - 300,
                             y: 0)
        return CGRect(origin: origin, size: size)
    }

    func popContainerViewChangeContentViewInitFrameWhenDeviceOrientationDidChange(_ view:ZMPopContainerView) -> CGRect {
        let size = CGSize(width: 300, height: view.frame.height)
        let origin = CGPoint(x: view.frame.width,
                             y: 0)
        return CGRect(origin: origin, size: size)
    }

}
