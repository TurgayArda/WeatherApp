//
//  CityWeatherConstant.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

final class CityWeatherConstant {
    enum CityWeaterUIConstant: String {
        case searchBarPlaceholder = "City Name"
        case weatherForecast = "Weather Forecast"
    }
    
    enum CityWeatherAlertConstant: String {
        case wrongCityName = "Something went wrong\nPlease enter a correct city name"
        case wrongCityKey = "Something went wrong\nPlease enter a correct city key"
        case WrongActionTitle = "Try Again"
        case errorAction = "Ok"
    }
   
}
