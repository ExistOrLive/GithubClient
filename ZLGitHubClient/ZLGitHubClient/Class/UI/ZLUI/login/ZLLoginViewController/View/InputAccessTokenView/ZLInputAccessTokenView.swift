//
//  ZLInputAccessTokenView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/6/9.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLInputAccessTokenView: ZLBaseView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    weak var popup: FFPopup?
    var resultBlock : ((String?) -> Void)?
    
    class func showInputAccessTokenViewWithResultBlock(resultBlock: @escaping ((String?) -> Void) ){
        
        guard let view : ZLInputAccessTokenView = Bundle.main.loadNibNamed("ZLInputAccessTokenView", owner:nil , options: nil)?.first as? ZLInputAccessTokenView else {
             return
         }
         view.resultBlock = resultBlock
         
         view.frame = CGRect.init(x: 0, y: 0, width: ZLKeyWindowWidth - 80, height: 190)
         let popup = FFPopup.popup(contetnView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
         view.popup = popup
        let layout = FFPopupLayout.init(horizontal: .center, vertical: .aboveCenter)
        popup.show(layout:layout)
        
        view.textField.becomeFirstResponder()
    }
    
    
    
    override func awakeFromNib() {
        self.titleLabel.text = ZLLocalizedString(string: "Input Access Token", comment: "Input Access Token")
        self.confirmButton.setTitle(ZLLocalizedString(string: "Confirm", comment: ""), for: .normal)
        self.textField.delegate = self
    }

    @IBAction func onConfirmButtonClicked(_ sender: Any) {
        self.popup?.dismiss(animated: true)
        if self.resultBlock != nil {
            self.resultBlock!(self.textField.text)
        }
    }
}

extension ZLInputAccessTokenView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        let textStr : NSString? = self.textField.text as NSString?
        let text : String = textStr?.replacingCharacters(in: range, with: string) ?? ""
        
        self.confirmButton.isEnabled = text.count > 0
       
        return true
    }
    
}
