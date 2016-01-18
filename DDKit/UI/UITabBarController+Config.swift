//
//  UITabBarController+Config.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation
import UIKit


extension UITabBarController {
    
    func defaultConfig() {
        
        self.tabBar.backgroundImage = UIImage.imageWithColor(UIColor.whiteColor())
        self.tabBar.translucent = false
        
        let item = UITabBarItem.appearance()
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: .Normal)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: RGB(240, 110, 48)], forState: .Selected)
    }
    
    func setUpViewControllers() {
        
        let titles = ["推荐", "栏目", "直播", "我的"]
        let images = ["btn_home","btn_column","btn_live","btn_user"];
        for var i = 0 ; i < titles.count; i++ {
            
            if let item = self.tabBar.items?[i]{
                
                
                let normalImage = UIImage(named: images[i] + "_normal")?.imageWithRenderingMode(.AlwaysOriginal)
                let selectImage = UIImage(named: images[i] + "_selected")?.imageWithRenderingMode(.AlwaysOriginal)
                
                item.image = normalImage
                item.selectedImage = selectImage
                item.title = titles[i]
            }
            
        }
        
    }
}