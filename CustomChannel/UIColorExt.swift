//
//  UIColorExt.swift
//  GenialTone
//
//  Created by SNDA on 2017/6/21.
//  Copyright © 2017年 SNDA. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt, alpha: CGFloat = 1) {
        self.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgb & 0x0000FF) / 255.0, alpha: alpha)
    }
}
