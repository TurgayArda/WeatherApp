//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

class CityWeatherViewModel: CityWeatherViewModelProtocol {
    var delegate: CityWeatherViewModelDelegate?
    var httpClient: HttpClientProtocol?
    
    init(httpClient: HttpClientProtocol) {
        self.httpClient = httpClient
    }
}

extension CityWeatherViewModel {
    func loadSearchCity(term: String) {
        guard let url = URL(string: WeatherNetworkConstant.WeatherNetwork.weatherURL(cityName: term)) else { return }
        httpClient?.fetch(url: url,
                       completion: { [delegate] (result: Result<[CityWeatherResult], Error>) in
            switch result {
        case .success(let weather):
                delegate?.handleOutPut(.showCityWeather(weather))
        case .failure(let error):
            delegate?.handleOutPut(.showError(error.localizedDescription))
            }
        })
    }
}

extension CityWeatherViewModel {
    func loadForecast(key: String) {
//        guard let cityKey = Int(key) else { return }
//        guard let url = URL(string: WeatherNetworkConstant.ForecastNetwork.forecastURL(key: cityKey)) else { return }
        guard let url = URL(string: WeatherNetworkConstant.ForecastNetwork.forecastURL(key: key)) else { return }
        httpClient?.fetch(url: url,
                          completion: { [delegate] (result: Result<[ForecastResult], Error>) in
            switch result {
        case .success(let forecast):
                if let dailyForecastData = forecast[0].dailyForecasts {
                    delegate?.forecastHandleOutPut(.searchForecast(dailyForecastData))
                }
        case .failure(let error):
                delegate?.forecastHandleOutPut(.showError(error))
            }
        })
    }
}
