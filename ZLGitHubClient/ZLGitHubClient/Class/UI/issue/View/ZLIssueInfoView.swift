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
    
    var resetObservable: Observable<[ZLGithubItemTableViewCellData]> { get }
    
    var appendObservable: Observable<[ZLGithubItemTableViewCellData]> { get }
    
    var reloadVisibleCellObservale: Observable<[ZLGithubItemTableViewCellData]> { get }
    
    // delegate
    func onCommentButtonClick()
    
    func onInfoButtonClick()
    
    func onRefreshPullDown()
    
    func onRefreshPullUp()
}

class ZLIssueInfoView: ZLBaseView {
    
    private weak var delegate: ZLIssueInfoViewDelegateAndDataSource?
   
    // Rx
    private let disposeBag = DisposeBag()
    private var errorDisposable: Disposable?
    private var resetDisposable: Disposable?
    private var appendDisposable: Disposable?
    private var reloadVisibleCellDisposable: Disposable?
    
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
        resetDisposable?.dispose()
        appendDisposable?.dispose()
        reloadVisibleCellDisposable?.dispose()
        
        delegate = viewData
        
        errorDisposable = viewData.errorObservable.share().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.itemListView.endRefreshWithError()
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        resetDisposable = viewData.resetObservable.share().subscribe(onNext: { [weak self] element in
            guard let self = self else { return }
            self.itemListView.resetCellDatas(cellDatas: element)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        appendDisposable = viewData.appendObservable.share().subscribe(onNext: { [weak self] element in
            guard let self = self else { return }
            self.itemListView.appendCellDatas(cellDatas: element)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        reloadVisibleCellDisposable = viewData.reloadVisibleCellObservale.share().subscribe(onNext: { [weak self] element in
            guard let self = self else { return }
            self.itemListView.reloadVisibleCells(cellDatas: element)
        }, onError: nil, onCompleted: nil, onDisposed: nil)
        
        errorDisposable?.disposed(by: disposeBag)
        resetDisposable?.disposed(by: disposeBag)
        appendDisposable?.disposed(by: disposeBag)
        reloadVisibleCellDisposable?.disposed(by: disposeBag)
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
private class ZLIssueInfoBottomView: ZLBaseView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(named: "ZLTabBarBackColor")
        
        addSubview(stackView)
        stackView.addArrangedSubview(commentButton)
        stackView.addArrangedSubview(infoButton)
        
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(super.safeAreaLayoutGuide.snp.bottom)
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
        button.setTitleColor(UIColor(named: "ZLTabBarTintColor"), for: .normal)
        return button
    }()
    
    lazy var infoButton: UIButton = {
       let button = UIButton()
        button.setTitle(ZLLocalizedString(string: "Infomation", comment: ""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLTabBarTintColor"), for: .normal)
        return button
    }()
}
