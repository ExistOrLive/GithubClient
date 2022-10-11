//
//  ZLRepoLanguagesPercentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import Charts
import FFPopup
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLRepoLanguagesPercentView: ZLBaseView {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var chartView: PieChartView!

    //
    var repoFullName: String = ""
    var data: [String: Int] = [:]

    class func showRepoLanguagesPercentView(fullName: String) {
        ZLProgressHUD.show()
        ZLServiceManager.sharedInstance.repoServiceModel?.getRepoLanguages(withFullName: fullName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(result: ZLOperationResultModel) in
            ZLProgressHUD.dismiss()
            if result.result == true {

                guard let data = result.data as? [String: Int] else {
                    return
                }

                guard let view: ZLRepoLanguagesPercentView = Bundle.main.loadNibNamed("ZLRepoLanguagesPercentView", owner: nil, options: nil)?.first as? ZLRepoLanguagesPercentView else {
                           return
                       }
                view.frame = CGRect.init(x: 0, y: 0, width: 280, height: 480)
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

    override func awakeFromNib() {

        self.setUpChartView()
        self.titleLable.text = ZLLocalizedString(string: "Language", comment: "")
    }

    func setUpChartView() {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 5)

        chartView.drawHoleEnabled = false
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true

        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = UIFont.init(name: Font_PingFangSCMedium, size: 12) ?? UIFont.systemFont(ofSize: 12)
        l.textColor = UIColor.label(withName: "ZLLabelColor1")

        chartView.animate(xAxisDuration: 0, easingOption: .easeOutBack)
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
                let entry = PieChartDataEntry(value: Double(item.value), label: item.key, icon: nil)
                entries.append(entry)
            } else {
                otherSize = otherSize + item.value
            }
        }

        if otherSize > 0 {
            let entry = PieChartDataEntry(value: Double(otherSize), label: "other", icon: nil)
            entries.append(entry)
        }

        let set = PieChartDataSet(entries: entries, label: nil)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        set.yValuePosition = .outsideSlice
        set.xValuePosition = .outsideSlice

        set.colors = [ZLRGBValue_H(colorValue: 0x438EFF),
                      ZLRGBValue_H(colorValue: 0xFFAC44),
                      ZLRGBValue_H(colorValue: 0x555555),
                      ZLRGBValue_H(colorValue: 0x701516),
                      ZLRGBValue_H(colorValue: 0xEDEDED)]

        let data = PieChartData(dataSet: set)

        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))

        data.setValueFont(UIFont.init(name: Font_PingFangSCMedium, size: 12) ?? UIFont.systemFont(ofSize: 12))
        data.setValueTextColor(UIColor.label(withName: "ZLLabelColor1"))

        chartView.data = data
        chartView.highlightValues(nil)

    }

}
