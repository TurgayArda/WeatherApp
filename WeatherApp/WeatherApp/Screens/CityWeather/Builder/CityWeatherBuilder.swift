//
//  CityWeatherBuilder.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

final class CityWeatherBuilder {
    static func make() -> CityWeatherVC {
        let client = HttpClient(client: URLSession.shared)
        let viewModel = CityWeatherViewModel(httpClient: client,
                                             lastSearchManager: LastSearchManager())
        let view = CityWeatherVC(viewModel: viewModel)
        return view
    }
}
