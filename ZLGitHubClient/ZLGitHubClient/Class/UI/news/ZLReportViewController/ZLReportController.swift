//
//  ZLReportController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService

class ZLReportController: ZMViewController {

    var loginName: String?

    let reasons = [ZLLocalizedString(string: "illegal prohibited", comment: ""),
                   ZLLocalizedString(string: "pornographic", comment: ""),
                   ZLLocalizedString(string: "advertising fraud", comment: ""),
                   ZLLocalizedString(string: "juvenile correlation", comment: ""),
                   ZLLocalizedString(string: "insults abuse", comment: ""),
                   ZLLocalizedString(string: "other", comment: "")]

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var reasonPickerView: UIPickerView!
    @IBOutlet weak var reportedUserLabel: UILabel!
    @IBOutlet weak var reportReasonLabel: UILabel!
    @IBOutlet weak var submitButton: ZLBaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "Report", comment: "")

        guard let baseView: UIView  = Bundle.main.loadNibNamed("ZLReportBaseView", owner: self, options: nil)?.first as? UIView else {
            return
        }

        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 0, bottom: 0, right: 0))
        }

        self.userLabel.text = self.loginName
        self.reportedUserLabel.text = ZLLocalizedString(string: "Reported User", comment: "")
        self.reportReasonLabel.text = ZLLocalizedString(string: "Report Reason", comment: "")
        self.submitButton.setTitle(ZLLocalizedString(string: "submit", comment: ""), for: .normal)

        self.reasonPickerView.delegate = self
        self.reasonPickerView.dataSource = self
    }

    @IBAction func onSubmitButtonClicked(_ sender: Any) {

        ZLProgressHUD.show()
        weak var weakSelf = self
        ZLServiceManager.sharedInstance.userServiceModel?.blockUser(withLoginName: self.loginName ?? "", serialNumber: NSString.generateSerialNumber()) { (model) in

            ZLProgressHUD.dismiss()

            if model.result == true {
                ZLToastView.showMessage(ZLLocalizedString(string: "Report Success", comment: ""))
                weakSelf?.navigationController?.popViewController(animated: true)
            } else {
                ZLToastView.showMessage(ZLLocalizedString(string: "Report Failed", comment: ""))
            }
        }

    }

}

extension ZLReportController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasons.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
}
