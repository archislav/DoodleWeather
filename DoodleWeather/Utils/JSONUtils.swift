//
//  JSONUtils.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 22.01.18.
//  Copyright © 2018 Сергей Морозов. All rights reserved.
//

import Foundation

class JSONUtils {
    private init() {
        // незачем
    }
    
    static func getIntFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> Int {
        let jsonForPath = getJson(json, path)
        return Int(jsonForPath[field] as! String)!
    }
    
    static func getStringFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> String {
        let jsonForPath = getJson(json, path)
        return jsonForPath[field] as! String
    }
    
    private static func getJson(_ json: [String: Any], _ path: [String]) -> [String: Any] {
        var currJson : [String: Any] = json
        for pathField in path {
            currJson = currJson[pathField] as! [String: Any]
        }
        
        return currJson
    }
}
