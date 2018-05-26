//
//  TodayViewController.swift
//  Weather Widget
//
//  Created by Xabier Andrés Irulegui on 26/5/18.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherInfoKit

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    
    private var city = "Paris"
    private var country = "France"
    
    var defaults = UserDefaults(suiteName: "group.com.xabierAndres.weatherappdemo")!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = "\(city), \(country)"
        
        // Invoque the weather service to get the weather data
        WeatherService.sharedWeatherService().getCurrentWeather(location: city) { (data) in
            OperationQueue.main.addOperation {
                if let weatherData = data {
                    self.weatherLabel.text = weatherData.weather.capitalized
                    self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        // Get the location from defaults
        if let currentCity = defaults.value(forKey: "city") as? String, let currentCountry = defaults.value(forKey: "country") as? String {
            city = currentCity
            country = currentCountry
        }
        
        cityLabel.text = "\(city), \(country)"
        
        WeatherService.sharedWeatherService().getCurrentWeather(location: city) { (data) in
            guard let weatherData = data else {
                completionHandler(NCUpdateResult.noData)
                return
            }
            
            print(weatherData.weather)
            print(weatherData.temperature)
            
            OperationQueue.main.addOperation {
                self.weatherLabel.text = weatherData.weather.capitalized
                self.tempLabel.text = String(format: "%d", weatherData.temperature) + "\u{00B0}"
            }
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
