//
//  ZLUserInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUIUtilities
import ZLBaseExtension

protocol ZLUserInfoViewDelegateAndDataSource: NSObjectProtocol {

    // datasource
    var userOrOrgLoginName: String {get}

    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {get}

    // delegate
    func loadNewData()

    func onLinkClicked(url: URL?)

    func setCallBack(callback: @escaping () -> Void)
    func setReadMeCallBack(callback: @escaping () -> Void)

}

class ZLUserInfoView: ZLBaseView {

    private weak var delegate: ZLUserInfoViewDelegateAndDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func fillWithData(delegateAndDataSource: ZLUserInfoViewDelegateAndDataSource) {
        delegate = delegateAndDataSource
        delegate?.setCallBack { [weak self] in
            self?.reloadData()
        }
        delegate?.setReadMeCallBack { [weak self] in
            self?.reloadReadMe()
        }
        reloadData()
    }

    private func reloadData() {
        self.tableView.mj_header?.endRefreshing()
        self.tableView.reloadData()
    }

    private func loadNewData() {
        self.delegate?.loadNewData()
    }

    private func reloadReadMe() {
        if let loginName = delegate?.userOrOrgLoginName,
           !loginName.isEmpty {
            readMeView?.startLoad(fullName: "\(loginName)/\(loginName)", branch: nil)
        } else {
            tableView.tableFooterView = nil
        }
    }

    // MARK: View

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.register(ZLUserContributionsCell.self, forCellReuseIdentifier: "ZLUserContributionsCell")
        tableView.register(ZLPinnedRepositoriesTableViewCell.self, forCellReuseIdentifier: "ZLPinnedRepositoriesTableViewCell")
        tableView.register(ZLOrgInfoHeaderCell.self, forCellReuseIdentifier: "ZLOrgInfoHeaderCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: ZLSafeAreaBottomHeight, right: 0)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.mj_header = ZLRefresh.refreshHeader(refreshingBlock: { [weak self] in
            self?.loadNewData()
        })
        return tableView
    }()

    private lazy var readMeView: ZLReadMeView? = {
        guard let readMeView: ZLReadMeView = Bundle.main.loadNibNamed("ZLReadMeView", owner: nil, options: nil)?.first as? ZLReadMeView else {
            return nil
        }
        readMeView.delegate = self
        return readMeView
    }()

}

extension ZLUserInfoView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = self.delegate?.cellDatas[indexPath.section][indexPath.row] else {
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellData.getCellReuseIdentifier()) else {
            return UITableViewCell()
        }
        
        if let viewUpdatable = cell as? ZLViewUpdatable {
            viewUpdatable.fillWithData(data: cellData)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate?.cellDatas[section].count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.delegate?.cellDatas.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellData = self.delegate?.cellDatas[indexPath.section][indexPath.row] else {
            return
        }
        cellData.onCellSingleTap()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellData = self.delegate?.cellDatas[indexPath.section][indexPath.row] else {
            return 0
        }
        return cellData.getCellHeight()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

}

extension ZLUserInfoView: ZLReadMeViewDelegate {

    @objc func onLinkClicked(url: URL?) {
        self.delegate?.onLinkClicked(url: url)
    }

    @objc func getReadMeContent(result: Bool) {
        tableView.tableFooterView = result ?  readMeView : nil
    }

    @objc func notifyNewHeight(height: CGFloat) {
        if tableView.tableFooterView != nil {
            readMeView?.frame = CGRect(x: 0, y: 0, width: 0, height: height)
            tableView.tableFooterView = readMeView
        }
    }
}
