//
//  ZLUserInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

protocol ZLUserInfoViewDelegateAndDataSource: NSObjectProtocol{
    
    var cellDatas: [[ZLGithubItemTableViewCellDataProtocol]] {get}
    
    func setCallBack(callback: @escaping () -> Void)
    
    func loadNewData()
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
    
    private func setupUI(){
        backgroundColor = .clear
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func fillWithData(delegateAndDataSource: ZLUserInfoViewDelegateAndDataSource){
        delegate = delegateAndDataSource
        delegate?.setCallBack { [weak self] in
            self?.reloadData()
        }
        reloadData()
    }
    
    private func reloadData(){
        self.tableView.mj_header?.endRefreshing()
        self.tableView.reloadData()
    }
    
    private func loadNewData() {
        self.delegate?.loadNewData()
    }
    
    //MARK: View
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ZLUserInfoHeaderCell.self, forCellReuseIdentifier: "ZLUserInfoHeaderCell")
        tableView.register(ZLCommonTableViewCell.self, forCellReuseIdentifier: "ZLCommonTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        tableView.mj_header = ZLRefresh.refreshHeader(refreshingBlock: { [weak self] in
            self?.loadNewData()
        })
        return tableView
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
        
        if let headerCell = cell as? ZLUserInfoHeaderCell,
            let headerCellData = cellData as? ZLUserInfoHeaderCellDataSourceAndDelegate {
            headerCell.fillWithData(viewModel: headerCellData)
            return headerCell
        }
        
        if let commonCell = cell as? ZLCommonTableViewCell,
           let commonCellData = cellData as? ZLCommonTableViewCellData {
            commonCell.fillWithData(viewData: commonCellData)
            return commonCell
        }
        
        return UITableViewCell()
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

