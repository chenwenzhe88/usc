//
//  UIColorFromRGB.swift
//  WebRegistration
//
//  Created by Guocheng Xie on 2/19/15.
//  Copyright (c) 2015 Guocheng Xie. All rights reserved.
//

import Foundation
import SpriteKit

extension UIColor {
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}