//
//  ZLPullRequestTimelineTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

protocol ZLPullRequestTimelineTableViewCellDelegate : NSObjectProtocol {
    func getTimelineMessage() -> NSAttributedString
}


class ZLPullRequestTimelineTableViewCell: UITableViewCell {
    
    var timelineMessageLabel : UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func setUpUI(){
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        
        
        let label = UILabel()
        label.font = UIFont(name: Font_PingFangSCSemiBold, size: 15)
        label.numberOfLines = 0
        label.textColor = UIColor(named: "ZLLabelColor1")
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 25, bottom: 10, right: 25))
        }
        timelineMessageLabel = label
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(label.snp.top)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(1)
        }
    }

    
    func fillWithData(data : ZLPullRequestTimelineTableViewCellDelegate) {
        timelineMessageLabel.attributedText = data.getTimelineMessage()
    }
}

