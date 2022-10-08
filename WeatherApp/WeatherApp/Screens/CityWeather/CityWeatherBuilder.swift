//
//  CityWeatherBuilder.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

final class CityWeatherBuilder {
    static func make() -> CityWeatherVC {
        let view = CityWeatherVC()
        view.cityWeatherViewModel = CityWeatherViewModel(httpClient: HttpClient())
        return view
    }
}
