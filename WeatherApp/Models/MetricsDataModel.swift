//
//  AllMetricDataModel.swift
//  WeatherApp
//
//  Created by Kinjal Solanki on 24/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import Foundation

struct MetricDataModel {
    
    var month: Int?
    var rainfall: Double?
    var tmin: Double?
    var tmax: Double?

    init() {}
    
    init(month: Int, rainfall: Double, tmin: Double, tmax: Double) {
        self.month = month
        self.rainfall = rainfall 
        self.tmin = tmin
        self.tmax = tmax
    }
}
