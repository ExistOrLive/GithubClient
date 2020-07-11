//
//  ZLWorkflowTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLWorkflowTableViewCellDelegate : NSObjectProtocol {
    func onConfigButtonClicked() -> Void
}

class ZLWorkflowTableViewCell: UITableViewCell {
    
    @IBOutlet weak var workflowTitleLabel: UILabel!
    @IBOutlet weak var workflowStateLabel: UILabel!
    @IBOutlet weak var configButton: UIButton!
    
    var delegate : ZLWorkflowTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configButton.setTitle(ZLLocalizedString(string: "config", comment: ""), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    @IBAction func onConfigButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLWorkflowTableViewCellDelegate.onConfigButtonClicked)) ?? false {
            self.delegate?.onConfigButtonClicked()
        }
    }
    
    func fillWithData(cellData : ZLWorkflowTableViewCellData) {
        self.workflowTitleLabel.text = cellData.getWorkflowTitle()
        self.workflowStateLabel.text = cellData.getWorkflowState()
    }
    
}
