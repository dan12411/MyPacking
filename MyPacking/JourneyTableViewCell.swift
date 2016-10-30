//
//  JourneyTableViewCell.swift
//  MyPacking
//
//  Created by 洪德晟 on 2016/10/29.
//  Copyright © 2016年 洪德晟. All rights reserved.
//

import UIKit

class JourneyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var journeyLabel: UILabel!

    @IBOutlet weak var ratioLabel: UILabel!
    
    @IBOutlet weak var ratioProgress: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
