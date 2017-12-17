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
    
    static let CODE_TO_TYPE: [Int:WeatherType] = [
        26:cloudy,
        27:cloudy,
        28:cloudy,
        29:cloudy,
        30:cloudy,
        
        7:snow,
        13:snow,
        14:snow,
        15:snow,
        16:snow,
        41:snow,
        42:snow,
        43:snow,
        46:snow,
        
        5:rain,
        6:rain,
        10:rain,
        35:rain,
        11:rain,
        12:rain,
        40:rain
        
    ]
    
    static func fromCode(_ code: Int) -> WeatherType {
        return CODE_TO_TYPE[code] ?? unknown
    }
    
    func getImageName() -> String? {
        switch self {
        case .cloudy:
            return "cloud"
        default:
            return nil
        }
    }
    
    //    (26, "cloudy")
    
    //    init(code: Int, description: String) {
    //
    //    }
    
    /*
     
     Code    Description
     0    tornado
     1    tropical storm
     2    hurricane
     3    severe thunderstorms
     4    thunderstorms
     5    mixed rain and snow
     6    mixed rain and sleet
     7    mixed snow and sleet
     8    freezing drizzle
     9    drizzle
     10    freezing rain
     11    showers
     12    showers
     13    snow flurries
     14    light snow showers
     15    blowing snow
     16    snow
     17    hail
     18    sleet
     19    dust
     20    foggy
     21    haze
     22    smoky
     23    blustery
     24    windy
     25    cold
     26    cloudy
     27    mostly cloudy (night)
     28    mostly cloudy (day)
     29    partly cloudy (night)
     30    partly cloudy (day)
     31    clear (night)
     32    sunny
     33    fair (night)
     34    fair (day)
     35    mixed rain and hail
     36    hot
     37    isolated thunderstorms
     38    scattered thunderstorms
     39    scattered thunderstorms
     40    scattered showers
     41    heavy snow
     42    scattered snow showers
     43    heavy snow
     44    partly cloudy
     45    thundershowers
     46    snow showers
     47    isolated thundershowers
     3200    not available
     */
}
