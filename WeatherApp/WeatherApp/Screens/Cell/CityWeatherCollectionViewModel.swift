//
//  CityWeatherCollectionViewModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

protocol CityWeatherCollectionCellViewModelProtocol {
    func getCityWeaterImage(data: DailyForecast) -> String
    func getCityTemperature(data: DailyForecast) -> String
    func getCityDate(data: DailyForecast) -> String
}

class CityWeatherCollectionCellViewModel: CityWeatherCollectionCellViewModelProtocol {
    private var forecastDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    func getCityWeaterImage(data: DailyForecast) -> String {
        guard let image = data.day?.icon else {
            return "unknown"
        }
        
        return "Image-\(image)"
    }
    
    func getCityTemperature(data: DailyForecast) -> String {
        guard let minTemperature = data.temperature?.minimum?.value, let maxTemperature = data.temperature?.maximum?.value else {
            return "unknown"
        }
        
        let temperature = "\(calculateCelsius(fahrenheit: minTemperature))" + "° - " + "\(calculateCelsius(fahrenheit: maxTemperature))" + "°"
        
        return temperature
    }
    
    func getCityDate(data: DailyForecast) -> String {
        guard let date = data.date else {
            return "unknown"
        }
        
        var stringDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let dateTwo = dateFormatter.date(from: date) {
            stringDate = forecastDateFormatter.string(from: dateTwo)
        }
        
        return stringDate
    }
}

extension CityWeatherCollectionCellViewModel {
    func calculateCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}
