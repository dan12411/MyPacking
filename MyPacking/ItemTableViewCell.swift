//
//  ItemTableViewCell.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/19.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemCount: UITextField!
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
