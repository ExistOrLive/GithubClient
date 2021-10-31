//
//  ZLWorkboardBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

enum ZLWorkboardClassicType{
    case work
    case fixRepo
}

protocol ZLWorkboardBaseViewDelegate : NSObjectProtocol  {
    func onEditFixedRepoButtonClicked() -> Void
}


class ZLWorkboardBaseView: ZLBaseView, UITableViewDelegate, UITableViewDataSource{
   
    weak var delegate : ZLWorkboardBaseViewDelegate?
    
    private var tableView : UITableView!
    
    private var sectionArray : [ZLWorkboardClassicType] = []
    private var cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellDelegate]] = [:]
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        self.tableView = UITableView.init(frame: CGRect(), style: .grouped)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.tableView.showsVerticalScrollIndicator = false
        
        self.tableView.register(UINib.init(nibName: "ZLWorkboardTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ZLWorkboardTableViewCell")
        self.tableView.register(ZLWorkboardTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "ZLWorkboardTableViewSectionHeader")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(ZLWorkboardBaseView.onNotificationArrived(notification:)) , name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetData(sectionArray: [ZLWorkboardClassicType] , cellDataDic : [ZLWorkboardClassicType:[ZLWorkboardTableViewCellDelegate]]){
        self.sectionArray = sectionArray
        self.cellDataDic = cellDataDic
        self.tableView.reloadData()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataDic[sectionArray[section]]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if sectionArray[section] == .fixRepo &&
            cellDataDic[.fixRepo]?.count ?? 0 == 0{
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ZLWorkboardTableViewSectionHeader") as? ZLWorkboardTableViewSectionHeader{
            view.titleLabel.text = self.getSectionTitle(type: sectionArray[section])
            view.button.isHidden = (sectionArray[section] != .fixRepo)
            view.button.setTitle(ZLLocalizedString(string: "Edit", comment: ""), for: .normal)
            if !view.button.allTargets.contains(self) {
                view.button.addTarget(self, action: #selector(ZLWorkboardBaseView.onEditButtonClicked), for: .touchUpInside)
            }
            return view
        }
        return UIView.init()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if sectionArray[section] == .fixRepo &&
            cellDataDic[.fixRepo]?.count ?? 0 == 0{
            let label = UILabel.init()
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.init(named: "ZLLabelColor2")
            label.font = UIFont.init(name: Font_PingFangSCRegular, size: 13)
            label.text = ZLLocalizedString(string: "Add Fixed Repo", comment: "")
            label.textAlignment = .center
            return label
        }
        return nil
    }
    
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cellDatas = cellDataDic[sectionArray[indexPath.section]],
           let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLWorkboardTableViewCell") as? ZLWorkboardTableViewCell{
            
            let cellData = cellDatas[indexPath.row]
            tableViewCell.fillWithData(cellData: cellData)
            tableViewCell.backView.cornerRadius = 0
            tableViewCell.singleLineView.isHidden = false
            if cellDataDic[sectionArray[indexPath.section]]?.count == 1 {
                tableViewCell.backView.cornerDirection = CornerDirection(rawValue: 15)
                tableViewCell.backView.cornerRadius = 10
                tableViewCell.singleLineView.isHidden = true
            } else if indexPath.row == 0{
                tableViewCell.backView.roundTop = true
                tableViewCell.backView.cornerRadius = 10
            } else if indexPath.row == cellDatas.count  - 1 {
                tableViewCell.backView.cornerRadius = 10
                tableViewCell.backView.roundBottom = true
                tableViewCell.singleLineView.isHidden = true
            }
            return tableViewCell
        }
        return UITableViewCell.init()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        let cellData = cellDataDic[sectionArray[indexPath.section]]?[indexPath.row]
        cellData?.onCellClicked()
    }
    
    func getSectionTitle(type : ZLWorkboardClassicType) -> String{
        switch type {
        case .fixRepo:
            return ZLLocalizedString(string: "Fixed Repos", comment: "")
        case .work:
            return ZLLocalizedString(string: "My Work", comment: "")
        }
    }
    
}


extension ZLWorkboardBaseView{
    @objc func onNotificationArrived(notification:Notification){
        if notification.name == ZLLanguageTypeChange_Notificaiton{
            self.tableView.reloadData()
        }
    }
    
    @objc func onEditButtonClicked(){
        self.delegate?.onEditFixedRepoButtonClicked()
    }
}
