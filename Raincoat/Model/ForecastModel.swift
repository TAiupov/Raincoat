//
//  WeatherModel.swift
//  Raincoat
//
//  Created by Tagir Aiupov on 2021-04-28.
//

import Foundation
import UIKit


let ApiKey: String = "4e59d0ee2b72f65c0d0cae71190dcc12"

struct Forecast: Codable {
    struct Daily: Codable {
        let dt: Date
        struct Temp: Codable {
            let day: Double
            let min: Double
            let max: Double
        }
        let temp: Temp
        let humidity: Int
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
        }
        let weather: [Weather]
        let clouds: Int
        let pop: Double
    }
    let daily: [Daily]
    
    let current: Current
    struct Current: Codable {
        let temp: Double
        let sunrise: Double
        let sunset: Double
        let pressure: Double
        let humidity: Double
        let wind_speed: Double
        let weather: [Weather]
        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String
            let icon: String
        }
    }
}
