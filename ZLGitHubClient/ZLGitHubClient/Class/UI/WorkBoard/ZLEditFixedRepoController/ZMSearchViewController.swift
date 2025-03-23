//
//  ZMSearchViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/23.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM
import ZLUIUtilities


/// 单页式 搜索基类
/// 1. 提供通用的search bar 样式 和 table view 布局
/// 2. 进入页面自动拉起键盘；离开页面收起键盘
/// 3. 点击键盘搜索按钮，触发搜索
/// 4. 关键字为空，清空数据
/// 5. 未点击键盘搜索按钮而触发键盘收起时，会自动恢复上次的搜索关键字
/// 6. 点击取消，退出搜索页
///
///
/// 派生字类时：
/// 1. 重写 refreshLoadNewData 和 refreshLoadMoreData 提供网络请求的实现
/// 2. 重写 UITableView 相关方法提示列表样式
open class ZMSearchViewController: ZMTableViewController, ZMSearchBarDelegate {

    /// 搜索关键字
    @objc open dynamic var searchText: String = ""

    public override init(style: UITableView.Style = UITableView.Style.grouped) {
        super.init(style: style)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc open override dynamic func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirst()
    }

    @objc open override dynamic func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirst()
    }

    @objc open override dynamic func setupUI() {
        super.setupUI()
        self.isZmNavigationBarHidden = true
        self.setRefreshViews(types: [.header,.footer])
        setupSubView()
        autoLayout()
    }

    @objc open dynamic func setupSubView() {
        tableView.removeFromSuperview()
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(searchBarBackView)
        verticalStackView.addArrangedSubview(tableView)
    }

    @objc open dynamic func autoLayout() {

        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }


    /// 子类重写，清空数据和lastId，并返回true
    @objc open dynamic func clearDatas() -> Bool {
        sectionDataArray.forEach {
            $0.zm_removeFromSuperViewModel()
        }
        sectionDataArray = []
        tableView.reloadData()
        return false
    }

    // MARK: DuTBaseSellerSearchBarDelegate
    /// 点击取消按钮
    @objc open dynamic func onCancelButtonClicked() {
        navigationController?.popViewController(animated: false)
    }

    /// 输入框内容改变时触发
    @objc open dynamic func onSearchTextChanged(text: String) {

    }

    /// 输入框结束编辑
    @objc open dynamic func onSearchTextEndEditing() {
        let currentText = searchBar.searchTextField.text ?? ""
        if currentText != searchText {
            searchBar.searchTextField.text = searchText
        }
    }

    /// 输入框将结束编辑时触发
    @objc open dynamic func onSearchTextFieldShouldEndEditing() -> Bool {
        return true
    }

    /// 点击键盘搜索触发
    @objc open dynamic func onSearchTextConfirmed(text: String) {
        searchText = text

        if !searchText.isEmpty {
            /// 关键字非空则请求数据
            searchBar.resignFirst()
            viewStatus = .loading
            refreshLoadNewData()
        } else {
            /// 关键字非空，清空数据
            if clearDatas() {
                viewStatus = .normal
                endRefreshViews(noMoreData: true)
            }
        }
    }

    // MARK: Lazy View
    @objc public dynamic lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()

    @objc public dynamic lazy var searchBarBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SearchBarBack")
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(ZMUIConfig.shared.navigationBarHeight)
        }
        return view
    }()
    
    @objc public dynamic lazy var searchBar: ZMSearchBar = {
        let searchBar = ZMSearchBar()
        searchBar.delegate = self
        return searchBar
    }()
}



//MARK: - ZMSearchBar
@objc public protocol ZMSearchBarDelegate: AnyObject {
    func onCancelButtonClicked()
    func onSearchTextChanged(text: String)
    func onSearchTextEndEditing()
    func onSearchTextConfirmed(text: String)
    func onSearchTextFieldShouldEndEditing() -> Bool
}

public class ZMSearchBar: UIView, UITextFieldDelegate {

    @objc public dynamic weak var delegate: ZMSearchBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc dynamic func setup() {
        backgroundColor = .clear
        self.addSubview(contentStack)
        contentStack.addArrangedSubview(searchTextField)
        contentStack.addArrangedSubview(cancleBtn)
        contentStack.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        cancleBtn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalToSuperview()
        }
        searchTextField.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }
    }

    @objc public dynamic func becomeFirst(){
        self.searchTextField.becomeFirstResponder()
    }

    @objc public dynamic func resignFirst(){
        self.searchTextField.resignFirstResponder()
    }

    @objc dynamic func cancelAction() {
        self.delegate?.onCancelButtonClicked()
    }

    // MARK: Lazy View
    @objc private lazy dynamic var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()

    @objc public lazy dynamic var searchTextField: ZMSearchTextField = {
        let searchTextField = ZMSearchTextField()
        searchTextField.placeholder = ZLLocalizedString(string:"Search", comment:"")
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        return searchTextField
    }()

    @objc public lazy dynamic var cancleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .zlMediumFont(withSize: 14)
        button.setTitle(ZLLocalizedString(string:"Cancel", comment:""), for: .normal)
        button.setTitleColor(UIColor(named: "ZLLabelColor3"), for: .normal)
        button.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        return button
    }()

    @objc dynamic public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.onSearchTextConfirmed(text: textField.text ?? "")
        return true
    }

    @objc dynamic public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return self.delegate?.onSearchTextFieldShouldEndEditing() ?? true
    }

    @objc dynamic public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

    @objc dynamic public func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.onSearchTextEndEditing()
    }

    @objc dynamic public func textFieldDidChanged(_ textField: UITextField) {
        self.delegate?.onSearchTextChanged(text: textField.text ?? "")
    }
}


// MARK: - ZMSearchTextField
public class ZMSearchTextField: UITextField {

    @objc open override dynamic var placeholder: String?{
        didSet{
            if let placeholderStr = placeholder {
                let attributeString = NSAttributedString.init(string: placeholderStr, attributes:
                                                                [NSAttributedString.Key.foregroundColor : UIColor(named:"ZLLabelColor2"),
                                                                 NSAttributedString.Key.font : UIFont.zlRegularFont(withSize: 14)] )
                attributedPlaceholder = attributeString
            }
        }
        
    }

//    @objc private lazy dynamic var leftIconView: UIView = {
//        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
//        let iconImg = UIImageView(image: UIImage(iconfont: "\u{e62e}", fontSize: 18, color: UIColor(hex:0x7f7f8e)))
//        iconImg.center = iconView.center
//        iconView.addSubview(iconImg)
//        return iconView
//    }()

//    @objc private lazy dynamic var rightClearView: UIView = {
//        let rect = CGRect(x: 0, y: 0, width: 34, height: 34)
//        let rightClearView = UIView(frame: rect)
//        let rightClearBtn = UIButton(frame: rect)
//        rightClearBtn.addTarget(self, action: #selector(rightViewAction), for: .touchUpInside)
//        rightClearBtn.setImage( UIImage(iconfont: "\u{e65f}", fontSize: 18, color: UIColor(hex:0xAAAABB)), for: .normal)
//        rightClearView.addSubview(rightClearBtn)
//        return rightClearView
//    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 5.0
        borderStyle = .none
        font = .zlRegularFont(withSize: 14)
        textColor = UIColor(named: "ZLLabelColor1")
        backgroundColor = UIColor(named: "ZLExploreTextFieldBackColor") 
        returnKeyType = .search
        // 关闭自动联想
        autocorrectionType = .no
        // 关闭自动大写
        autocapitalizationType = .none
        //attributedPlaceholder = attributeString

//        leftViewMode = .always
//        leftView = leftIconView
//
//
//        rightViewMode = .whileEditing
//        rightView = rightClearView

    }

    @objc private dynamic func rightViewAction() {
        self.text = nil
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


