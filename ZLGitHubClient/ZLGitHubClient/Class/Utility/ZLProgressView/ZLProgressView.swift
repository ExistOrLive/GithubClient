//
//  ZLProgressView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLProgressView: UIView {
    
    private var percents: [Double] = [Double]()
    
    private var colors: [UIColor] = [UIColor]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(params:[(Double,UIColor)]) {
        
        let (sum,values,colors) = params.reduce((0.0,[Double](),[UIColor]())) { partialResult, element in
            let (value,color) = element
            var (sum,values,colors) = partialResult
            sum = sum + value
            values.append(value)
            colors.append(color)
            return (sum,values,colors)
        }
        
        if sum > 0 {
            percents = values.map({ value in
                value / sum
            })
            self.colors = colors
         
            if sum > 0 {
                setupUI()
            }
        }
    }
    
    private func setupUI() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        for i in 0..<percents.count {
            let view = UIView()
            view.backgroundColor = colors[i]
            stackView.addArrangedSubview(view)
            view.snp.makeConstraints { make in
                make.width.equalTo(self).multipliedBy(percents[i])
            }
        }
    }
    
}
