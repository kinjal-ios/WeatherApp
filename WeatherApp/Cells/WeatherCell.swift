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
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblMinMax: UILabel!
    @IBOutlet weak var lblRainfall: UILabel!
    var mdlRainFall = RainFallModel(){
        didSet{
            lblMonth.text = "\(mdlRainFall.month!)"
            lblRainfall.text = "\(mdlRainFall.value!)"
        }
    }
    var mdlTMin = TempratureMinModel(){
        didSet{
            lblMinMax.text = "\(mdlTMin.value!)"
        }
    }

    var mdlTMax = TempratureMaxModel(){
        didSet{
            lblMinMax.text = lblMinMax.text! + "/\(mdlTMax.value!)" 
        }
    }

    
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
