//
//  GlobalStore.swift
//  x016WeatherApp
//
//  Created by Тагир Аюпов on 2021-05-09.
//

import Foundation
import CoreLocation

class Store: ObservableObject {
    
    static let instance = Store()
    
    @Published var cities: [ForecastListVM] = []

    
    var locations: [String] = [
        "Vancouver",
        "Ufa",
        "Moscow"
    ]
    
    
    
    init() {
       getWeather()
    }
    
    func getWeather() {
        var temp: [ForecastListVM] = []
        for i in 0..<locations.count {
            temp.append(ForecastListVM(location: locations[i]))
        }
            self.cities = temp
    }
    
    func delete(at offsets: IndexSet) {
        locations.remove(atOffsets: offsets)
        cities.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        locations.move(fromOffsets: source, toOffset: destination)
        cities.move(fromOffsets: source, toOffset: destination)
    }
    
    func addCity(location: String, city: ForecastListVM) {
        self.locations.append(location)
        self.cities.append(city)
        
    }
    
}
