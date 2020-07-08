//
//  ZLRepoLanguagesPercentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import Charts

class ZLRepoLanguagesPercentView: ZLBaseView {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    
    //
    var repoFullName : String = ""
    var data : [String : Int] = [:]
    
    
    class func showRepoLanguagesPercentView(fullName:String) -> Void {
        SVProgressHUD.show()
        ZLRepoServiceModel.shared().getRepoLanguages(withFullName: fullName, serialNumber: NSString.generateSerialNumber(), completeHandle: {(result : ZLOperationResultModel) in
            SVProgressHUD.dismiss()
            if result.result == true {
                
                guard let view : ZLRepoLanguagesPercentView = Bundle.main.loadNibNamed("ZLRepoLanguagesPercentView", owner: nil, options: nil)?.first as? ZLRepoLanguagesPercentView else {
                           return
                       }
                view.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth - 80, height: 480)
                view.repoFullName = fullName
                view.data = result.data as! [String:Int]
                view.startLoadData()

                let popup : FFPopup = FFPopup.popup(contetnView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
                popup.show(layout: .Center)
                
        
            } else {
                ZLToastView.showMessage("Query failed")
            }
            
        })
        
        
        
       
    }
    
    
    override func awakeFromNib() {
        
        self.setUpChartView()
        
    }
    
    func setUpChartView() {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        //         let centerText = NSMutableAttributedString(string: repoFullName ?? "")
        //         centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
        //                                   .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        //         centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //                                   .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        //         centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //                                   .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        //         chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
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
        
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    
    func startLoadData() {
        
        let entries = self.data.map { (key: String, value: Int) -> PieChartDataEntry in
            return PieChartDataEntry(value: Double(value),label:key,icon:nil)
        }
                
        let set = PieChartDataSet(entries: entries, label: "Language Percent")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
        
    }

}
