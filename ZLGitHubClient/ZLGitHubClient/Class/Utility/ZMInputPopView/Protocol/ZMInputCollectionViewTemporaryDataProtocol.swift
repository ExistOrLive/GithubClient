//
//  ZMInputCollectionViewTemporaryDataProtocol.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2023/10/15.
//  Copyright © 2023 ZM. All rights reserved.
//

import Foundation

/// 暂存数据协议
public protocol ZMInputCollectionViewTemporaryDataProtocol {
    /// 获取暂存数据
    func temporaryDataFor(key: String) -> Any?
    /// 设置暂存数据
    func setTemporaryData(_ newData: Any?, for key: String)
    /// flush暂存数据
    func flushTemporaryDataToRealData()
    /// 读取数据到暂存中
    func readTemporaryDataFromRealData()
    /// 重置暂存中的数据
    func resetTemporaryData()
}

var ZMInputCollectionViewTemporaryDataProtocol_Key = ""

public extension ZMInputCollectionViewTemporaryDataProtocol {

    func temporaryDataFor(key: String) -> Any? {
        let dataDic = objc_getAssociatedObject(self, &(ZMInputCollectionViewTemporaryDataProtocol_Key)) as? [String:Any] ?? [:]
        return dataDic[key]
    }

    func setTemporaryData(_ newData: Any?, for key: String) {
        var dataDic = objc_getAssociatedObject(self, &(ZMInputCollectionViewTemporaryDataProtocol_Key)) as? [String:Any] ?? [:]
        if let data = newData {
            dataDic[key] = data
        } else {
            dataDic.removeValue(forKey: key)
        }
        objc_setAssociatedObject(self, &(ZMInputCollectionViewTemporaryDataProtocol_Key) , dataDic, .OBJC_ASSOCIATION_COPY)
    }

    func resetTemporaryData() {
        objc_setAssociatedObject(self, &(ZMInputCollectionViewTemporaryDataProtocol_Key) , [:], .OBJC_ASSOCIATION_COPY)
    }
}
