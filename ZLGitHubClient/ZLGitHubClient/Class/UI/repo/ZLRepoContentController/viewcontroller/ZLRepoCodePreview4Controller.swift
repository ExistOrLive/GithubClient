//
//  ZLRepoCodePreview4Controller.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZLUIUtilities
import ZLBaseExtension
import ZLGitRemoteService
import ZLUtilities
import ZMMVVM

/**
  *  利用 REST API 获取 md 内容 ； 代码使用markdown接口渲染
 */

class ZLRepoCodePreview4Controller: ZMViewController {

    // model
    let contentModel: ZLGithubContentModel
    let repoFullName: String
    let branch: String

    var htmlStr: String?
    var rawContent: String?
    
    var theme: String = "vs"
   

    init(repoFullName: String, contentModel: ZLGithubContentModel, branch: String) {
        self.repoFullName = repoFullName
        self.contentModel = contentModel
        self.branch = branch
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLUserInterfaceStyleChange_Notification, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestRawFileContent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if ZLDeviceInfo.isIPhone() {
            guard let appdelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.allowRotation = false
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {

        super.viewWillTransition(to: size, with: coordinator)

        if ZLDeviceInfo.isIPhone() {
            guard let navigationVC: ZMNavigationController = self.navigationController as? ZMNavigationController else {
                return
            }
            if size.height > size.width {
                // 横屏变竖屏
                self.isZmNavigationBarHidden = false
                navigationVC.forbidGestureBack = false
            } else {
                self.isZmNavigationBarHidden = true
                navigationVC.forbidGestureBack = true
            }
        }
    }

    override func setupUI() {
        super.setupUI()
        self.title = self.contentModel.path

        self.zmNavigationBar.backButton.isHidden = false
        self.zmNavigationBar.addRightView(moreButton)

        self.contentView.addSubview(webView)
        webView.snp.makeConstraints({(make) in
            make.edges.equalToSuperview()
        })
        
        self.contentView.addSubview(switchButton)
        
        switchButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
    }

    // view
    lazy var webView: WKWebView = {
        let wv = WKWebView(frame: CGRect.init())
        wv.backgroundColor = UIColor.clear
        wv.scrollView.backgroundColor = UIColor.clear
        wv.scrollView.bounces = false
        wv.uiDelegate = self
        wv.navigationDelegate = self
        return wv
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setAttributedTitle(NSAttributedString(string: ZLIconFont.More.rawValue,
                                                     attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                  .foregroundColor: UIColor.label(withName: "ICON_Common")]),
                                  for: .normal)
        button.snp.makeConstraints({ make in
            make.size.equalTo(60)
        })
        button.addTarget(self, action: #selector(onMoreButtonClick(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy var switchButton: UIButton = {
        let button = ZMButton()
        button.setTitle("切换主题", for: .normal)
        button.addTarget(self, action: #selector(onSwitchButtonClick(button:)), for: .touchUpInside)
        return button
    }()
}

extension ZLRepoCodePreview4Controller {
    
    static func getThemeSelectView() -> ZMSingleSelectTitlePopView {
        /// 开发语言选择
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        let title = "主题"
        dateRangeSelectView.titleLabel.text = title
        let placeHolder = "筛选主题"
            .asMutableAttributedString()
            .font(.zlRegularFont(withSize: 12))
            .foregroundColor(ZLRGBValue_H(colorValue: 0xCED1D6))
        dateRangeSelectView.textField.attributedPlaceholder = placeHolder
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 500
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = ZMLanguageSelectView.popDelegate
        return dateRangeSelectView
    }
    
    /// 弹出开发语言选择框
    static func showThemeSelectView(to: UIView,
                                    theme: String?,
                                    resultBlock : @escaping ((String?) -> Void)) {
    
            
            let themes = [
                "1c-light",
                "a11y-dark",
                "a11y-light",
                "agate",
                "an-old-hope",
                "androidstudio",
                "arduino-light",
                "arta",
                "ascetic",
                "atom-one-dark-reasonable",
                "atom-one-dark",
                "atom-one-light",
                "brown-paper",
                "codepen-embed",
                "color-brewer",
                "cybertopia-cherry",
                "cybertopia-dimmer",
                "cybertopia-icecap",
                "cybertopia-saturated",
                "dark",
                "default",
                "devibeans",
                "docco",
                "far",
                "felipec",
                "foundation",
                "github-dark-dimmed",
                "github-dark",
                "github",
                "gml",
                "googlecode",
                "gradient-dark",
                "gradient-light",
                "grayscale",
                "hybrid",
                "idea",
                "intellij-light",
                "ir-black",
                "isbl-editor-dark",
                "isbl-editor-light",
                "kimbie-dark",
                "kimbie-light",
                "lightfair",
                "lioshi",
                "magula",
                "mono-blue",
                "monokai-sublime",
                "monokai",
                "night-owl",
                "nnfx-dark",
                "nnfx-light",
                "nord",
                "obsidian",
                "panda-syntax-dark",
                "panda-syntax-light",
                "paraiso-dark",
                "paraiso-light",
                "pojoaque",
                "purebasic",
                "qtcreator-dark",
                "qtcreator-light",
                "rainbow",
                "rose-pine-dawn",
                "rose-pine-moon",
                "rose-pine",
                "routeros",
                "school-book",
                "shades-of-purple",
                "srcery",
                "stackoverflow-dark",
                "stackoverflow-light",
                "sunburst",
                "tokyo-night-dark",
                "tokyo-night-light",
                "tomorrow-night-blue",
                "tomorrow-night-bright",
                "vs",
                "vs2015",
                "xcode",
                "xt256"
            ]
            var selectedIndex = themes.firstIndex(of: theme ?? "") ?? 0
            
            
        Self.getThemeSelectView()
                .showSingleSelectTitleBox(to,
                                          contentPoition: .center,
                                          animationDuration: 0.1,
                                          titles: themes,
                                          selectedIndex: selectedIndex,
                                          cellType: ZMDevelopmentLanguageSelectTickCell.self)
            { index, title in
                resultBlock(title)
            }
            
    }

}

// MARK: - Action
extension ZLRepoCodePreview4Controller {

    @objc func onMoreButtonClick(button: UIButton) {

        guard let url = URL(string: self.contentModel.html_url) else {
            return
        }
        button.showShareMenu(title: url.absoluteString, url: url, sourceViewController: self )
    }
    
    @objc func onSwitchButtonClick(button: UIButton) {
        Self.showThemeSelectView(to: self.view, theme: self.theme) { [weak self] theme in
            guard let self else { return }
            self.theme = theme ?? ""
            self.generateHTML(rawContent: self.rawContent ?? "")
            self.startLoadCode()
            
        }
    }
}

// MARK: - Request
extension ZLRepoCodePreview4Controller {

    func generateHTML(rawContent: String) {
        let htmlURL: URL? = Bundle.main.url(forResource: "highlight", withExtension: "html")

        if let url = htmlURL {

            do {
                let htmlStr = try String.init(contentsOf: url)
                let newHtmlStr = NSMutableString.init(string: htmlStr)

                let headRange = (newHtmlStr as NSString).range(of: "</head>")
                if  headRange.location != NSNotFound {
                    newHtmlStr.insert("<link rel=\"stylesheet\" href=\"./\(self.theme).min.css\">", at: headRange.location)
                }

                let codeRange = (newHtmlStr as NSString).range(of: "</code>")
                if  codeRange.location != NSNotFound {
                    newHtmlStr.insert(rawContent.htmlEscaped(), at: codeRange.location)
                }
                
                self.htmlStr = newHtmlStr as String

            } catch {
                ZLToastView.showMessage("load Code index html failed")
            }
        }
    }
    
    func startLoadCode() {
        webView.loadHTMLString(self.htmlStr ?? "", baseURL: Bundle.main.bundleURL)
    }
}

// MARK: - Request
extension ZLRepoCodePreview4Controller {
    func requestRawFileContent() {

        self.view.showProgressHUD()
        ZLRepoServiceShared()?.getRepositoryFileRawInfo(withFullName: self.repoFullName,
                                                        path: self.contentModel.path,
                                                        branch: self.branch,
                                                        serialNumber: NSString.generateSerialNumber())
        {[weak self] (resultModel: ZLOperationResultModel) in
            
            guard let self = self else { return }
            self.view.dismissProgressHUD()
            
            if resultModel.result,
               let data: String = resultModel.data as? String {
                self.rawContent = data
                self.generateHTML(rawContent: data)
                self.startLoadCode()
            } else {
                if let errorModel = resultModel.data as? ZLGithubRequestErrorModel {
                    ZLToastView.showMessage(errorModel.message)
                }
            }
        }
    }
}

extension ZLRepoCodePreview4Controller: WKUIDelegate, WKNavigationDelegate {
  
}


extension String {
    func htmlEscaped() -> String {
        return self
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
