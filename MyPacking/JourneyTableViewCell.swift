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
        // Set background color
        let view = UIView()
        view.backgroundColor = UIColor(red: 214.0/255.0, green: 244.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
