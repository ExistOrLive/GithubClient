//
//  ZLIssueLabelsCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

protocol ZLIssueLabelsCellDataSource: NSObjectProtocol {
    var labelsStr: NSAttributedString? {get}
}

class ZLIssueLabelsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(labelsLabel)
        labelsLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
   
    
    // MARK: Lazy View 
    lazy var labelsLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()

}

extension ZLIssueLabelsCell: ZLViewUpdatableWithViewData {
    func fillWithViewData(viewData: ZLIssueLabelsCellDataSource) {
        labelsLabel.attributedText = viewData.labelsStr
    }
}
