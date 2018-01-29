//
//  WeatherType.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 17.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import Foundation

enum WeatherType {
    case cloudy
    case snow
    case rain
    case unknown
    
    static let IMAGE_NAME_UNKNOWN = "unknown"
    
    static let CODE_TO_TYPE: [Int:WeatherType] = [
//        0    tornado
//        1    tropical storm
//        2    hurricane
//        3    severe thunderstorms
//        4    thunderstorms
        5:rain,    //mixed rain and snow
        6:rain,    //mixed rain and sleet
        7:snow,    //mixed snow and sleet
//        8    freezing drizzle
//        9    drizzle
        10:rain,    //freezing rain
        11:rain,    //showers
        12:rain,    //showers
        13:snow,    //snow flurries
        14:snow,    //light snow showers
        15:snow,    //blowing snow
        16:snow,    //snow
//        17    hail
//        18    sleet
//        19    dust
//        20    foggy
//        21    haze
//        22    smoky
//        23    blustery
//        24    windy
//        25    cold
        26:cloudy,    //cloudy
        27:cloudy,    //mostly cloudy (night)
        28:cloudy,    //mostly cloudy (day)
        29:cloudy,    //partly cloudy (night)
        30:cloudy,    //partly cloudy (day)
//        31    clear (night)
//        32    sunny
//        33    fair (night)
//        34    fair (day)
//        35    mixed rain and hail
//        36    hot
//        37    isolated thunderstorms
//        38    scattered thunderstorms
//        39    scattered thunderstorms
        40:rain,    //scattered showers
        41:snow,    //heavy snow
        42:snow,    //scattered snow showers
        43:snow,    //heavy snow
//        44    partly cloudy
//        45    thundershowers
        46:snow,    //snow showers
//        47    isolated thundershowers
//        3200    not available
        
    ]
    
    static let TYPE_TO_IMAGE_NAME: [WeatherType:String] = [
        .cloudy: "cloudy",
        .rain: "rain",
        .snow: "snow",
        .unknown: IMAGE_NAME_UNKNOWN
    ]
    
    static func fromCode(_ code: Int) -> WeatherType {
        return CODE_TO_TYPE[code] ?? unknown
    }
    
    func getImageName() -> String {
        return WeatherType.TYPE_TO_IMAGE_NAME[self] ?? WeatherType.IMAGE_NAME_UNKNOWN
    }
   
}
