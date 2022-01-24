//
//  UITableView+ZLExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/17.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func initCommonTableView() {
        
        separatorStyle = .none
        backgroundColor = UIColor.clear
        
        estimatedRowHeight = 44
        rowHeight = UITableView.automaticDimension
        
        estimatedSectionFooterHeight = 20
        sectionFooterHeight = UITableView.automaticDimension
        
        estimatedSectionHeaderHeight = 20
        sectionHeaderHeight = UITableView.automaticDimension
        
        translatesAutoresizingMaskIntoConstraints = false
     
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = 0
        }
    }
    
   
    // UITableViewCell
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: NSStringFromClass(cellType))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell =  dequeueReusableCell(withIdentifier: NSStringFromClass(cellType), for: indexPath) as? T else {
            return T()
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) -> UITableViewCell? {
        guard let cell =  dequeueReusableCell(withIdentifier: NSStringFromClass(cellType)) as? T else {
            return T(style: .default, reuseIdentifier: NSStringFromClass(cellType))
        }
        return cell
    }
    
    // UITableViewHeaderFooterView
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: NSStringFromClass(viewType))
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type) -> T{
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(viewType)) as? T else {
            return T(reuseIdentifier: NSStringFromClass(viewType))
        }
        return view
    }
}
