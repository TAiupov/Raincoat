
//  Created by Tagir Aiupov on 2021-05-02.
//

import Foundation
import SwiftUI


struct ForecastVM {
    let forecast: Forecast.Daily
    var system: Int
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double {
        let celcius = temp - 273.5
        if system == 0 {
            return celcius
        } else {
            return celcius * 9 / 5 + 32
        }
    }
    
    var day: String {
        Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var temp: String {
        return "\(Self.numberFormatter.string(for: convert(forecast.temp.day)) ?? "0")°"
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: convert(forecast.temp.max)) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: convert(forecast.temp.min)) ?? "0")°"
    }
    
    var pop: String {
        return "💧 \(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds)%"
    }
    
    var humidity: String {
        return " \(forecast.humidity)%"
    }
    
    var weatherIconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png")!
    }
}

struct CurrentVM {
    let forecast: Forecast.Current
    var system: Int
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter
    }
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double {
        let celcius = temp - 273.5
        if system == 0 {
            return celcius
        } else {
            return celcius * 9 / 5 + 32
        }
    }
    
    var temp: String {
        return "\(Self.numberFormatter.string(for: convert(forecast.temp)) ?? "0")°"
    }
    
    var description: String {
        return forecast.weather[0].main.capitalized
    }
    
    var humidity: String {
        return " \(Self.numberFormatter.string(for: forecast.humidity) ?? "0")%"
    }
    
    var pressure: String {
        return " \(Self.numberFormatter.string(for: forecast.pressure) ?? "-") hPa"
    }
    
    var wind: String {
        return "\(Self.numberFormatter2.string(for: forecast.wind_speed) ?? "-") km/h"
    }
    
    var weatherIconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png")!
    }
    
}


