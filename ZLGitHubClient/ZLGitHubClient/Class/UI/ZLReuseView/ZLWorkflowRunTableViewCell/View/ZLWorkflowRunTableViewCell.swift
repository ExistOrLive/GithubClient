//
//  ZLWorkflowRunTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLWorkflowRunTableViewCellDelegate : NSObjectProtocol {
    func onMoreButtonClicked(button:UIButton) -> Void
}


class ZLWorkflowRunTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var workflowRunTitleLabel: UILabel!
    @IBOutlet weak var workflowDescLabel: YYLabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var branchLabel: YYLabel!
    
    weak var delegate : ZLWorkflowRunTableViewCellDelegate?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.branchLabel.preferredMaxLayoutWidth = 200
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        if self.delegate?.responds(to: #selector(ZLWorkflowRunTableViewCellDelegate.onMoreButtonClicked(button:))) ?? false {
            self.delegate?.onMoreButtonClicked(button: sender)
        }
    }
    
    func fillWithData(data : ZLWorkflowRunTableViewCellData) {
        self.workflowRunTitleLabel.text = data.getWorkflowRunTitle()
        self.workflowDescLabel.attributedText = data.getWorkflowRunDesc()
        self.timeLabel.text = data.getTimeStr()
        self.branchLabel.attributedText = data.getBranchStr()
        
        if data.getStatus() == "completed" {
            if data.getConclusion() == "success" {
                self.stateImageView.image = UIImage.init(named: "run_success")
            } else if data.getConclusion() == "failure" {
                self.stateImageView.image = UIImage.init(named: "run_failed")
            } else if data.getConclusion() == "cancelled" {
                self.stateImageView.image = UIImage.init(named: "run_cancel")
            }
            
        } else if data.getStatus() == "in_progress" {
            self.stateImageView.image = UIImage.init(named: "run_inprogress")
        }
        
    }
    
}
