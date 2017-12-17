//
//  ViewController.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 10.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherDesctiptionLabel: UILabel!
    
    let weatherService = WeatherService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressGetWeather(_ sender: Any) {
        self.degreeLabel?.text = "..."
        self.weatherDesctiptionLabel?.text = "..."
        weatherService.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, callback: {
            (weatherConditions) in
            self.degreeLabel?.text = "\(weatherConditions.temperature)° C"
            self.weatherDesctiptionLabel?.text = "\(weatherConditions.description)"
        })
    }
}

