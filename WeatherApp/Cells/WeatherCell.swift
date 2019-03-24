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
    var mdlMetrics = MetricDataModel() {
        didSet {
            lblMonth.text = getMonthName(monthNumber: mdlMetrics.month!)
            lblRainfall.text = "\(mdlMetrics.rainfall!) mm"
            lblMinMax.text = "\(mdlMetrics.tmin!)° / \(mdlMetrics.tmax!)°"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwBackground.layer.cornerRadius = 10
        vwBackground.dropShadow(offset: CGSize.zero, radius: 10, color: UIColor.gray, opacity: 0.3)
    }

}
