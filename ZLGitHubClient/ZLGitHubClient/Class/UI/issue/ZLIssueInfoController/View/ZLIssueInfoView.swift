//
//  ZLIssueInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/2/23.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ZLBaseUI

protocol ZLIssueInfoViewDelegateAndDataSource: NSObjectProtocol {
    
    // Observable
    var errorObservable: Observable<Void> { get }
    
    var setObservable: Observable<([ZLGithubItemTableViewCellData],Bool)> { get }
    
    var reloadVisibleCellObservale: Observable<[ZLGithubItemTableViewCellData]> { get }
    
    var canReactObservale: Observable<Bool> { get }
    
    // delegate
    func onCommentButtonClick()
    
    func onInfoButtonClick()
    
    func onRefreshPullDown()
    
    func onRefreshPullUp()
}

class ZLIssueInfoView: UIView {
    
    private weak var delegate: ZLIssueInfoViewDelegateAndDataSource?
   
    // Rx
    private let disposeBag = DisposeBag()
    private var errorDisposable: Disposable?
    private var setDisposable: Disposable?
    private var appendDisposable: Disposable?
    private var reloadVisibleCellDisposable: Disposable?
    private var canReactDisposable: Disposable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(itemListView)
        addSubview(bottomView)
        itemListView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(itemListView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        itemListView.delegate = self
                
        bottomView.infoButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.delegate?.onInfoButtonClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        bottomView.commentButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.delegate?.onCommentButtonClick()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
    }
    
    lazy private var itemListView: ZLGithubItemListView = {
        let view = ZLGithubItemListView()
        view.setTableViewHeader()
        view.setTableViewFooter()
        return view 
    }()
   
    lazy private var bottomView: ZLIssueInfoBottomView = {
        let view = ZLIssueInfoBottomView()
        return view
    }()
    
}


extension ZLIssueInfoView {
    
    func beginRefresh() {
        self.itemListView.beginRefresh()
    }
    
    func fillWithData(viewData: ZLIssueInfoViewDelegateAndDataSource) {
        
        errorDisposable?.dispose()
        setDisposable?.dispose()
        appendDisposable?.dispose()
        reloadVisibleCellDisposable?.dispose()
        canReactDisposable?.dispose()
        
        delegate = viewData
        
        errorDisposable = viewData.errorObservable.share().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.itemListView.endRefreshWithError()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        setDisposable = viewData.setObservable.share().subscribe(onNext: { [weak self] element in
            let (cellDatas,lastPage) = element
            guard let self = self else { return }
            self.itemListView.setCellDatas(cellDatas: cellDatas,lastPage: lastPage)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
       
        
        reloadVisibleCellDisposable = viewData.reloadVisibleCellObservale.share().subscribe(onNext: { [weak self] element in
            guard let self = self else { return }
            self.itemListView.batchUpdatesHeight()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        canReactDisposable = viewData.canReactObservale.share().bind(to: bottomView.commentButton.rx.isEnabled)
        
        errorDisposable?.disposed(by: disposeBag)
        setDisposable?.disposed(by: disposeBag)
        appendDisposable?.disposed(by: disposeBag)
        reloadVisibleCellDisposable?.disposed(by: disposeBag)
        canReactDisposable?.disposed(by: disposeBag)
    }
    
}

// MARK: ZLGithubItemListViewDelegate
extension ZLIssueInfoView: ZLGithubItemListViewDelegate {
    
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        delegate?.onRefreshPullDown()
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        delegate?.onRefreshPullUp()
    }
}

// MARK: ZLIssueInfoBottomView
class ZLIssueInfoBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        backgroundColor = UIColor(named: "ZLTabBarBackColor")
        
        if getRealUserInterfaceStyle() == .light {
            layer.shadowColor = UIColor.black.cgColor
        } else {
            layer.shadowColor = UIColor.white.cgColor
        }
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: -1.5)
        
        addSubview(stackView)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(infoButton)
        addSubview(seperateLine)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(super.safeAreaLayoutGuide.snp.bottom)
        }
        
        seperateLine.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 1.0 / UIScreen.main.scale , height: 30))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(7)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // 外观模式切换
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
                
                if getRealUserInterfaceStyle() == .light {
                    layer.shadowColor = UIColor.black.cgColor
                } else {
                    layer.shadowColor = UIColor.white.cgColor
                }
            }
        }
    }
    

    // MARK: Lazy View
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var commentButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "Comment", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor2"), for: .disabled)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        button.isEnabled = false
        return button
    }()
    
    lazy var infoButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "Infomation", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor1"), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor2"), for: .disabled)
        button.titleLabel?.font = UIFont.zlMediumFont(withSize: 16)
        return button
    }()
    
    lazy var seperateLine: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        return view
    }()
}
