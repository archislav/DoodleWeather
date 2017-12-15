//
//  UrlEncoderTests.swift
//  DoodleWeatherTests
//
//  Created by Сергей Морозов on 15.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import XCTest
@testable import DoodleWeather

class UrlEncoderTests: XCTestCase {
    
    var encoder: UrlEncoder! 
    
    override func setUp() {
        super.setUp()
        encoder = UrlEncoder()
    }
    
    override func tearDown() {
        encoder = nil
        super.tearDown()
    }
    
    func testUrlEncode() {
        XCTAssertEqual("test%20123", encoder.urlEncode("test 123"))
        XCTAssertEqual("test%2B123", encoder.urlEncode("test+123"))
        XCTAssertEqual("test%3D123", encoder.urlEncode("test=123"))
        XCTAssertEqual(
            "select%20item.condition%20from%20weather.forecast%20where%20woeid%3D2122265%20and%20u%20%3D%27c%27",
            encoder.urlEncode(
                "select item.condition from weather.forecast where woeid=2122265 and u ='c'"
        ))
        
        XCTAssertEqual(
            "select%20item.condition%20from%20weather.forecast%20where%20woeid%3E2122265%20and%20u%20%21%3D%27c%27",
            encoder.urlEncode(
                "select item.condition from weather.forecast where woeid>2122265 and u !='c'"
        ))
        
    }
}
