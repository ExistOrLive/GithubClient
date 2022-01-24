//
//  UIView+ZLExtension.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/1/16.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import FWPopupView
import UIKit
import SVProgressHUD

extension UIView {

    /**
     *  弹出菜单
     *
     */
    func showPopMenuView(titles: [String]?,
                         images: [UIImage]?,
                         attachView: UIView,
                         callback:@escaping ((String?, Int) -> Void)) -> FWMenuView {

        let attachViewHeight = attachView.frame.height
        let attachViewWidth = attachView.frame.width

        let newFrame = self.convert(self.bounds, to: attachView)

        var popupCustomAlignment: FWPopupCustomAlignment = .center
        var popupViewEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero

        if newFrame.midY > attachViewHeight / 2 {
            // 偏底部
            if newFrame.midX > attachViewWidth / 2 {
                // 偏右
                popupCustomAlignment = .bottomRight
                popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: attachViewHeight - newFrame.midY, right: attachViewWidth - newFrame.midX)
            } else if newFrame.midX < attachViewWidth / 2 {
                // 偏左
                popupCustomAlignment = .bottomLeft
                popupViewEdgeInsets = UIEdgeInsets(top: 0, left: newFrame.midX, bottom: attachViewHeight - newFrame.midY, right: 0)
            } else {
                // 局中
                popupCustomAlignment = .bottomCenter
                popupViewEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: attachViewHeight - newFrame.midY, right: 0)
            }

        } else {
            // 偏顶部
            if newFrame.midX > attachViewWidth / 2 {
                // 偏右
                popupCustomAlignment = .topRight
                popupViewEdgeInsets = UIEdgeInsets(top: newFrame.midY, left: 0, bottom: 0, right: attachViewWidth - newFrame.midX)
            } else if newFrame.midX < attachViewWidth / 2 {
                // 偏左
                popupCustomAlignment = .topLeft
                popupViewEdgeInsets = UIEdgeInsets(top: newFrame.midY, left: newFrame.midX, bottom: 0, right: 0)
            } else {
                // 局中
                popupCustomAlignment = .topCenter
                popupViewEdgeInsets = UIEdgeInsets(top: newFrame.midY, left: 0, bottom: 0, right: 0)
            }
        }

        let vProperty = FWMenuViewProperty()

        vProperty.popupViewItemHeight = 40
        vProperty.popupCustomAlignment = popupCustomAlignment
        vProperty.popupAnimationType = .scale
        vProperty.maskViewColor = UIColor(white: 0, alpha: 0.2)
        vProperty.touchWildToHide = "1"
        vProperty.popupViewEdgeInsets = popupViewEdgeInsets
        vProperty.topBottomMargin = 0
        vProperty.animationDuration = 0.3
        vProperty.popupArrowStyle = .round
        vProperty.popupArrowVertexScaleX = 1
        vProperty.backgroundColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.splitColor = kPV_RGBA(r: 64, g: 63, b: 66, a: 1)
        vProperty.separatorColor = kPV_RGBA(r: 91, g: 91, b: 93, a: 1)
        vProperty.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.backgroundColor: UIColor.clear, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
        vProperty.textAlignment = .left
        vProperty.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        let menuView = FWMenuView.menu(itemTitles: titles, itemImageNames: images, itemBlock: { _, index, title in
            callback(title, index)
        }, property: vProperty)
        menuView.attachedView = attachView
        menuView.show()

        return menuView
    }

    /**
     *  弹出菜单
     *
     */
    func showShareMenu(title: String,
                       url: URL,
                       sourceViewController: UIViewController) {

        let alertVC = UIAlertController.init(title: title, message: nil, preferredStyle: .actionSheet)

        alertVC.popoverPresentationController?.sourceView = self

        let alertAction5 = UIAlertAction.init(title: ZLLocalizedString(string: "Copy URL", comment: ""), style: UIAlertAction.Style.default) { (_: UIAlertAction) in
            let pasteBoard = UIPasteboard.general
            pasteBoard.url = url
        }

        let alertAction1 = UIAlertAction.init(title: ZLLocalizedString(string: "View in Github", comment: ""), style: UIAlertAction.Style.default) { (_: UIAlertAction) in
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController, params: ["requestURL": url])
        }

        let alertAction2 = UIAlertAction.init(title: ZLLocalizedString(string: "Open in Safari", comment: ""), style: UIAlertAction.Style.default) { (_: UIAlertAction) in
            UIApplication.shared.open(url, options: [:], completionHandler: {(_: Bool) in})
        }

        let alertAction3 = UIAlertAction.init(title: ZLLocalizedString(string: "Share", comment: ""), style: UIAlertAction.Style.default) { [weak self] (_: UIAlertAction) in
            let activityVC = UIActivityViewController.init(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self
            activityVC.excludedActivityTypes = [.message, .mail, .openInIBooks, .markupAsPDF]
            sourceViewController.present(activityVC, animated: true, completion: nil)
        }

        let alertAction4 = UIAlertAction.init(title: ZLLocalizedString(string: "Cancel", comment: ""), style: UIAlertAction.Style.cancel, handler: nil)

        alertVC.addAction(alertAction5)
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        alertVC.addAction(alertAction4)

        sourceViewController.present(alertVC, animated: true, completion: nil)

    }
}


// MARK: SVProgressHUD

extension UIView {
    
    func showProgressHUD(style: SVProgressHUDStyle = .light,
                         maskType: SVProgressHUDMaskType = .black,
                         animationType: SVProgressHUDAnimationType = .flat) {
        SVProgressHUD.setDefaultStyle(style)
        SVProgressHUD.setDefaultMaskType(maskType)
        SVProgressHUD.setDefaultAnimationType(animationType)
        SVProgressHUD.setContainerView(self)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: -100))
        SVProgressHUD.show()
        
    }
    
    static func dismissProgressHUD() {
        SVProgressHUD.dismiss()
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setContainerView(nil)
    }
}

// MARK: Common

extension UIView {

    // 获取View的VC
    var viewController: UIViewController? {
        var currentResponder: UIResponder = self
        while let nextResponder = currentResponder.next {
            if let vc = nextResponder as? UIViewController {
                return vc
            } else {
                currentResponder = nextResponder
            }
        }
        return nil
    }
}



protocol ViewUpdatable {
    
    associatedtype ViewData
    
    func fillWithData(viewData: ViewData)
}
