//
//  ZLIssueTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/13.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueTableViewCellDelegate : NSObjectProtocol{
    
    func getIssueRepoFullName() -> String?
    
    func getIssueTitleStr() -> String?
    
    func isIssueClosed() -> Bool
    
    func getIssueAssistStr() -> String?
    
    func getIssueLabels() -> [(String,String)]

    func onClickIssueRepoFullName()
}

class ZLIssueTableViewCell: UITableViewCell {
    
    var containerView: UIView!
    var statusTag: UIImageView!
    var repoNameButton: UIButton!
    var labelStackView: UIStackView!
    var titleLabel: UILabel!
    var assitLabel: UILabel!
        
    
    weak var delegate : ZLIssueTableViewCellDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    @objc func onRepoNameClick() {
        self.delegate?.onClickIssueRepoFullName()
    }
    
    
    func setUpUI(){
        
        self.backgroundColor = UIColor.clear
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        containerView = view
        
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        statusTag = imageView
        
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        containerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.centerY.equalTo(statusTag)
            make.right.equalToSuperview().offset(-15)
        }
        button.addTarget(self, action: #selector(onRepoNameClick), for: .touchUpInside)
        repoNameButton = button
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(named:"ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 15)
        containerView.addSubview(label)
        label.snp.makeConstraints{ (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.top.equalTo(repoNameButton.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        titleLabel = label
        
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        labelStackView = stackView
        
        let label2 = UILabel()
        label2.textColor = UIColor(named:"ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        containerView.addSubview(label2)
        label2.snp.makeConstraints{ (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        assitLabel = label2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func fillWithData(cellData : ZLIssueTableViewCellDelegate){
        
        self.delegate = cellData
        
        self.repoNameButton.setAttributedTitle(NSAttributedString(string: cellData.getIssueRepoFullName() ?? "",attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!,NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 15)!]), for: .normal)
        
        self.titleLabel.text = cellData.getIssueTitleStr()
        self.assitLabel.text = cellData.getIssueAssistStr()
        self.statusTag.image = cellData.isIssueClosed() ? UIImage.init(named: "issue_closed") : UIImage.init(named: "issue_opened")
        
        
        for view in self.labelStackView.subviews{
            view.removeFromSuperview()
        }
        
        var length : CGFloat = 0.0
        for (label,colorStr) in cellData.getIssueLabels(){
            let font = UIFont.init(name: Font_PingFangSCRegular, size: 11)
            let attributes : [NSAttributedString.Key : Any]  = [NSAttributedString.Key.font : font!]
            let attributedStr = NSAttributedString.init(string: label, attributes: attributes)
            let size = attributedStr.boundingRect(with: CGSize.init(width: ZLScreenWidth, height: ZLSCreenHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
            
            if CGFloat(length) + 8.0 + size.width > ZLScreenWidth - 60 {
                break;
            }
            length += 8.0 + size.width
            
            let color = ZLRGBValueStr_H(colorValue:colorStr)
            let labelView = UILabel.init()
            labelView.textAlignment = .center
            labelView.font = font
            labelView.text = label
            labelView.layer.cornerRadius = 8.0
            labelView.layer.masksToBounds = true
            labelView.backgroundColor = color
            labelView.textColor = UIColor.isLightColor(color) ? ZLRGBValue_H(colorValue: 0x333333) : UIColor.white
            
            if #available(iOS 12.0, *) {
                if getRealUserInterfaceStyle() == .dark {
                    labelView.backgroundColor = ZLRGBValueStr_H(colorValue: colorStr, alphaValue: 0.2)
                    labelView.layer.borderWidth = 1.0 / labelView.layer.contentsScale;
                    labelView.layer.borderColor = ZLRGBValueStr_H(colorValue:colorStr, alphaValue: 0.5).cgColor
                    labelView.textColor = ZLRGBValueStr_H(colorValue:colorStr)
                }
            }

            labelView.snp.makeConstraints { (make) in
                make.width.equalTo(8.0 + size.width)
            }
            self.labelStackView.addArrangedSubview(labelView)
        }
        
        self.labelStackView.snp.updateConstraints { (make) in
            make.height.equalTo(cellData.getIssueLabels().count == 0 ? 0 : 20)
        }

    }
    
    
}
