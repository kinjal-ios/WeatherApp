//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Kinjal Solanki on 22/03/19.
//  Copyright © 2019 Kinjal Solanki. All rights reserved.
//

import XCTest
@testable import WeatherApp
@testable import Networking

class WeatherAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        //BaseUrl : "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice"
        
        let valuesExpectation = expectation(description: "values")
        var responseData: [ResponseModel]?
        
        let networking = Networking(baseURL: "https://s3.eu-west-2.amazonaws.com/interview-question-data/metoffice")
        networking.get("/Rainfall-England.json") { result in
            switch result {
            case .success(let response):
                let json = response.arrayBody
                print(json)
                do {
                    let json = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let decodedValues = try decoder.decode([ResponseModel].self, from: json)
                    responseData = decodedValues
                    valuesExpectation.fulfill()
                    
                    
                } catch {
                    print(error)
                }
                
            case .failure( _):
                break
                // Handle error
            }
        }
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNotNil(responseData)
        }
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
