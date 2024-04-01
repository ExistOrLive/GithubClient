//
//  ZLRepoLanguagesPercentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import DGCharts
import FFPopup
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLRepoLanguagesPercentView: ZLBaseView {

    var repoFullName: String = ""
    var data: [String: Int] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        cornerRadius = 8.0
        clipsToBounds = true
        backgroundColor = UIColor(named: "ZLPopUpBackColor")
        addSubview(titleBackView)
        addSubview(chartView)
        titleBackView.addSubview(titleLabel)
        titleBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        chartView.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
    }
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .zlMediumFont(withSize: 15)
        label.textColor = UIColor(named: "ZLPopupTitleColor")
        label.text = ZLLocalizedString(string: "Language", comment: "")
        return label
    }()
    
    lazy var titleBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLPopUpTitleBackView")
        return view
    }()
    
    lazy var chartView: PieChartView = {
        let view = PieChartView()
        
        view.usePercentValuesEnabled = true
        view.drawSlicesUnderHoleEnabled = false
        view.holeRadiusPercent = 0.58
        view.transparentCircleRadiusPercent = 0.61
        view.chartDescription.enabled = false
        view.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 5)
        
        view.drawHoleEnabled = false
        view.rotationAngle = 0
        view.rotationEnabled = true
        view.highlightPerTapEnabled = true
        
        let l = view.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = .zlMediumFont(withSize: 12)
        l.textColor = UIColor.label(withName: "ZLLabelColor1")
        
        view.animate(xAxisDuration: 0, easingOption: .easeOutBack)
        return view
    }()
    

    class func showRepoLanguagesPercentView(fullName: String) {
        ZLProgressHUD.show()
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoLanguages(withFullName: fullName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(result: ZLOperationResultModel) in
            ZLProgressHUD.dismiss()
            if result.result == true {

                guard let data = result.data as? [String: Int] else {
                    return
                }

                let view = ZLRepoLanguagesPercentView(frame:  CGRect(x: 0, y: 0, width: 280, height: 480))
                view.repoFullName = fullName
                view.data = data
                view.startLoadData()

                let popup: FFPopup = FFPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
                popup.show(layout: .Center)

            } else {
                ZLToastView.showMessage("Query failed")
            }

        })

    }

    func startLoadData() {

        var totalSize = 0
        for value in self.data.values {
            totalSize = totalSize + value
        }

        var entries: [PieChartDataEntry] = []
        var otherSize = 0
        for item in self.data {
            let percent = Double(item.value) / Double(totalSize)
            if percent > 0.01 {
                let entry = PieChartDataEntry(value: percent, label: item.key, icon: nil)
                entries.append(entry)
            } else {
                otherSize = otherSize + item.value
            }
        }

        if otherSize > 0 {
            let entry = PieChartDataEntry(value: Double(otherSize) / Double(totalSize), label: "Other", icon: nil)
            entries.append(entry)
        }

        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.yValuePosition = .outsideSlice
        set.xValuePosition = .outsideSlice
        
        set.colors = [ZLRGBValue_H(colorValue: 0x438EFF),
                      ZLRGBValue_H(colorValue: 0xFFAC44),
                      ZLRGBValue_H(colorValue: 0x555555),
                      ZLRGBValue_H(colorValue: 0x701516),
                      ZLRGBValue_H(colorValue: 0xEDEDED)]
        
        set.valueFont = .zlMediumFont(withSize: 12)
        set.valueTextColor = UIColor.label(withName: "ZLLabelColor1")

        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
              pFormatter.numberStyle = .percent
              pFormatter.maximumFractionDigits = 1
              pFormatter.multiplier = 1
              pFormatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        chartView.data = data
        chartView.highlightValues(nil)

    }

}
