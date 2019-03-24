//
//  DBManager.swift
//
//  Created by Kinjal Solanki on 23/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    
    static let shared: DBManager = DBManager()
    
    let KDBName = "weather.sqlite"
    let dbPath: String!
    var database: FMDatabase!
    
    override init() {
        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        dbPath = documentDirectory.appending("/\(KDBName)")
    }
    
    func getCurrentDBSchemaVersion() -> Int {
        let result = database.executeQuery("PRAGMA user_version", withParameterDictionary: nil)
        var version = 0
        if result!.next() {
            version = Int(result!.int(forColumnIndex: 0))
        }
        
        return version
    }
    
    //copy Db to Device
    func copyDBToUserDevice() {
        if !FileManager.default.fileExists(atPath: self.dbPath) {
            let bundlePath = Bundle.main.path(forResource: "weather", ofType:".sqlite")
            do {
                try FileManager.default.copyItem(at: URL(fileURLWithPath: bundlePath!), to: URL(fileURLWithPath: dbPath))
            } catch {
                print(error)
            }
        }
    }
    
    //Open DB connection
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: dbPath) {
                database = FMDatabase(path: dbPath)
            }
        }
        
        if database != nil {
            if database.open() {
                return true
            }
        }
        
        return false
    }
    
    func executeStatement(query: String) -> Bool {
        var isExecute: Bool!
        if self.openDatabase() {
            isExecute = database.executeStatements(query)
            database.close()
        } else {
            isExecute = false
        }
        
        return isExecute
    }
    
    //Get all countries
    func getCountryDetail() -> (Bool, [String]) {
        
        var arrCountries: [String] = []
        if arrCountries.count > 0 {
            arrCountries.removeAll()
        }
        if self.openDatabase() {
            do {
                let result = try database.executeQuery(
                    "SELECT * FROM Country Order by id ASC",
                    values: nil
                )
                while result.next() {
                    arrCountries.append(result.string(forColumn:"name")!)
                }
                database.close()
                return(true,arrCountries)
                
            } catch {
                database.close()
                return(false,arrCountries)
            }
            
        } else {
            return(false,arrCountries)
        }
    }
    
    //Get country name
    func getCountryWithId(id: Int) -> (String) {
        
        var countryname: String = String()
       
        if self.openDatabase() {
            do {
                let result = try database.executeQuery(
                    "SELECT * FROM Country where id = \(id)",
                    values: nil
                )
                while result.next() {
                    countryname = result.string(forColumn:"name")!
                }
                database.close()
                return(countryname)
                
            }catch{
                database.close()
                return(countryname)
            }
        }else{
            return(countryname)
        }
    }
    
    //Get Country Id
    func getCountryId(name: String) -> (Int) {
        
        var countryId : Int = Int()
        
        if self.openDatabase(){
            do{
                let result = try database.executeQuery("SELECT * FROM Country where name = '\(name)'", values: nil)
                while result.next(){
                    countryId = Int(result.int(forColumn:"id"))
                }
                database.close()
                return(countryId)

            }catch{
                database.close()
                return(countryId)
            }
        }else{
            return(countryId)
        }
    }
    
    //Get all the years
    func getYearsDetail() -> (Bool, [Int]){
        
        var arrYears: [Int] = []
        if arrYears.count > 0{
            arrYears.removeAll()
        }
        if self.openDatabase(){
            do{
                let result = try database.executeQuery("SELECT * FROM Weather_data", values: nil)
                while result.next(){
                    arrYears.append(Int(result.int(forColumn:"year")))
                }
                database.close()
                return(true,arrYears)
                
            }catch{
                database.close()
                return(false,arrYears)
            }
        }else{
            return(false,arrYears)
        }
        
    }
    
    //Get all metrics data to display
    func getWeatherDataMetric(countryId: Int, year: Int) -> (Bool, [MetricDataModel]) {
        
        var arrWeatherMdl : [MetricDataModel] = []
        if self.openDatabase(){
            do{
                let result = try database.executeQuery("SELECT t1. month, t1.rainfall, t2.tmin, t3.tmax FROM (SELECT month, value AS rainfall FROM Weather_data WHERE type = 1 AND year = \(year) AND country_id = \(countryId)) t1,(SELECT month, value as tmin FROM Weather_data WHERE type = 2 AND year = \(year) AND country_id = \(countryId)) t2,(SELECT month, value as tmax FROM Weather_data WHERE type = 3 AND year = \(year) AND country_id = \(countryId)) t3 WHERE t1.month = t2.month AND t1.month = t3.month GROUP BY t1.month", values: nil)
           
                while result.next() {
                    let weatherMdl = MetricDataModel.init(month: Int(result.int(forColumn: "month")), rainfall: Double(result.double(forColumn: "rainfall")), tmin: Double(result.double(forColumn: "tmin")), tmax: Double(result.double(forColumn: "tmax")))
                    arrWeatherMdl.append(weatherMdl)
                    
                }
                database.close()
                return(true,arrWeatherMdl)
                
            } catch {
                database.close()
                return(false,arrWeatherMdl)
            }
        }else{
            return(false,arrWeatherMdl)
        }
        
    }
   
    //Insert the data in DB
    func insertDataIntoDB(arrReponse: [ResponseModel], countryId: Int, type: Int){
        if DBManager.shared.openDatabase() {
            for dict in arrReponse{
                let insertQry = "insert into Weather_data (country_id, value,month,year,type) values (\(countryId),\(dict.value!),\(dict.month!),\(dict.year!),\(type))"
                let _ = DBManager.shared.executeStatement(query: insertQry)
            }
        }
    }
    
}
