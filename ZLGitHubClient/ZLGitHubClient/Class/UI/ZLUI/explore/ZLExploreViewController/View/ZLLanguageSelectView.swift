//
//  ZLLanguageSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLLanguageSelectView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var popup : FFPopup?
   
    var resultBlock : ((String) -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.text = ZLLocalizedString(string: "Select a language", comment: "选择一种语言")
        let attributedPlaceHolder = NSAttributedString.init(string: ZLLocalizedString(string: "Filter languages", comment: "筛选语言"), attributes: [NSAttributedString.Key.foregroundColor:ZLRGBValue_H(colorValue: 0xCED1D6),NSAttributedString.Key.font:UIFont.init(name: Font_PingFangSCRegular, size: 12) ?? UIFont.systemFont(ofSize: 12)])
        self.textField.attributedPlaceholder = attributedPlaceHolder
        
        self.tableView.register(UINib.init(nibName: "ZLLanguageTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLLanguageTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    static func showLanguageSelectView(resultBlock : @escaping ((String) -> Void)) {
        
        guard let view : ZLLanguageSelectView = Bundle.main.loadNibNamed("ZLLanguageSelectView", owner:nil , options: nil)?.first as? ZLLanguageSelectView else {
            return
        }
        view.resultBlock = resultBlock
        
        view.frame = CGRect.init(x: 0, y: 0, width: ZLScreenWidth - 80, height: 500)
        let popup = FFPopup.popup(contetnView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: .Center)
        
    
    }

}


extension ZLLanguageSelectView : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : ZLLanguageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLLanguageTableViewCell", for: indexPath) as? ZLLanguageTableViewCell else {
            return UITableViewCell.init()
        }
        cell.languageLabel.text = "c++";
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.popup?.dismiss(animated: true)
    }
    
    
}
