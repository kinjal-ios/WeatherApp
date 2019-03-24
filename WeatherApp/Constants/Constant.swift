//
//  Constant.swift
//  WeatherApp
//
//  Created by Kinjal Solanki on 22/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import UIKit

//BASEURL
let BASEURL = "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice"

//FIELD TITLES
let LOCATION_TITLE = "select location"
let YEAR_TITLE = "select year"

//WEATHER CELL
let WEATHERCELL = "WeatherCell"

class Constant: NSObject {

    //GRADIENT VIEW COLORS
    struct GradientColors {
        
        static let topColor =  UIColor.white.cgColor//UIColor(red: 58.0/255.0, green: 90.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor
        static let bottomColor = UIColor(red: 45.0/255.0, green: 67.0/255.0, blue: 102.0/255.0, alpha: 1.0).cgColor
        
    }
    
    
}
public enum WeatherCategory : String {
    
    static let allValues = [rainfall_England, minimumtemp_England, maximumtemp_England,rainfall_UK,minimumtemp_UK,maximumtemp_UK,rainfall_Scotland,minimumtemp_Scotland,maximumtemp_Scotland,rainfall_Wales,minimumtemp_Wales,maximumtemp_Wales]
    
    case rainfall_England = "/Rainfall-England.json"
    case minimumtemp_England = "/Tmin-England.json"
    case maximumtemp_England = "/Tmax-England.json"
    
    case rainfall_UK = "/Rainfall-UK.json"
    case minimumtemp_UK = "/Tmin-UK.json"
    case maximumtemp_UK = "/Tmax-UK.json"
    
    case rainfall_Scotland = "/Rainfall-Scotland.json"
    case minimumtemp_Scotland = "/Tmin-Scotland.json"
    case maximumtemp_Scotland = "/Tmax-Scotland.json"
    
    case rainfall_Wales = "/Rainfall-Wales.json"
    case minimumtemp_Wales = "/Tmin-Wales.json"
    case maximumtemp_Wales = "/Tmax-Wales.json"
}

public enum Countries : Int {
    case UK = 1
    case Scotland = 2
    case Wales = 3
    case England = 4
}

//GET COUNTRY ID, CATEGORY
public func getCountryDetails(countryInfo : String) -> (Int,Int) {
    
    switch countryInfo
    {
        case WeatherCategory.rainfall_England.rawValue:
            return (4,1)
        case WeatherCategory.minimumtemp_England.rawValue:
            return (4,2)
        case WeatherCategory.maximumtemp_England.rawValue:
            return (4,3)
        case WeatherCategory.rainfall_Scotland.rawValue:
            return (2,1)
        case WeatherCategory.minimumtemp_Scotland.rawValue:
            return (2,2)
        case WeatherCategory.maximumtemp_Scotland.rawValue:
            return (2,3)
        case WeatherCategory.rainfall_UK.rawValue:
            return (1,1)
        case WeatherCategory.minimumtemp_UK.rawValue:
            return (1,2)
        case WeatherCategory.maximumtemp_UK.rawValue:
            return (1,3)
        case WeatherCategory.rainfall_Wales.rawValue:
            return (3,1)
        case WeatherCategory.minimumtemp_Wales.rawValue:
            return (3,2)
        case WeatherCategory.maximumtemp_Wales.rawValue:
            return (3,3)
        
        default:
            return (0,0)
    }
    
}
