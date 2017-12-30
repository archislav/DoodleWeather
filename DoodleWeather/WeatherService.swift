	//
//  WeatherService.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 17.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import Foundation
import os.log

class WeatherService {
    
    static let MOSCOW_WOEID = 2122265
    
    static let shared = WeatherService()
    
    private init() {
        
    }
    
    /*func requestWeatherConditions(woeid: Int, callback: (WeatherConditions) -> ()) {
     let a = WeatherConditions(type: WeatherType.cloudy, temperature: 2, description: "Test")
     callback(a)
     }*/
    
    func requestWeatherConditions(woeid: Int, successCallback: @escaping (WeatherConditions) -> (), finalizeCallback: @escaping () -> ()) {
        // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid=2122265"    -d format=json
        let request = createWeatherConditionsRequest(for: woeid)
        
        doRequestWeatherConditions(request, successCallback, finalizeCallback)
    }
    
    func requestWeatherConditions(latitude: Double, longitude: Double, successCallback: @escaping (WeatherConditions) -> (), finalizeCallback: @escaping () -> ()) {
        // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid=2122265"    -d format=json
        let request = createWeatherConditionsRequest(latitude: latitude, longitude: longitude)
        
        doRequestWeatherConditions(request, successCallback, finalizeCallback)
    }
    
    fileprivate func doRequestWeatherConditions(_ request: URLRequest, _ successCallback: @escaping (WeatherConditions) -> (), _ finalizeCallback: @escaping () -> ()) {
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let weatherConditions = self.handleWeatherConditionsResponse(data, response, error) {
                successCallback(weatherConditions)
            }
            
            finalizeCallback()
        })
        task.resume()
    }
    
    private func getIntFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> Int {
        var currJson : [String: Any] = json
        for pathField in path {
            currJson = currJson[pathField] as! [String: Any]
        }
        
        return Int(currJson[field] as! String)!
    }
    
    private func getStringFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> String {
        var currJson : [String: Any] = json
        for pathField in path {
            currJson = currJson[pathField] as! [String: Any]
        }
        
        return currJson[field] as! String
    }
    
    private func createPostBodyUrlencodedString(for paramteres: [String:String]) -> String {
        //        return "q=select+item.condition+from+weather.forecast+where+woeid%3D2122265+and+u+%3D+%27c%27&format=json"
        let urlEncoder = UrlEncoder()
        var keyValuePairs: [String] = []
        
        for (key, value) in paramteres {
            let urlEncodedValue = urlEncoder.urlEncode(value)
            let keyValuePair = "\(key)=\(urlEncodedValue)"
            keyValuePairs.append(keyValuePair)
            os_log("keyValuePair: %@", keyValuePair)
        }
        
        let joinedKeyValuePairs = keyValuePairs.joined(separator: "&")
        os_log("joinedKeyValuePairs: %@", joinedKeyValuePairs)
        
        return joinedKeyValuePairs
    }
    
    private func createWeatherConditionsRequest(latitude: Double, longitude: Double) -> URLRequest {
        return doCreateWeatherConditionsRequest(woeidWhereConditionString: "woeid in (SELECT woeid FROM geo.places WHERE text=\"(\(latitude), \(longitude))\")")
    }
    
    private func createWeatherConditionsRequest(for woeid: Int) -> URLRequest {
        return doCreateWeatherConditionsRequest(woeidWhereConditionString: "woeid = \(woeid)")
    }
    
    private func doCreateWeatherConditionsRequest(woeidWhereConditionString: String) -> URLRequest {
        let parameters: [String: String] = [
            "q": "select item.condition from weather.forecast where \(woeidWhereConditionString) and u='c'",
            "format": "json"
        ]
        
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        /*do {
         request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
         print(error.localizedDescription)
         }
         
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")*/
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postString = createPostBodyUrlencodedString(for: parameters)
        request.httpBody = postString.data(using: .utf8)
        
        return request
    }
    
    private func handleWeatherConditionsResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> WeatherConditions? {
        guard error == nil else {
            os_log("Got error on request: %@", type: .error, error.debugDescription)
            return nil
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusCode = httpResponse.statusCode
            guard statusCode == 200 else {
                os_log("Got response status code: %d", type: .error, statusCode)
                return nil
            }
        }
        
        guard let data = data else {
            os_log("Got empty data on request", type: .error)
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
            os_log("Response body: %@", json)
            
            let conditionPath: [String] = ["query", "results", "channel", "item", "condition"]
            
            let temp = self.getIntFromJson(json, conditionPath, "temp")
            let description = self.getStringFromJson(json, conditionPath, "text")
            let code = self.getIntFromJson(json, conditionPath, "code")
            
            let weatherConditions = WeatherConditions(type: WeatherType.fromCode(code), temperature: temp, description: description)
            
            return weatherConditions
        } catch let error {
            os_log("Error on response parsing: %@", type: .error, error.localizedDescription)
            return nil
        }
    }
}


/*let url = URL(string: "https://stackoverflow.com")
 
 let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
 guard error == nil && data != nil else {
 print("error: \(error)")
 return
 }
 
 if let httpResponse = response as? HTTPURLResponse {
 print("Status code: \(httpResponse.statusCode)")
 }
 
 print(String(data: data!, encoding: String.Encoding.utf8))
 }
 
 task.resume()*/

