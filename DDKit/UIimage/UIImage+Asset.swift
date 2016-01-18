//
//  UIImage+Asset.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum Asset : String {
        case Btn_search = "btn_search"
        case Btn_search_clicked = "btn_search_clicked"
        case Image_scan = "Image_scan"
        case Image_scan_click = "Image_scan_click"
        case Logo = "logo"
        case S_logo = "s_logo"
        case Btn_column_normal = "btn_column_normal"
        case Btn_column_selected = "btn_column_selected"
        case Btn_home_normal = "btn_home_normal"
        case Btn_home_selected = "btn_home_selected"
        case Btn_live_normal = "btn_live_normal"
        case Btn_live_selected = "btn_live_selected"
        case Btn_user_normal = "btn_user_normal"
        case Btn_user_selected = "btn_user_selected"
        
        var image: UIImage {
            return UIImage(asset: self)
        }
    }
    convenience init!(asset: Asset) {
        self.init(named: asset.rawValue)
    }
}