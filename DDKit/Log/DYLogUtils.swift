//
//  DYLogUtils.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation

func DYLog(logString: String, function: Int = __LINE__, file: String = __FILE__){
    
    #if DEBUG
        
        let className = String.fromCString(strrchr(file, Int32(("/".cStringUsingEncoding(NSUTF8StringEncoding)?.first)!))+1)!
        print(" -[\(className) \(function)]: \(logString)")
    #endif
}