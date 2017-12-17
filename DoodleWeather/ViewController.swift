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
    @IBOutlet weak var imageView: UIImageView!
    
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
        clearWeatherConditions()
        weatherService.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, callback: {
            (weatherConditions) in
            self.setWeatherConditions(weatherConditions)
        })
    }
    
    private func setWeatherConditions(_ weatherConditions: WeatherConditions) {
        setWeatherConditionsComponents(degreeText: "\(weatherConditions.temperature)° C",
            weatherDescription: weatherConditions.description,
            imageName: weatherConditions.type.getImageName())
    }
    
    private func clearWeatherConditions() {
        setWeatherConditionsComponents(degreeText: "...", weatherDescription: "...", imageName: WeatherType.IMAGE_NAME_UNKNOWN)
    }
    
    private func setWeatherConditionsComponents(degreeText: String, weatherDescription: String, imageName: String) {
        self.degreeLabel?.text = degreeText
        self.weatherDesctiptionLabel?.text = weatherDescription
        self.imageView?.image = UIImage(named: imageName)
    }
}

