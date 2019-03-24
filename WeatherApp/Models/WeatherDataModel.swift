//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Anam Shah on 24/03/19.
//  Copyright © 2019 Anam Shah. All rights reserved.
//

import Foundation

struct WeatherDataModel {
    let country_id: Int?
    let year: Int?
    let month: Int?
    let value: Double?
    let type: Int?
    
    
    init(country_id: Int, year: Int, month: Int, value: Double, type : Int) {
        self.country_id = country_id
        self.year = year
        self.month = month
        self.value = value
        self.type = type
    }
}
