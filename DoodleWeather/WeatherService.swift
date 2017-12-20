//
//  WeatherService.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 17.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import Foundation

class WeatherService {
    
    static let MOSCOW_WOEID = 2122265
    
    static let shared = WeatherService()
    
    private init() {
        
    }
    
    /*func requestWeatherConditions(woeid: Int, callback: (WeatherConditions) -> ()) {
     let a = WeatherConditions(type: WeatherType.cloudy, temperature: 2, description: "Test")
     callback(a)
     }*/
    
    func requestWeatherConditions(woeid: Int, successCallback: @escaping (WeatherConditions) -> ()) {
        // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid=2122265"    -d format=json
        
        
        let parameters: [String: String] = [
            "q": "select item.condition from weather.forecast where woeid=\(woeid) and u='c'",
            "format": "json"
        ]
        
        let url = URL(string: "https://query.yahooapis.com/v1/public/yql")!
        
        let session = URLSession.shared
        
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
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                print("Got error on request: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                guard statusCode == 200 else {
                    print("Got response status code: \(statusCode)")
                    return
                }
            }
            
            guard let data = data else {
                print("Got empty data on request")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print("Response body: \(json)")
                    
                    let conditionPath: [String] = ["query", "results", "channel", "item", "condition"]
                    
                    let temp = self.getIntFromJson(json, conditionPath, "temp")
                    let description = self.getStringFromJson(json, conditionPath, "text")
                    let code = self.getIntFromJson(json, conditionPath, "code")
                    
                    let weatherConditions = WeatherConditions(type: WeatherType.fromCode(code), temperature: temp, description: description)
                    
                    DispatchQueue.main.async {
                        successCallback(weatherConditions)
                    }
                }
            } catch let error {
                print("Error on response parsing: \(error.localizedDescription)")
                return
            }
        })
        task.resume()
    }
    
    func getIntFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> Int {
        var currJson : [String: Any] = json
        for pathField in path {
            currJson = currJson[pathField] as! [String: Any]
        }
        
        return Int(currJson[field] as! String)!
    }
    
    func getStringFromJson(_ json: [String: Any], _ path: [String], _ field: String) -> String {
        var currJson : [String: Any] = json
        for pathField in path {
            currJson = currJson[pathField] as! [String: Any]
        }
        
        return currJson[field] as! String
    }
    
    func createPostBodyUrlencodedString(for paramteres: [String:String]) -> String {
        //        return "q=select+item.condition+from+weather.forecast+where+woeid%3D2122265+and+u+%3D+%27c%27&format=json"
        let urlEncoder = UrlEncoder()
        var keyValuePairs: [String] = []
        
        for (key, value) in paramteres {
            let urlEncodedValue = urlEncoder.urlEncode(value)
            let keyValuePair = "\(key)=\(urlEncodedValue)"
            keyValuePairs.append(keyValuePair)
            print("keyValuePair: \(keyValuePair)")
        }
        
        let joinedKeyValuePairs = keyValuePairs.joined(separator: "&")
        print("joinedKeyValuePairs: \(joinedKeyValuePairs)")
        
        return joinedKeyValuePairs
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

