//
//  ViewController.swift
//  DoodleWeather
//
//  Created by Сергей Морозов on 10.12.17.
//  Copyright © 2017 Сергей Морозов. All rights reserved.
//

import UIKit
import CoreLocation
import os.log

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let LOG = OSLog(subsystem: "my.tests", category: "ViewController") // just to try
    
    // MARK: UI components
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherDesctiptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityLabel: UILabel!
    var refreshControl: UIRefreshControl!
    
    // MARK: services
    let weatherService = WeatherService.shared
    let locationManager = CLLocationManager()
    
    // MARK: current coordinate
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPullToRefresh()
        setupLocationManager()
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //        print("didChangeAuthorization: \(status.rawValue)")
        os_log("didChangeAuthorization: %d", log: LOG, type: OSLogType.info, status.rawValue)
        guard status == CLAuthorizationStatus.authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        os_log("didUpdateLocations - lat: %f, lon: %f", lat, lon)
        
        currentCoordinate = location.coordinate 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPullToRefresh(sender: AnyObject){
        clearWeatherConditions()
        let successCallback: (WeatherConditions) -> () = {
            (weatherConditions) in
            DispatchQueue.main.async {
                self.setWeatherConditions(weatherConditions)
            }
        }
        let finalizeCallback: () -> () = {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        if let coordinate = currentCoordinate {
            weatherService.requestWeatherConditions(latitude: coordinate.latitude, longitude: coordinate.longitude ,successCallback: successCallback, finalizeCallback: finalizeCallback)
        } else {
            weatherService.requestWeatherConditions(woeid: WeatherService.MOSCOW_WOEID, successCallback: successCallback, finalizeCallback: finalizeCallback)
        }
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
            imageName: weatherConditions.type.getImageName(),
            city: weatherConditions.city)
    }
    
    private func clearWeatherConditions() {
        setWeatherConditionsComponents(degreeText: "", weatherDescription: "", imageName: WeatherType.IMAGE_NAME_UNKNOWN, city: "")
    }
    
    private func setWeatherConditionsComponents(degreeText: String, weatherDescription: String, imageName: String, city: String) {
        self.degreeLabel?.text = degreeText
        self.weatherDesctiptionLabel?.text = weatherDescription
        self.imageView?.image = UIImage(named: imageName)
        self.cityLabel?.text = city
    }
    
    fileprivate func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Asking Yahoo...")
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(sender:)), for: UIControlEvents.valueChanged)
        scrollView.refreshControl = refreshControl
    }
}

