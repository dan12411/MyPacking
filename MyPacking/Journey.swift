//
//  Data.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/18.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import Foundation

class Journey {
    var name: String?
    var categories: [[String:Any]]?
    
    init(name: String, categories: [[String:Any]]) {
        
        self.name = name
        self.categories = categories
    }
}
