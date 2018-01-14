//
//  WeatherServiceTests.swift
//  DoodleWeatherTests
//
//  Created by Сергей Морозов on 13.01.18.
//  Copyright © 2018 Сергей Морозов. All rights reserved.
//

import XCTest
@testable import DoodleWeather

class WeatherServiceTests: XCTestCase {
    
    var service: WeatherService!
    
    override func setUp() {
        super.setUp()
        service = WeatherService.shared
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
//    async tests!!!
    func testWoeidRequest() {
        let successPromise = expectation(description: "Successful conditions response promise")
        let finalizePromise = expectation(description: "Finalize promise")
        
        var resultConditions: WeatherConditions!
        
        service.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, successCallback: { (conditions) in
            successPromise.fulfill()
            resultConditions = conditions
        }, finalizeCallback: {
            finalizePromise.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(resultConditions)
        XCTAssertEqual(resultConditions.city, "Moscow")
        
        //        TODO: check is MOSCOW for city
        
//        XCTAssertEqual("test%20123", encoder.urlEncode("test 123"))
//        XCTAssertEqual("test%2B123", encoder.urlEncode("test+123"))
//        XCTAssertEqual("test%3D123", encoder.urlEncode("test=123"))
//        XCTAssertEqual(
//            "select%20item.condition%20from%20weather.forecast%20where%20woeid%3D2122265%20and%20u%20%3D%27c%27",
//            encoder.urlEncode(
//                "select item.condition from weather.forecast where woeid=2122265 and u ='c'"
//        ))
//
//        XCTAssertEqual(
//            "select%20item.condition%20from%20weather.forecast%20where%20woeid%3E2122265%20and%20u%20%21%3D%27c%27",
//            encoder.urlEncode(
//                "select item.condition from weather.forecast where woeid>2122265 and u !='c'"
//        ))
        
    }
}

