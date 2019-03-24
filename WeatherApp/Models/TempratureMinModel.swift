//
//  TempratureMinModel.swift
//  WeatherApp
//
//  Created by Anam Shah on 24/03/19.
//  Copyright © 2019 Anam Shah. All rights reserved.
//

import Foundation

struct TempratureMinModel {
    
    var value: Double?
    var year: Int?
    var month: Int?
    
    init() {
        
    }
    
    init(value : Double, year : Int, month : Int) {
        self.value = value
        self.month = month
        self.value = value
    }
}
