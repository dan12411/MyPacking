//
//  Data.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/18.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import Foundation

class Journey: NSObject, NSCoding, NSCopying {
    var name: String?
    var categories = [
        ["cateName": "",
         "items" :
            [["itemName" : "",
             "isPack" : false,
             "number" : 0 ]]
        ]
    ]
    
    init(name: String, categories: [[String:Any]]) {
        
        self.name = name
        self.categories = categories
    }
    
    //MARK: - NSCoding -
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        categories = aDecoder.decodeObject(forKey: "categories") as! [[String:Any]]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(categories, forKey: "categories")
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Journey(name: name!, categories: categories)
        return copy
    }
}

