//
//  WeatherConditions.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 17.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import Foundation

class WeatherConditions {
    var type: WeatherType
    var temperature: Int
    var description: String
    var city: String
    
    init(type: WeatherType, temperature: Int, description: String, city: String) {
        self.type = type
        self.temperature = temperature
        self.description = description
        self.city = city
    }
}
