
//  Created by Tagir Aiupov on 2021-05-02.
//
import CoreLocation
import Foundation
import SwiftUI

class ForecastListVM: ObservableObject {
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    var appError: AppError? = nil
    
    let id = UUID().uuidString
    
    @Published var forecasts: [ForecastVM] = []
    @Published var current: CurrentVM?
    
    @AppStorage("system") var system: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = system
            }
        }
    }
    let location: String
    
    init(location: String) {
        self.location = location
        getWeatherForecast(location: location)
    }
    
    func getWeatherForecast(location: String) {
        
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    self.appError = AppError(errorString: NSLocalizedString("Unable to determine location from this text.", comment: ""))
                case .network:
                    self.appError = AppError(errorString: NSLocalizedString("You do not appear to have a network connection.", comment: ""))
                default:
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                
                print(error.localizedDescription)
            }
            
            let apiService = APIService.shared
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly,alerts&appid=\(ApiKey)",
                                   dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.forecasts = forecast.daily.map { ForecastVM(forecast: $0, system: self.system)}
                            self.current = CurrentVM(forecast: forecast.current, system: self.system)
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
            
        }
    }
}
