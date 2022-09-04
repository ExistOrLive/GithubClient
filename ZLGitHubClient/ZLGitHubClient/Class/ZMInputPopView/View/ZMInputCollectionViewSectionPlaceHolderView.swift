//
//  ZMInputCollectionViewSectionPlaceHolderView.swift
//  ZMInputCollectionViewSectionPlaceHolderView
//
//  Created by zhumeng on 2022/8/1.
//

import Foundation
import UIKit

/// 空白占位 Section Header

public class ZMInputCollectionViewSectionPlaceHolderView: UICollectionReusableView {
       
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
