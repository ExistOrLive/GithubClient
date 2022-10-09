//
//  ZLAssistController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/1/20.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import CircleMenu
import SYDCentralPivot
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

enum ZLAssistButtonType {
    case home
    case search
    case setting
    case pasteboard
}

enum ZLAssistTableViewCellIndex {
    case search
    case clipBoard
    case userInterface
    case assistButon
    case circleMenu
}

class ZLAssistTableViewCell: UITableViewCell {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}

class ZLAssistController: ZLBaseViewController {

    // MARK: View
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = { () -> UIView in
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            view.backgroundColor = UIColor.clear

            let button = UIButton(type: .custom)
            button.setTitle(ZLIconFont.Close.rawValue, for: .normal)
            button.setTitleColor(UIColor(named: "ICON_Common"), for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 25)
            button.addTarget(self, action: #selector(onClose), for: .touchUpInside)

            view.addSubview(button)
            button.snp.makeConstraints { (make) in
                make.size.equalTo(CGSize(width: 40, height: 40))
                make.centerY.equalToSuperview()
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
            }

            return view

        }()
        return tableView
    }()

    private var searchBar: ZLBaseSearchBar?
    private var clipBoardButton: UIButton?
    private var userInterfaceSegmentedControl: UISegmentedControl?
    private var assistButton: UIButton?
    private var circleMenu: CircleMenu?

    // MARK: Data
    private var tableViewIndexs: [ZLAssistTableViewCellIndex] = []
    private var buttonTypes: [ZLAssistButtonType]?
    private var pasteURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setSearchBar()
        self.tableViewIndexs.append(.search)

        if let url = URL(string: UIPasteboard.general.string ?? ""),
           ZLUIRouter.isParsedGithubURL(url: url) {
                // 仅显示github.com的链接；链接必须包含loginName
                self.pasteURL = url
                self.setPasteURLButton()
                self.tableViewIndexs.append(.clipBoard)
        }

        if #available(iOS 13.0, *) {
            self.tableViewIndexs.append(.userInterface)
            self.setUpUserInterfaceSegmentControl()
        }

        self.setAssistButton()
        self.tableViewIndexs.append(.assistButon)

//        self.setCircleMenu()
//        self.tableViewIndexs.append(.circleMenu)

        self.setUpUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let window = self.view.window as? ZLFloatWindow {
            window.forceKey = true
            window.makeKey()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let window = self.view.window as? ZLFloatWindow {
            window.forceKey = false
            UIApplication.shared.delegate?.window??.makeKey()
        }
    }

    func setUpUI() {

        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func onClose() {
        ZLAssistButtonManager.shared.dismissAssistDetailView()
    }

    func setSearchBar() {
        searchBar = ZLBaseSearchBar()
        searchBar?.backgroundColor = UIColor.clear
        searchBar?.delegate = self
    }

    func setPasteURLButton() {

        let button = UIButton(type: .custom)
        button.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor(named: "ZLCellBack")

        let label = UILabel()
        label.font = .zlIconFont(withSize: 20)
        label.text = ZLIconFont.PasteBoard.rawValue
        label.textColor = UIColor(named: "ICON_Common")
        button.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(named: "ZLLinkLabelColor1")
        titleLabel.text = self.pasteURL?.absoluteString
        titleLabel.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
        titleLabel.numberOfLines = 2
        button.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(label.snp_right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        button.addTarget(self, action: #selector(ZLAssistController.onPasteURLButtonClicked), for: .touchUpInside)

        clipBoardButton = button
    }

    @objc func onPasteURLButtonClicked() {
        if let url = self.pasteURL {
            ZLAssistButtonManager.shared.dismissAssistDetailView()
            ZLUIRouter.openURL(url: url, animated: false)
        }
    }

    func setUpUserInterfaceSegmentControl() {
        userInterfaceSegmentedControl = UISegmentedControl(items: [ZLLocalizedString(string: "FollowSystemSetting", comment: ""), ZLLocalizedString(string: "Light Mode", comment: ""), ZLLocalizedString(string: "Dark Mode", comment: "")] )
        if #available(iOS 12.0, *) {
            userInterfaceSegmentedControl?.selectedSegmentIndex = ZLUISharedDataManager.currentUserInterfaceStyle.rawValue
        }
        userInterfaceSegmentedControl?.addTarget(self, action: #selector(onUserInterfaceStyleChange(segmentControl:)), for: .valueChanged)

    }

    @objc func onUserInterfaceStyleChange(segmentControl: UISegmentedControl) {

        if #available(iOS 13.0, *) {
            let interfaceStyle: UIUserInterfaceStyle  = UIUserInterfaceStyle.init(rawValue: segmentControl.selectedSegmentIndex) ?? UIUserInterfaceStyle.unspecified
            ZLUISharedDataManager.currentUserInterfaceStyle = interfaceStyle
            UIApplication.shared.delegate?.window??.overrideUserInterfaceStyle = interfaceStyle
            self.view.window?.overrideUserInterfaceStyle = interfaceStyle
            NotificationCenter.default.post(name: ZLUserInterfaceStyleChange_Notification, object: nil)
        }
    }

    func setCircleMenu() {

        let topVC = UIViewController.getTop()
        if topVC?.vcKey == ZLUIRouter.WorkboardViewController ||
            topVC?.vcKey == ZLUIRouter.NotificationViewController ||
            topVC?.vcKey == ZLUIRouter.ExploreViewController ||
            topVC?.vcKey == ZLUIRouter.ProfileViewController {
            self.buttonTypes = [.search, .setting]
        } else if topVC?.vcKey == ZLUIRouter.SettingController ||
                    topVC?.vcKey == ZLUIRouter.AppearanceController {
            self.buttonTypes = [.home, .search]
        } else if topVC?.vcKey == ZLUIRouter.SearchController {
            self.buttonTypes = [.home, .setting]
        } else {
            self.buttonTypes = [.home, .search, .setting]
        }

        let frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        let tmpcirclrMenu = CircleMenu(frame: frame, normalIcon: nil, selectedIcon: "assist-close", buttonsCount: self.buttonTypes?.count ?? 0, duration: 0.3, distance: 120)
        tmpcirclrMenu.backgroundColor = UIColor(named: "ZLBaseButtonBorderColor")
        tmpcirclrMenu.clipsToBounds = true
        tmpcirclrMenu.cornerRadius = 30
        tmpcirclrMenu.delegate = self

        circleMenu = tmpcirclrMenu
    }

    func setAssistButton() {
        let button = ZLBaseButton(type: .custom)
        button.setTitle(ZLLocalizedString(string: "Hide Assist Button", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(onAssitButtonClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
        assistButton = button
    }

    @objc func onAssitButtonClicked() {
        ZLAssistButtonManager.shared.dismissAssistDetailView()
        ZLAssistButtonManager.shared.setHidden(true)
        ZLUISharedDataManager.isAssistButtonHidden = true
        ZLToastView.showMessage(ZLLocalizedString(string: "ReShow Assist Button", comment: ""))
    }

}

extension ZLAssistController: ZLBaseSearchBarDelegate {

    func searchBarConfirmSearch(_ searchBar: ZLBaseSearchBar, withSearchKey searchKey: String) {
        if searchKey.count > 0 {
            ZLAssistButtonManager.shared.dismissAssistDetailView()
            ZLUIRouter.navigateVC(key: ZLUIRouter.SearchController, params: ["searchKey": searchKey], animated: false)
        }
    }
}

extension ZLAssistController: CircleMenuDelegate {

    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {

        button.tag = atIndex
        switch self.buttonTypes?[atIndex] {
        case .home:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x337DDB)
            button.setTitle(ZLIconFont.Home.rawValue, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 24)
        case .search:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x52A019)
            button.setTitle(ZLIconFont.Search.rawValue, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 24)
        case .pasteboard:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0xCE3B40)
            button.setTitle(ZLIconFont.PasteBoard.rawValue, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 24)
        case .setting:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x7445DA)
            button.setTitle(ZLIconFont.Setting.rawValue, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 24)
        case .none:
            button.backgroundColor = ZLRGBValue_H(colorValue: 0x337DDB)
            button.setTitle(ZLIconFont.Home.rawValue, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = .zlIconFont(withSize: 24)
        }
    }

    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {

    }

    /**
     Tells the delegate that the specified index is now selected.

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     - parameter button:     A selected circle menu button. Don't change button.tag
     - parameter atIndex:    Selected button index
     */
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {

        ZLAssistButtonManager.shared.dismissAssistDetailView()

        self.tmpfunc(index: atIndex)

    }

    func tmpfunc(index: Int) {

        let topVC = UIViewController.getTop()
        if topVC != nil  && topVC?.navigationController == nil {
            topVC?.dismiss(animated: true, completion: { [self] in
                self.tmpfunc(index: index)
            })
            return
        }

        switch self.buttonTypes?[index] {
        case .home:
            topVC?.navigationController?.popToRootViewController(animated: true)
            break
        case .search:
            if let searchVC = ZLUIRouter.getVC(key: ZLUIRouter.SearchController) {
                searchVC.hidesBottomBarWhenPushed = true
                topVC?.navigationController?.pushViewController(searchVC, animated: false)
            }
            break
        case .pasteboard:
            break
        case .setting:
            if let settingVC = ZLUIRouter.getVC(key: ZLUIRouter.SettingController) {
                settingVC.hidesBottomBarWhenPushed = true
                topVC?.navigationController?.pushViewController(settingVC, animated: false)
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
    func menuCollapsed(_ circleMenu: CircleMenu) {
        ZLAssistButtonManager.shared.dismissAssistDetailView()
    }

    /**
     Tells the delegate that the menu was opened. Fires immediately on button press

     - parameter circleMenu: A circle menu object informing the delegate about the new index selection.
     */
    func menuOpened(_ circleMenu: CircleMenu) {

    }

}

extension ZLAssistController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewIndexs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableViewIndexs[section] {
        case .search:do {
            return 40
        }
        case .clipBoard:do {
            return 40
        }
        case .userInterface:do {
            return 40
        }
        case .assistButon:do {
            return 40
        }
        case .circleMenu:do {
            return 10
        }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableViewIndexs[section] {
        case .search:do {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let label = UILabel()
            label.text = ZLLocalizedString(string: "Search", comment: "")
            label.textColor = UIColor(named: "ZLLabelColor1")
            label.textAlignment = .left
            label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
                make.centerY.equalToSuperview()
            }
            return view
        }
        case .clipBoard:do {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let label = UILabel()
            label.text = ZLLocalizedString(string: "ClipBoard", comment: "")
            label.textColor = UIColor(named: "ZLLabelColor1")
            label.textAlignment = .left
            label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
                make.centerY.equalToSuperview()
            }
            return view
        }
        case .userInterface:do {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let label = UILabel()
            label.text = ZLLocalizedString(string: "Appearance", comment: "")
            label.textColor = UIColor(named: "ZLLabelColor1")
            label.textAlignment = .left
            label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
                make.centerY.equalToSuperview()
            }
            return view
        }
        case .assistButon:do {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            let label = UILabel()
            label.text = ZLLocalizedString(string: "AssistButton", comment: "")
            label.textColor = UIColor(named: "ZLLabelColor1")
            label.textAlignment = .left
            label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 20)
            view.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.left.equalTo(view.safeAreaLayoutGuide.snp.left).offset(20)
                make.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-20)
                make.centerY.equalToSuperview()
            }
            return view
        }
        case .circleMenu:do {
            return nil
        }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableViewIndexs[indexPath.section] {
        case .search:do {
            return 70
        }
        case .clipBoard:do {
            return 110
        }
        case .userInterface:do {
            return 70
        }
        case .assistButon:do {
            return 70
        }
        case .circleMenu:do {
            return 360
        }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewIndexs[indexPath.section] {
        case .search:do {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "search") {
                return tableViewCell
            } else {
                let tableViewCell = ZLAssistTableViewCell(style: .default, reuseIdentifier: "search")
                tableViewCell.backgroundColor = UIColor.clear
                tableViewCell.selectionStyle = .none
                tableViewCell.contentView.backgroundColor = UIColor.clear
                if let searchBar = self.searchBar {
                    tableViewCell.contentView.addSubview(searchBar)
                    searchBar.snp.makeConstraints({ (make) in
                        make.right.left.equalToSuperview()
                        make.center.equalToSuperview()
                        make.height.equalTo(40)
                    })
                }
                return tableViewCell
            }
        }
        case .clipBoard:do {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "clipBoard") {
                return tableViewCell
            } else {
                let tableViewCell = ZLAssistTableViewCell(style: .default, reuseIdentifier: "clipBoard")
                tableViewCell.backgroundColor = UIColor.clear
                tableViewCell.contentView.backgroundColor = UIColor.clear
                tableViewCell.selectionStyle = .none
                if let clipBoardButton = self.clipBoardButton {
                    tableViewCell.contentView.addSubview(clipBoardButton)
                    clipBoardButton.snp.makeConstraints({ (make) in
                        make.left.equalToSuperview().offset(20)
                        make.right.equalToSuperview().offset(-20)
                        make.center.equalToSuperview()
                        make.height.equalTo(80)
                    })
                }

                return tableViewCell
            }
        }
        case .userInterface:do {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "userInterface") {
                return tableViewCell
            } else {
                let tableViewCell = ZLAssistTableViewCell(style: .default, reuseIdentifier: "userInterface")
                tableViewCell.backgroundColor = UIColor.clear
                tableViewCell.selectionStyle = .none
                tableViewCell.contentView.backgroundColor = UIColor.clear
                if let userInterfaceSegmentedControl = self.userInterfaceSegmentedControl {
                    tableViewCell.contentView.addSubview(userInterfaceSegmentedControl)
                    userInterfaceSegmentedControl.snp.makeConstraints({ (make) in
                        make.left.equalToSuperview().offset(20)
                        make.right.equalToSuperview().offset(-20)
                        make.center.equalToSuperview()
                        make.height.equalTo(40)
                    })
                }
                return tableViewCell
            }
        }
        case .assistButon:do {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "assistButon") {
                return tableViewCell
            } else {
                let tableViewCell = ZLAssistTableViewCell(style: .default, reuseIdentifier: "assistButon")
                tableViewCell.backgroundColor = UIColor.clear
                tableViewCell.selectionStyle = .none
                tableViewCell.contentView.backgroundColor = UIColor.clear
                if let assistButton = self.assistButton {
                    tableViewCell.contentView.addSubview(assistButton)
                    assistButton.snp.makeConstraints({ (make) in
                        make.left.greaterThanOrEqualToSuperview().offset(20)
                        make.right.lessThanOrEqualToSuperview().offset(-20)
                        make.width.equalTo(250).priority(.high)
                        make.center.equalToSuperview()
                        make.height.equalTo(40)
                    })
                }
                return tableViewCell
            }
        }
        case .circleMenu:do {
            if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "circleMenu") {
                return tableViewCell
            } else {
                let tableViewCell = ZLAssistTableViewCell(style: .default, reuseIdentifier: "circleMenu")
                tableViewCell.backgroundColor = UIColor.clear
                tableViewCell.contentView.backgroundColor = UIColor.clear
                tableViewCell.selectionStyle = .none
                if let circleMenu = self.circleMenu {
                    tableViewCell.contentView.addSubview(circleMenu)
                    circleMenu.snp.makeConstraints { (make) in
                        make.size.equalTo(CGSize(width: 60, height: 60))
                        make.center.equalToSuperview()
                    }
                    circleMenu.sendActions(for: .touchUpInside)
                }

                return tableViewCell
            }
        }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.isSelected = false
        }
    }

}
