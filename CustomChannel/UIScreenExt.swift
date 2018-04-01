//
//  UIScreenExt.swift
//  GenialTone
//
//  Created by SNDA on 2017/6/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import Foundation
import UIKit

private struct AppScreenSize {
    static var screenWidth: CGFloat = 0
    static var screenHeight: CGFloat = 0
}

extension UIScreen {
    static func appHeight() -> CGFloat {
        if AppScreenSize.screenHeight > 0 {
            return AppScreenSize.screenHeight
        }

        AppScreenSize.screenHeight = max(main.bounds.width, main.bounds.height)
        return AppScreenSize.screenHeight
    }

    static func appWidth() -> CGFloat {
        if AppScreenSize.screenWidth > 0 {
            return AppScreenSize.screenWidth
        }

        AppScreenSize.screenWidth = min(main.bounds.width, main.bounds.height)
        return AppScreenSize.screenWidth
    }
}
