//
//  ZLIssueTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/13.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLIssueTableViewCellDelegate : NSObjectProtocol{
    func onCellClicked() -> Void
}

class ZLIssueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusTag: UIImageView!
    @IBOutlet weak var assitLabel: UILabel!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    var delegate : ZLIssueTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(self.onCellClicked(gestureRecognizer:)))
        self.containerView.addGestureRecognizer(gestureRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillWithData(cellData : ZLIssueTableViewCellData){
        self.titleLabel.text = cellData.getIssueTitleStr()
        self.assitLabel.text = cellData.getAssistStr()
        self.statusTag.image = cellData.isIssueClosed() ? UIImage.init(named: "closed_issue") : UIImage.init(named: "opened_issue")
        
        for view in self.labelStackView.subviews{
            view.removeFromSuperview()
        }
        
        var length : CGFloat = 0.0
        for label in cellData.getLabels(){
            let font = UIFont.init(name: Font_PingFangSCRegular, size: 11)
            let attributes : [NSAttributedString.Key : Any]  = [NSAttributedString.Key.font : font!]
            let attributedStr = NSAttributedString.init(string: label, attributes: attributes)
            let size = attributedStr.boundingRect(with: CGSize.init(width: ZLScreenWidth, height: ZLSCreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            if CGFloat(length) + 8.0 + size.width > ZLScreenWidth - 60 {
                break;
            }
            length += 8.0 + size.width
            
            let labelView = UILabel.init()
            labelView.textAlignment = .center
            labelView.font = font
            labelView.text = label
            labelView.layer.cornerRadius = 8.0
            labelView.layer.masksToBounds = true
            labelView.backgroundColor = ZLRGBValue_H(colorValue: 0xEDEDED)
            labelView.snp.makeConstraints { (make) in
                make.width.equalTo(8.0 + size.width)
            }
            self.labelStackView.addArrangedSubview(labelView)
        }

    }
    
    
}


extension ZLIssueTableViewCell{
    @objc func onCellClicked(gestureRecognizer: UITapGestureRecognizer){
        if self.delegate?.responds(to: #selector(ZLIssueTableViewCellDelegate.onCellClicked)) ?? false{
            self.delegate?.onCellClicked()
        }
    }
}
