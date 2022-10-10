//
//  NetworkConstant.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

final class WeatherNetworkConstant {
    
    static let apikey = "?apikey=BX5r9IgzLi5nDAsQ6b434WwN1nCASz54&"
    
    // http://dataservice.accuweather.com/locations/v1/cities/search?apikey=L7xhkt0dIi6C2TqUGkgt47tjGsmnH0XL&q=istanbul
    
    enum WeatherNetwork: String {
        case path_url = "https://dataservice.accuweather.com/"
        case locations_url = "locations/"
        case city_url = "v1/cities/"
        case searc_url = "search"
        case q_url = "q="
        
        static func weatherURL(cityName: String) -> String {
            return "\(path_url.rawValue)\(locations_url.rawValue)\(city_url.rawValue)\(searc_url.rawValue)\(apikey)\(q_url.rawValue)\(cityName)"
        }
    }
    
    // http://dataservice.accuweather.com/forecasts/v1/daily/5day/318290?apikey=TGCLjSiP16N8CUAgaRzFuL2FQVsmdesL
    
    enum ForecastNetwork: String {
        case path_url = "https://dataservice.accuweather.com/"
        case forecasts_url = "forecasts/"
        case daily_url = "v1/daily/5day/"
        
        static func forecastURL(key: String) -> String {
            return "\(path_url.rawValue)\(forecasts_url.rawValue)\(daily_url.rawValue)\(key)\(apikey)"
        }
    }
    
    // http://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=DTompvH8A8TamnSEn2nIYGNI3pxh6aUe&q=37.33233141,-122.0312186
    
    enum GeopositionNetwork: String {
        case path_url = "https://dataservice.accuweather.com/"
        case locations_url = "locations/"
        case city_url = "v1/cities/geoposition/"
        case searc_url = "search"
        case q_url = "q="
        
        static func geopositionURL(geoposition: String) -> String {
            return "\(path_url.rawValue)\(locations_url.rawValue)\(city_url.rawValue)\(searc_url.rawValue)\(apikey)\(q_url.rawValue)\(geoposition)"
        }
    }
}
