//
//  UIImageView+Request.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    
    func setImageWithURL(urlstring : NSString) {
        
        return self.setImageWithURL(urlstring, placeholder: nil)
    }
    
    func setImageWithURL(urlString : NSString?, placeholder: UIImage? = UIImage(named: "Img_default")){
    
        if let str = urlString as? String{
            let url:NSURL? = NSURL(string: str)
            self.kf_setImageWithURL(url!, placeholderImage: placeholder)
        }else{
            let url:NSURL? = NSURL(string: "")
            self.kf_setImageWithURL(url!, placeholderImage: placeholder)
        }
    }
    
}