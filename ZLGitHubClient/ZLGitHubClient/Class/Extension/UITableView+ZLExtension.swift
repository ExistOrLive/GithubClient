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

    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: NSStringFromClass(cellType))
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(cellType), for: indexPath)
    }

    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type) -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(cellType))
    }
}
