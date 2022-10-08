//
//  NetworkConstant.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

final class WeatherNetworkConstant {
    
    // http://dataservice.accuweather.com/locations/v1/cities/search?apikey=L7xhkt0dIi6C2TqUGkgt47tjGsmnH0XL&q=istanbul
    
    enum WeatherNetwork: String {
        case path_url = "https://dataservice.accuweather.com/"
        case locations_url = "locations/"
        case city_url = "v1/cities/"
        case searc_url = "search"
        case key_url = "?apikey=TGCLjSiP16N8CUAgaRzFuL2FQVsmdesL&"
        case q_url = "q="
        
        static func weatherURL(cityName: String) -> String {
            return "\(path_url.rawValue)\(locations_url.rawValue)\(city_url.rawValue)\(searc_url.rawValue)\(key_url.rawValue)\(q_url.rawValue)\(cityName)"
        }
    }
    
// http://dataservice.accuweather.com/forecasts/v1/daily/5day/318290?apikey=TGCLjSiP16N8CUAgaRzFuL2FQVsmdesL
    
    enum ForecastNetwork: String {
        case path_url = "https://dataservice.accuweather.com/"
        case forecasts_url = "forecasts/"
        case daily_url = "v1/daily/5day/"
        case key_url = "?apikey=TGCLjSiP16N8CUAgaRzFuL2FQVsmdesL"
        
        static func forecastURL(key: String) -> String {
            return "\(path_url.rawValue)\(forecasts_url.rawValue)\(daily_url.rawValue)\(key)\(key_url.rawValue)"
        }
    }
}
