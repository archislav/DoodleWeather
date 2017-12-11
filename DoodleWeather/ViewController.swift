//
//  ViewController.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 10.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressGetWeather(_ sender: Any) {
        self.weatherText?.text = "..."
        requestTemperature()
    }
    
    private func requestTemperature() {
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
        // curl https://query.yahooapis.com/v1/public/yql    -d q="select wind from weather.forecast where woeid=2122265"    -d format=json
        
        
        let parameters: [String: Any] = [
            "q": "select item.condition from weather.forecast where woeid=2122265",
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

        let postString = "q=select+item.condition+from+weather.forecast+where+woeid%3D2122265%0D%0A&format=json" // todo: create from params
        request.httpBody = postString.data(using: .utf8)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    let temp = self.getIntFromJson(json, ["query", "results", "channel", "item", "condition"], "temp")
                    
                    DispatchQueue.main.async {
                        self.weatherText?.text = "\(temp) F"
                    }
                }
            } catch let error {
                print(error.localizedDescription)
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
    
}

