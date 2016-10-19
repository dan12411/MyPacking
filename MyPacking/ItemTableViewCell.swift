//
//  ItemTableViewCell.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/19.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var imageButton: UIButton!
    
    // 按鈕判斷是否勾選
    var isCheck = false
    @IBAction func checkButton(_ sender: UIButton) {
        if isCheck == false {
            isCheck = true
            let checkImage = UIImage(named: "Check")
            imageButton.setImage(checkImage, for: .normal)
            itemLabel.textColor = UIColor.gray
        } else {
            isCheck = false
            let checkImage = UIImage(named: "UnCheck")
            imageButton.setImage(checkImage, for: .normal)
            itemLabel.textColor = UIColor.black
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
