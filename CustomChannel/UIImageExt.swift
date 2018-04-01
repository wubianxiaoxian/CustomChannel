//
//  UIImageExt.swift
//  GenialTone
//
//  Created by SNDA on 2017/6/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIImage {

    class func image(color: UIColor?, size: CGSize = CGSize(width: 10, height: 10)) -> UIImage? {
        guard color != nil && size.width > 0 && size.height > 0 else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color!.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func roundCorner(radius: CGFloat, corners: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) -> UIImage? {

        var aCorners = corners
        if aCorners != .allCorners {
            var tmp = 0 as UInt
            if (corners.rawValue & UIRectCorner.topLeft.rawValue) != 0 {
                tmp |= UIRectCorner.bottomLeft.rawValue
            }
            if (corners.rawValue & UIRectCorner.topRight.rawValue) != 0 {
                tmp |= UIRectCorner.bottomRight.rawValue
            }
            if (corners.rawValue & UIRectCorner.bottomLeft.rawValue) != 0 {
                tmp |= UIRectCorner.topLeft.rawValue
            }
            if (corners.rawValue & UIRectCorner.bottomRight.rawValue) != 0 {
                tmp |= UIRectCorner.topRight.rawValue
            }
            aCorners = UIRectCorner(rawValue: tmp)
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -rect.size.height)

        let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: aCorners, cornerRadii: CGSize(width: radius, height: 0))
        path.close()
        context?.saveGState()
        path.addClip()
        context?.draw(cgImage!, in: rect)
        context?.restoreGState()

        if borderColor != nil && borderWidth > 0 {
            let strokeRect = rect.insetBy(dx: borderWidth/2, dy: borderWidth/2)
            let strokeRadius = radius - borderWidth/2
            let path = UIBezierPath.init(roundedRect: strokeRect, byRoundingCorners: aCorners, cornerRadii: CGSize(width: strokeRadius, height: 0))

            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = .round
            borderColor?.setStroke()
            path.stroke()
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func cgRectFit(rect: CGRect, size: CGSize, contentMode: UIViewContentMode) -> CGRect {
        var rect = rect.standardized
        var size = size
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPoint(x: rect.midX, y: rect.midY)
        switch contentMode {
        case .scaleAspectFit, .scaleAspectFill:
            if (rect.size.width < 0.01 || rect.size.height < 0.01 || size.width < 0.01 || size.height < 0.01) {
                rect.origin = center
                rect.size = CGSize.zero
            } else {
                var scale: CGFloat
                if (contentMode == .scaleAspectFit) {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.height / size.height
                    } else {
                        scale = rect.size.width / size.width
                    }
                } else {
                    if (size.width / size.height < rect.size.width / rect.size.height) {
                        scale = rect.size.width / size.width
                    } else {
                        scale = rect.size.height / size.height
                    }
                }
                size.width *= scale
                size.height *= scale
                rect.size = size
                rect.origin = CGPoint(x:center.x - size.width * 0.5, y:center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size
            rect.origin = CGPoint(x:center.x - size.width * 0.5, y:center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default:
            rect = CGRect(origin: rect.origin, size: rect.size)
        }
        return rect
    }

    func draw(in rect: CGRect, contentMode: UIViewContentMode, clipsToBounds clips: Bool) {
        let drawRect = cgRectFit(rect: rect, size: size, contentMode: contentMode)
        guard drawRect.size.width != 0 && drawRect.size.height != 0 else {
            return
        }
        if clips {
            let context = UIGraphicsGetCurrentContext()
            if context != nil {
                context?.saveGState()
                context?.addRect(rect)
                context?.clip()
                draw(in: drawRect)
                context?.restoreGState()
            }
        } else {
            draw(in: drawRect)
        }
    }

    func resize(toSize size: CGSize) -> UIImage? {
        guard size.width > 0 && size.height > 0  else {
            return UIImage()
        }
        let scale = max(self.scale, UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func resize(toSize size: CGSize, contentMode: UIViewContentMode) -> UIImage? {
        guard size.width > 0 && size.height > 0  else {
            return UIImage()
        }
        let scale = max(self.scale, UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: CGPoint.zero, size: size), contentMode: contentMode, clipsToBounds: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /**
     * 返回当前图片设置alpha后的新图片
     * @param alpha 制定alpha值
     * @return 当前图片设置alpha后的新图片
     */
    func imageWithAlpha(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let ctxOpt = UIGraphicsGetCurrentContext()
        guard let ctx = ctxOpt else {
            return UIImage()
        }
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -area.size.height)
        ctx.setBlendMode(.multiply)
        ctx.setAlpha(alpha)
        ctx.draw(self.cgImage!, in: area)
        let newImageOpt = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = newImageOpt else {
            return UIImage()
        }
        return newImage
    }
}
