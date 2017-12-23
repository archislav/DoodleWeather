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
    
    @IBOutlet var scrollView: UIScrollView!
    var refreshControl: UIRefreshControl!
    
    let weatherService = WeatherService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Asking Yahoo...")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControlEvents.valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPullToRefresh(sender: AnyObject){
        clearWeatherConditions()
        weatherService.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, successCallback: {
            (weatherConditions) in
            DispatchQueue.main.async {
                self.setWeatherConditions(weatherConditions)
            }
        }, finalizeCallback: {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    /*@IBAction func pressGetWeather(_ sender: Any) {
     clearWeatherConditions()
     weatherService.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, successCallback: {
     (weatherConditions) in
     self.setWeatherConditions(weatherConditions)
     })
     }*/
    
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

