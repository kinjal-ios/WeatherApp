//
//  TempratureMaxModel.swift
//  WeatherApp
//
//  Created by Kinjal Solanki on 24/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import Foundation

struct  TempratureMaxModel {
    
    var value: Double?
    var year: Int?
    var month: Int?
    
    init() {}
    
    init(value : Double, year : Int, month : Int) {
        self.value = value
        self.month = month
        self.year = year
    }
    
}
