//
//  ZLIssueTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/13.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueTableViewCellDelegate : NSObjectProtocol{
    
    func getIssueTitleStr() -> String?
    
    func isIssueClosed() -> Bool
    
    func getAssistStr() -> String?
    
    func getLabels() -> [(String,String)]
    
}

class ZLIssueTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusTag: UIImageView!
    @IBOutlet weak var assitLabel: UILabel!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate : ZLIssueTableViewCellDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func fillWithData(cellData : ZLIssueTableViewCellDelegate){
        
        self.delegate = cellData
        
        self.titleLabel.text = cellData.getIssueTitleStr()
        self.assitLabel.text = cellData.getAssistStr()
        self.statusTag.image = cellData.isIssueClosed() ? UIImage.init(named: "issue_closed") : UIImage.init(named: "issue_opened")
        
        for view in self.labelStackView.subviews{
            view.removeFromSuperview()
        }
        
        var length : CGFloat = 0.0
        for (label,color) in cellData.getLabels(){
            let font = UIFont.init(name: Font_PingFangSCRegular, size: 11)
            let attributes : [NSAttributedString.Key : Any]  = [NSAttributedString.Key.font : font!]
            let attributedStr = NSAttributedString.init(string: label, attributes: attributes)
            let size = attributedStr.boundingRect(with: CGSize.init(width: ZLScreenWidth, height: ZLSCreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            if CGFloat(length) + 8.0 + size.width > ZLScreenWidth - 60 {
                break;
            }
            length += 8.0 + size.width
            
            let color = ZLRGBValueStr_H(colorValue:color)
            let labelView = UILabel.init()
            labelView.textAlignment = .center
            labelView.font = font
            labelView.text = label
            labelView.layer.cornerRadius = 8.0
            labelView.layer.masksToBounds = true
            labelView.backgroundColor = color
            labelView.textColor = UIColor.isLightColor(color) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white
            
//            let labelView = UILabel.init()
//            labelView.textAlignment = .center
//            labelView.font = font
//            labelView.text = label
//            labelView.layer.cornerRadius = 8.0
//            labelView.layer.masksToBounds = true
//            labelView.backgroundColor = ZLRGBValueStr_H(colorValue: color, alphaValue: 0.2)
//            labelView.layer.borderWidth = 1.0 / labelView.layer.contentsScale;
//            labelView.layer.borderColor = ZLRGBValueStr_H(colorValue:color, alphaValue: 0.5).cgColor
//            labelView.textColor = ZLRGBValueStr_H(colorValue:color)
            
            labelView.snp.makeConstraints { (make) in
                make.width.equalTo(8.0 + size.width)
            }
            self.labelStackView.addArrangedSubview(labelView)
        }

    }
    
    
}
