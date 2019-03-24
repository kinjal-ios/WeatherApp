//
//  DBManager.swift
//
//  Created by Kinjal Solanki on 23/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import UIKit

class DBManager: NSObject {
    
    static let shared : DBManager = DBManager()
    
    let KDBName = "weather.sqlite"
    
    let dbPath : String!
    
    var database: FMDatabase!
    
    override init() {
        
        let documentDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        
        dbPath = documentDirectory.appending("/\(KDBName)")
        print(dbPath)
    }
    
    func getCurrentDBSchemaVersion() -> Int{
        let result = database.executeQuery("PRAGMA user_version", withParameterDictionary: nil)
        
        var version = 0
        
        if result!.next(){
            version = Int(result!.int(forColumnIndex: 0))
        }
        
        return version
        
    }
    
    func setDBSchemaVersion(version : Int){
        
        //TODO :- Database migration.
        
    }
    
    func copyDBToUserDevice(){
        
        if !FileManager.default.fileExists(atPath: self.dbPath){
            
            let bundlePath = Bundle.main.path(forResource: "weather", ofType:".sqlite")
            
            do {
                try FileManager.default.copyItem(at: URL(fileURLWithPath: bundlePath!), to: URL(fileURLWithPath: dbPath))
            }catch{
                print(error)
            }
        }
        
    }
    
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
    
    func executeStatement(query : String) -> Bool{
        
        var isExecute : Bool!
        
        if self.openDatabase(){
            isExecute = database.executeStatements(query)
            
            database.close()
        }else{
            isExecute = false
        }
        
        return isExecute
    }
    
    func deleteStatement(query : String,id : Int?) -> Bool{
        
        var deleted = false
        
        if self.openDatabase(){
            do {
                try database.executeUpdate(query, values: id != nil ? [id!] : nil)
                deleted = true
            }catch{
                print(error.localizedDescription)
            }
            
            database.close()
        }
        
        return deleted
        
    }
    
    func getCountryDetail() -> (Bool,[String]){
        
        var arrCountries : [String] = []
        
        if arrCountries.count > 0{
            arrCountries.removeAll()
        }
        
        if self.openDatabase(){
            
            do{
                
                let result = try database.executeQuery("SELECT * FROM Country Order by id ASC", values: nil)
                
                while result.next(){
                    
                    arrCountries.append(result.string(forColumn:"name")!)
                    
                }
                
                database.close()
                return(true,arrCountries)
                
            }catch{
                
                database.close()
                return(false,arrCountries)
                
            }
            
        }else{
            return(false,arrCountries)
        }
        
    }
    func getCountryWithId(id : Int) -> (String){
        
        var countryname : String = String()
        
        if self.openDatabase(){
            
            do{
                
                let result = try database.executeQuery("SELECT * FROM Country where id = \(id)", values: nil)
                
                while result.next(){
                    
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
    func getCountryId(name : String) -> (Int){
        
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
    
    func getYearsDetail() -> (Bool,[Int]){
        
        var arrYears : [Int] = []
        
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
   
    func getWeatherData(countryId:Int,year:Int) ->(Bool,[RainFallModel],[TempratureMinModel],[TempratureMaxModel]){
        
        var arrWeatherMdl : [WeatherDataModel] = []
        var arrRainfallMdl : [RainFallModel] = []
        var arrTMinMdl : [TempratureMinModel] = []
        var arrTMaxMdl : [TempratureMaxModel] = []

        if self.openDatabase(){
            
            do{
                let result = try database.executeQuery("SELECT * FROM Weather_data WHERE country_id = \(countryId) and year = \(year)", values: nil)
                while result.next() {
                    
                    let weatherMdl = WeatherDataModel.init(country_id: Int(result.int(forColumn: "country_id")), year: Int(result.int(forColumn: "year")), month: Int(result.int(forColumn: "month")), value: Double(result.double(forColumn: "value")), type: Int(result.int(forColumn: "type")))
                  
                    arrWeatherMdl.append(weatherMdl)
                    
                }
                for dict in arrWeatherMdl{
                    if dict.type! == 1 {
                        let mdlRain : RainFallModel = RainFallModel.init(value: dict.value!, year: dict.year!, month: dict.month!)
                        arrRainfallMdl.append(mdlRain)
                    } else if dict.type! == 2 {
                        let mdlTMin = TempratureMinModel.init(
                            value: dict.value!,
                            year: dict.year!,
                            month: dict.month!
                        )
                        arrTMinMdl.append(mdlTMin)
                    } else {
                        let mdlTMax = TempratureMaxModel.init(value: dict.value!, year: dict.year!, month: dict.month!)
                        arrTMaxMdl.append(mdlTMax)
                    }
                }
                
                database.close()
                return(true,arrRainfallMdl,arrTMinMdl,arrTMaxMdl)
                
            }catch{
                database.close()
                return(false,arrRainfallMdl,arrTMinMdl,arrTMaxMdl)
            }
            
        }else{
            return(false,arrRainfallMdl,arrTMinMdl,arrTMaxMdl)
        }
    }
    
    func insertDataIntoDB(arrReponse : [ResponseModel],countryId : Int,type : Int){
        
        if DBManager.shared.openDatabase(){
            for dict in arrReponse{
                let insertQry = "insert into Weather_data (country_id, value,month,year,type) values (\(countryId),\(dict.value!),\(dict.month!),\(dict.year!),\(type))"
                let _ = DBManager.shared.executeStatement(query: insertQry)
            }
        }
        
    }
    
/*    func getAddressDetail() -> (Bool,[AddressMDL]){
        
        var arrAddress : [AddressMDL] = []
        
        if self.openDatabase(){
            
            do{
                let result = try database.executeQuery("select * from AddressDetail", values: nil)
                
                while result.next(){
                    
                    let mdlAddress = AddressMDL(addId: Int(result.int(forColumn: "id")), landMark: result.string(forColumn: kAddressDetailLandMark), city: result.string(forColumn: kAddressDetailCity), state: result.string(forColumn: kAddressDetailState), zipcode: result.string(forColumn: kAddressDetailZipCode))
                    
                    arrAddress.append(mdlAddress)
 
                }
                
                database.close()
                return(true,arrAddress)
                
            }catch{
                
                database.close()
                return(false,arrAddress)
                
            }
            
        }else{
            return(false,arrAddress)
        }
        
    }
    
    func getStateDetail()->(Bool,[String]){
        
        var arrState : [String] = []
        
        if arrState.count > 0{
            arrState.removeAll()
        }
        
        if self.openDatabase(){
            
            do{
                
                let result = try database.executeQuery("select DISTINCT city_state from cities", values: nil)
                
                while result.next(){
                    
                    arrState.append(result.string(forColumn:"city_state"))
                    
                }
                
                database.close()
                return(true,arrState)
                
            }catch{
                
                database.close()
                return(false,arrState)
                
            }
            
        }else{
            return(false,arrState)
        }
        
    }
    
    func getOrderIdOfPendingImageOrder() -> (Bool,Int?){
        
        var orderId : Int?
        
        if self.openDatabase(){
            do{
               
                let result = try database.executeQuery("select * from \(ktblOrderDetail) where \(kOrderDetailOrderStatus) == 'PendingImages'", values: nil)
                
                while result.next(){
                    orderId = Int(result.int(forColumn: kOrderDetailOrderId))
                }
                
                database.close()
                
                return (true,orderId)
                
            }catch{
                
                database.close()
                
                return (false,nil)
                
            }
        }else{
            
            return(false,nil)
            
        }
        
    }
    
    func executeOrderDetail() -> (Bool,NSArray?){
        
        var orderIds  = [Int]()
        
        if self.openDatabase(){
            do{
                let result = try database.executeQuery("select * from \(ktblOrderDetail) where \(kOrderDetailOrderStatus) != 'PendingImages'", values: nil)
                
                while result.next() {
                    
                    let id = Int(result.int(forColumn: kOrderDetailOrderId))
                    
                    orderIds.append(id)
                    
                }
                
                database.close()
                
                return (true,orderIds as NSArray)
                
            }catch{
                
                database.close()
                return(false,nil)
                
            }
        }else{
            return(false,nil)
        }
        
    }
    
    func getLastAddedCart() -> (Bool,Int?){
        
        if self.openDatabase(){
            
            do{
                
                var iCartMasterId : Int!
                
                let result = try database.executeQuery("select * from \(ktblCartMaster) ORDER BY \(kCartMasterId) DESC LIMIT 1", values: nil)
                
                while result.next(){
                    
                    iCartMasterId = Int(result.int(forColumn: kCartMasterId))
                    
                }
                
                database.close()
                
                return(true,iCartMasterId)
                
            }catch{
                database.close()
                
                return(false,nil)
            }
            
        }else{
            return(false,nil)
        }
        
    }
    
    func getPhotoDetail(cartId:Int = 0) -> (Bool,NSArray?){
        if self.openDatabase(){
            
            do{
                
                var arrPhotos : [AnyObject] = []
                
                var strQuery : String!
                
                if cartId == 0{
                    strQuery = "select * from \(kTblPhotoMaster)"
                }else{
                    strQuery =  "select * from \(kTblPhotoMaster) where \(kPhotoMasterCartId) == \(cartId)"
                }
                
                let result = try database.executeQuery(strQuery, values: nil)
                
                while result.next() {
                    let mdlPhotoDetail = PhotoDetailMdl(photoId: Int(result.int(forColumn: kPhotoMasterPhotoId)), imgPath: result.string(forColumn: kPhotoMasterPhotoPath), photoQty: Int(result.int(forColumn: kPhotoMasterPhotoCopy)), imgText: result.string(forColumn: kPhotoMasterPhotoText), isCover: result.bool(forColumn: kPhotoMasterIsCover), cartId: Int(result.int(forColumn: kPhotoMasterCartId)), coverTitle: result.string(forColumn: kPhotoMasterCoverTitle),serverUrl:result.string(forColumn: kPhotoMasterBucketUrl))
                    
                    arrPhotos.append(mdlPhotoDetail)
                }
                
                database.close()
                
                return (true,arrPhotos as NSArray)
                
            }catch{
                database.close()
                
                return (false,nil)
            }
        }else{
            
            return (false,nil)
            
        }
    }
    
    func getSinglePhotoDetail(cartId:Int) -> (Bool,PhotoDetailMdl?){
        
        if self.openDatabase(){
            do{
                let result = try database.executeQuery("select * from \(kTblPhotoMaster) where \(kPhotoMasterCartId) == \(cartId)", values: nil)
                
                var mdlPhotoDetail : PhotoDetailMdl!
                
                while result.next(){
                    
                    mdlPhotoDetail = PhotoDetailMdl(photoId: Int(result.int(forColumn: kPhotoMasterPhotoId)), imgPath: result.string(forColumn: kPhotoMasterPhotoPath), photoQty: Int(result.int(forColumn: kPhotoMasterPhotoCopy)), imgText: result.string(forColumn: kPhotoMasterPhotoText), isCover: result.bool(forColumn: kPhotoMasterIsCover), cartId: Int(result.int(forColumn: kPhotoMasterCartId)), coverTitle: result.string(forColumn: kPhotoMasterCoverTitle), serverUrl: result.string(forColumn: kPhotoMasterBucketUrl))
                    
                }
                
                database.close()
                
                return (true,mdlPhotoDetail)
                
                
            }catch{
                database.close()
                
                return(false,nil)
            }
        }else{
            database.close()
            
            return(false,nil)
        }
        
    }
    
    func getLastAddedProduct() -> (Bool,Int?){
        
        /*if self.openDatabase(){
            
            do{
                
                var iProductId : Int!
                
                let result = try database.executeQuery("select * from \(ktblProductDetail) ORDER BY \(kCartDetailFieldId) DESC LIMIT 1", values: nil)
                
                while result.next(){
                    
                    iProductId = Int(result.int(forColumn: kCartDetailFieldId))
                    
                }
                
                database.close()
                
                return(true,iProductId)
                
            }catch{
                database.close()
                
                return(false,nil)
            }
            
        }else{
            return(false,nil)
        }*/
        
        return (false,nil)
        
    }
    
    func getGiftCode() -> (Bool,NSArray?){
        
        var arrCode : [String] = []
        
        if self.openDatabase(){
            do{
                
                let result = try database.executeQuery("Select * from \(kTblReferCode)", values: nil)
                
                while result.next(){
                    
                    arrCode.append(result.string(forColumn: "code"))
                    
                }
            }catch{
                database.close()
                return(false,nil)
            }
            
            database.close()
            return (true,arrCode as NSArray)
        }else{
            return(false,nil)
        }
        
    }
    
    func getCountNotUploadedPhotos() -> (Bool,Int){
        
        var cnt = 0
        
        if self.openDatabase(){
            do {
                
                let result = try database.executeQuery("select count(\(kPhotoMasterBucketUrl)) from \(kTblPhotoMaster) where \(kPhotoMasterBucketUrl) == ''", values: nil)
                
                while result.next() {
                    cnt = Int(result.int(forColumnIndex: 0))
                }
                
                database.close()
                return (true,cnt)
                
            }catch{
                
                database.close()
                return (false,cnt)
                
            }
        }else{
            return(false,cnt)
        }
    }
    
    
    func executeSelectQueryOfCartDetail() -> (Bool,NSArray?){
        
        var arrCart : [AnyObject] = []
        
        if self.openDatabase(){
            do{
                
                let result = try database.executeQuery("Select * from \(ktblCartMaster)", values: nil)
                
                while result.next() {
                    
                    var mdlCart : CartModel!
                    
                    mdlCart = CartModel(cId: Int(result.int(forColumn: kCartMasterId)), totalPhoto: Int(result.int(forColumn: kCartMasterTotalPhotos)), qty: Int(result.int(forColumn: kCartMasterCartCopy)), productName: result.string(forColumn: kCartMasterProductName), price: result.double(forColumn: kCartMasterProductPrice), productId: result.string(forColumn: kCartMasterProductId),dimension:result.string(forColumn: kCartMasterProductDimension),iImgLimit: Int(result.int(forColumn: kCartMasterProdcutLimit)), categoryId: result.string(forColumn: kCartMasterProductCatId), folderName: result.string(forColumn: kCartMasterCartName))
                    
                    arrCart.append(mdlCart)
                    
                }
                
                database.close()
                
                return (true,arrCart as NSArray)
                
            }catch{
                
                database.close()
                return(false,arrCart as NSArray)
                
            }
        }else{
            return(false,arrCart as NSArray)
        }
        
    }
    
    func executeSelectQueryOfSocialMedia(query: String) -> (Bool,NSArray?){
        
        var arrMedia : [AnyObject] = []
        
        if self.openDatabase(){
            do{
                let result = try database.executeQuery(query, values: nil)
                
                while result.next() {
                    
                    var mdlSocialMedia : SocialMediaMDL!
                        
                    mdlSocialMedia = SocialMediaMDL(name: result.string(forColumn: kFieldMediaName), userId: result.string(forColumn: kFieldLogedInUserID), accessToken: result.string(forColumn: kFieldMediaAccessToken))
                    
                    arrMedia.append(mdlSocialMedia)
                    
                }
                
                database.close()
                
                return (true,arrMedia as NSArray)
                
            }catch{
                
                database.close()
                return(false,arrMedia as NSArray)
                
            }
        }else{
            return(false,arrMedia as NSArray)
        }
        
    }*/

}
