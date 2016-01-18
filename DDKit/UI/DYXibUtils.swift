//
//  DYXibUtils.swift
//  DouyuTV
//
//  Created by lovelydd on 16/1/14.
//  Copyright © 2016年 xiaomutou. All rights reserved.
//

import Foundation
import UIKit




class DYXibUtils {
    
    static func collectionRegisterXib(name: String, resuseID: String , collectionView: UICollectionView) {
        
        collectionView.registerNib(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: resuseID)
    }
    

}

