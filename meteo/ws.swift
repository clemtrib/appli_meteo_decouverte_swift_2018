//
//  ws.swift
//  meteo
//
//  Created by tribouillard on 05/03/2018.
//  Copyright © 2018 tribouillard. All rights reserved.
//

import Foundation

enum WeatherLocation {
    case cityName(String)
    case cityId(Int)
    case coordinate(Double, Double)
    case cityNameAndCountryCode(String, String)
}

extension WeatherLocation {
    var queryItems: [URLQueryItem] {
        switch self {
        case .cityId(let id):
            return [
                URLQueryItem(name: "id", value: String(id))
            ]
        case .cityName(let name):
            return [
                URLQueryItem(name: "q", value: name)
            ]
            
        case .coordinate(let lat, let lng):
            return [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(lng))
            ]
        
        case .cityNameAndCountryCode(let name, let code):
            return [
                URLQueryItem(name: "q", value: "\(name),\(code)")
            ]
        
        }
    }
}


class Ws {
    
    let apiKey = "e4b142d39affc895d405923dd143a2cf"
    let apiUrl = URL(string: "https://api.openweathermap.org/data/2.5/")!
    
    let session : URLSession
    
    enum Error: Swift.Error {
        case existingError(Swift.Error)
        case noHttpResponse
        case invalidHttpResponse(URLResponse)
        case invalidStatusCode(Int)
        case noData
        
        static func check(data: Data?, response: URLResponse?, error: Swift.Error?) throws -> Data {
            if let error = error {
                print("try again", error)
            }
            
            guard let response = response else {
                throw Error.noHttpResponse
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw Error.invalidHttpResponse(response)
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw Error.invalidStatusCode(httpResponse.statusCode)
            }
            
            guard let data = data else {
                throw Error.noData
            }
            
            return data
            
        }
    }
    
    init() {
        
        let configuration = URLSessionConfiguration.default
        
        self.session = URLSession(configuration: configuration)
        
    }
    
    func getTodayWeather(location: WeatherLocation, completion: @escaping (Forecast) -> Void) {
        self.callWs(wsFn: "weather", location: location, completion: completion)
    }
    
    func getTodayWeatherDetails(location: WeatherLocation, completion: @escaping (Forecast) -> Void) {
        self.callWs(wsFn: "forecast", location: location, completion: completion)
    }
    
    func callWs(wsFn: String, location: WeatherLocation, completion: @escaping (Forecast) -> Void) {
        let url = apiUrl.appendingPathComponent(wsFn)
        print(url)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        components.queryItems = location.queryItems
        
        components.queryItems?.append(URLQueryItem(name: "APPID", value: self.apiKey))
        components.queryItems?.append(URLQueryItem(name: "units", value: "metric"))
        
        guard let finalUrl = components.url else {
            return
        }
        
        let task = self.session.dataTask(with: finalUrl) { (data, response, error) in
            
            let decoder = JSONDecoder()
            
            decoder.dateDecodingStrategy = .secondsSince1970
            
            do {
                let data = try Error.check(data: data, response: response, error: error)
                let weather = try decoder.decode(Forecast.self, from: data)
                completion(weather)
            } catch {
                print("error: ", error)
            }
            
        }
        task.resume()
    }
    
    
}
