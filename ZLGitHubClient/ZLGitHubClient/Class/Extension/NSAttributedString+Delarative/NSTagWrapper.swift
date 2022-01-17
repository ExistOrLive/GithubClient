//
//  NSTagWrapper.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/11/21.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import CoreGraphics

public class NSTagWrapper: NSObject {

    var attributedString: NSAttributedString

    // 圆角
    var cornerRadius: CGFloat = 0
    var corner: UIRectCorner = .allCorners

    // border
    var borderColor: UIColor = UIColor.clear
    var borderWidth: CGFloat = 0

    //
    var backgroundColor: UIColor = UIColor.clear
    var backgroundImage: UIImage?

    // 内
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero

    init(attributedString: NSAttributedString) {
        self.attributedString = attributedString
        super.init()
    }

    convenience init(text: String) {
        let attributedString = NSAttributedString(string: text,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.black])
        self.init(attributedString: attributedString)
    }

    convenience override init() {
        self.init(attributedString: NSAttributedString())
    }

    func asImage() -> UIImage? {

        let textSize = attributedString.boundingRect(with: CGSize(width: 10000, height: 10000),
                                                     options: .usesLineFragmentOrigin,
                                                     context: nil)

        let textContainerSize = CGSize(width: round(textSize.width) + edgeInsets.right + edgeInsets.left + 1,
                                       height: round(textSize.height) + edgeInsets.top + edgeInsets.bottom + 1)
        let imageSize = CGSize(width: textContainerSize.width + 2 * borderWidth,
                               height: textContainerSize.height + 2 * borderWidth)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        //
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: borderWidth, y: borderWidth),
                                                    size: textContainerSize),
                                byRoundingCorners: corner,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        if borderWidth != 0 {
            context?.setStrokeColor(borderColor.cgColor)
            context?.setLineWidth(borderWidth)
            path.stroke()
        }

        path.addClip()

        // 背景色
        context?.setFillColor(backgroundColor.cgColor)
        path.fill()

        // 背景图
        if let backgroundImage = backgroundImage {
            backgroundImage.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        }

        // 文字
        attributedString.draw(in: CGRect(x: edgeInsets.left + borderWidth,
                                         y: edgeInsets.top + borderWidth,
                                         width: round(textSize.width) + 1,
                                         height: round(textSize.height) + 1 ))

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        if let cgImage = image?.cgImage {
            return UIImage(cgImage: cgImage,
                           scale: UIScreen.main.scale,
                           orientation: .up)
        } else {
            return nil
        }
    }
}

extension NSTagWrapper {

    func text(_ text: String) -> NSTagWrapper {
        let attributedString = NSAttributedString(string: text,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                               .foregroundColor: UIColor.black])
        self.attributedString = attributedString
        return self
    }

    func attributedString(_ attributedString: NSAttributedString) -> NSTagWrapper {
        self.attributedString = attributedString
        return self
    }

    func cornerRadius(_ cornerRadius: CGFloat) -> NSTagWrapper {
        self.cornerRadius = cornerRadius
        return self
    }

    func corner(_ corner: UIRectCorner) -> NSTagWrapper {
        self.corner = corner
        return self
    }

    func borderColor(_ color: UIColor) -> NSTagWrapper {
        self.borderColor = color
        return self
    }

    func borderWidth(_ borderWidth: CGFloat) -> NSTagWrapper {
        self.borderWidth = borderWidth
        return self
    }

    func backgroundColor(_ backgroundColor: UIColor) -> NSTagWrapper {
        self.backgroundColor = backgroundColor
        return self
    }

    func backgroundImage(_ backgroundImage: UIImage) -> NSTagWrapper {
        self.backgroundImage = backgroundImage
        return self
    }

    func edgeInsets(_ edgeInsets: UIEdgeInsets) -> NSTagWrapper {
        self.edgeInsets = edgeInsets
        return self
    }
}
