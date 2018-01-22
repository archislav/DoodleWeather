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
        static let YAHOO_WEATHER_API_URL = "https://query.yahooapis.com/v1/public/yql"
        
        static let shared = WeatherService()
        
        private init() {
            
        }
        
        func requestWeatherConditions(woeid: Int, successCallback: @escaping (WeatherConditions) -> (), finalizeCallback: @escaping () -> ())   {
            let parameters = createWeatherConditionsParameters(for: woeid)
            
            doRequestWeatherConditions(parameters, successCallback, finalizeCallback)
        }
        
        func requestWeatherConditions(latitude: Double, longitude: Double, successCallback: @escaping (WeatherConditions) -> (), finalizeCallback: @escaping () -> ()) {
            let parameters = createWeatherConditionsRequest(latitude: latitude, longitude: longitude)
            
            doRequestWeatherConditions(parameters, successCallback, finalizeCallback)
        }
        
        fileprivate func doRequestWeatherConditions(_ parameters: [String: String], _ successCallback: @escaping (WeatherConditions) -> (), _ finalizeCallback: @escaping () -> ()) {
            HTTPUtils.executePOSTRequest(url: WeatherService.YAHOO_WEATHER_API_URL, with: parameters, completionHandler: { data, response, error in
                if let weatherConditions = self.handleWeatherConditionsResponse(data, response, error) {
                    successCallback(weatherConditions)
                }
                
                finalizeCallback()
            })
        }
        
        private func createWeatherConditionsRequest(latitude: Double, longitude: Double) -> [String: String] {
            // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid in (SELECT woeid FROM geo.places WHERE text=\"(41.11, 41.11)\")"    -d format=json
            return doCreateWeatherConditionsParameters(woeidWhereConditionString: "woeid in (SELECT woeid FROM geo.places WHERE text=\"(\(latitude), \(longitude))\")")
        }
        
        private func createWeatherConditionsParameters(for woeid: Int) -> [String: String] {
            // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid=2122265"    -d format=json
            return doCreateWeatherConditionsParameters(woeidWhereConditionString: "woeid = \(woeid)")
        }
        
        private func doCreateWeatherConditionsParameters(woeidWhereConditionString: String) -> [String: String] {
            let parameters: [String: String] = [
                "q": "select item.condition, location from weather.forecast where \(woeidWhereConditionString) and u='c'",
                "format": "json"
            ]
            
            return parameters
        }
        
        private func handleWeatherConditionsResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> WeatherConditions? {
            guard error == nil else {
                os_log("Got error on request: %@", type: .error, error.debugDescription)
                return nil
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                guard statusCode == HTTPUtils.STATUS_CODE_OK else {
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
                let locationPath: [String] = ["query", "results", "channel", "location"]
                
                let temp = JSONUtils.getIntFromJson(json, conditionPath, "temp")
                let description = JSONUtils.getStringFromJson(json, conditionPath, "text")
                let code = JSONUtils.getIntFromJson(json, conditionPath, "code")
                let city = JSONUtils.getStringFromJson(json, locationPath, "city")
                
                let weatherConditions = WeatherConditions(type: WeatherType.fromCode(code), temperature: temp, description: description, city: city)
                
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
    
