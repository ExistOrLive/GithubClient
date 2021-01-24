//
//  ZLReportController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLReportController: ZLBaseViewController {
    
    var loginName : String?
    
    static let reasons = ["illegal prohibited","pornographic","advertising fraud","juvenile correlation","insults abuse","other"]
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var reasonPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Report"
        
        guard let baseView : UIView  = Bundle.main.loadNibNamed("ZLReportBaseView", owner: self, options: nil)?.first as? UIView else {
            return
        }
        
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        }
        
        self.userLabel.text = self.loginName
        
        self.reasonPickerView.delegate = self
        self.reasonPickerView.dataSource = self
    }
    
    
    @IBAction func onSubmitButtonClicked(_ sender: Any) {
        
        SVProgressHUD.show()
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.userServiceModel?.blockUser(withLoginName: self.loginName ?? "", serialNumber: NSString.generateSerialNumber()) { (model) in
            
            SVProgressHUD.dismiss()
            
            if model.result == true{
                ZLToastView.showMessage("Report Success")
                weakSelf?.navigationController?.popViewController(animated: true)
            } else {
                ZLToastView.showMessage("Report Failed")
            }
        }
        
    }
    
    
    
}

extension ZLReportController : UIPickerViewDelegate,UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return ZLReportController.reasons.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return ZLReportController.reasons[row]
    }
}
