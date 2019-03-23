//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Kinjal Solanki on 23/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var vwBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwBackground.layer.cornerRadius = 10
        vwBackground.dropShadow(offset: CGSize.zero, radius: 10, color: UIColor.gray, opacity: 0.5)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
