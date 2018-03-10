//
//  ViewController.swift
//  meteo
//
//  Created by tribouillard on 05/03/2018.
//  Copyright © 2018 tribouillard. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var dayProgressView: UIProgressView!

    @IBOutlet weak var temperatureSegmentedControl: UISegmentedControl!
    
    var city = "Mexico City"
    
    var weather: Forecast?
    
    let temperatureFormatter: MeasurementFormatter = {
        let temperatureFormatter = MeasurementFormatter()
        temperatureFormatter.unitOptions = .providedUnit
        temperatureFormatter.numberFormatter = NumberFormatter()
        temperatureFormatter.numberFormatter.minimumFractionDigits = 0
        temperatureFormatter.numberFormatter.maximumFractionDigits = 0
        temperatureFormatter.numberFormatter.minimumIntegerDigits = 1
        return temperatureFormatter
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        dateFormatter.locale    = Locale.current
        return dateFormatter
    }()

    let hoursFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale    = Locale.current
        return dateFormatter
    }()
    
    let ws = Ws()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.reloadData()
        
    }
    
    @IBAction func unwindCityViewController(segue: UIStoryboardSegue) {
        guard let searchVC = segue.source as? ChangeCityViewController, let city = searchVC.selectedCity else {
            return
        }
        self.city = city
        reloadData()
    }
    
    
    
    
    @IBAction func changeTempUnit(_ sender: UISegmentedControl) {
        
        
        guard let weather = self.weather else {
            return
        }
        
        let unit: UnitTemperature = sender.selectedSegmentIndex == 0  ? .celsius : .fahrenheit
            
        self.tempLabel.text = self.temperatureFormatter.string(from: weather.temperature.converted(to: unit))
        self.minLabel.text = self.temperatureFormatter.string(from: weather.temperatureMinimum.converted(to: unit))
        self.maxLabel.text = self.temperatureFormatter.string(from: weather.temperatureMaximum.converted(to: unit))
        
        
    }
    
    func reloadData() {
        self.callWS(city: self.city)
    }
    
    /// <#Description#>
    ///
    /// - Parameter city: <#city description#>
    func callWS(city: String){
        
        ws.getTodayWeatherDetails(location: .cityName(city)) {  (weather) in
            DispatchQueue.main.async {
                print(weather)
            }
        }
        
        ws.getTodayWeather(location: .cityName(city)) { (weather) in
            DispatchQueue.main.async {
                
                self.weather = weather
                
                self.cityLabel.text = weather.city
                self.tempLabel.text = self.temperatureFormatter.string(from: weather.temperature)
                self.minLabel.text = self.temperatureFormatter.string(from: weather.temperatureMinimum)
                self.maxLabel.text = self.temperatureFormatter.string(from: weather.temperatureMaximum)
                self.humidityLabel.text = "Humidité : \(String(weather.humidity)) %"
                self.timeLabel.text = self.dateFormatter.string(from: weather.date)
                
                guard let conditions = weather.conditions.first else {
                    return
                }
                print(conditions.type.nameImage)

                self.weatherImageView.image = UIImage(named: conditions.type.nameImage)
                
                if let sunrise = weather.sunrise {
                    self.sunriseLabel.text = self.hoursFormatter.string(from: sunrise)
                } else {
                    self.sunriseLabel.text = ""
                }
                
                if let sunset = weather.sunset {
                    self.sunsetLabel.text = self.hoursFormatter.string(from: sunset)
                } else {
                    self.sunsetLabel.text = ""
                }
                
            }
        }
    }

}

