//
//  UIColor+Addition.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation
import UIKit

func RGB(red:Int16, _ green: Int16, _ blue : Int16, alpha: CGFloat = 1.0) -> UIColor {
    
    let color = UIColor.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha);
    return color
}