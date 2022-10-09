//
//  CityWeatherViewModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

class CityWeatherViewModel: CityWeatherViewModelProtocol {
    var delegate: CityWeatherViewModelDelegate?
    private var httpClient: HttpClientProtocol?
    private var lastSearchManager: LastSearchManagerProtocol
    private let parsingError = "parsing error"
    
    init(httpClient: HttpClientProtocol,
         lastSearchManager: LastSearchManagerProtocol) {
        self.httpClient = httpClient
        self.lastSearchManager = lastSearchManager
    }
}

extension CityWeatherViewModel {
    func loadSearchCity(term: String) {
        guard let url = URL(string: WeatherNetworkConstant.WeatherNetwork.weatherURL(cityName: term)) else { return }
        httpClient?.fetch(url: url,
                          completion: { [delegate] (result: Result<[CityWeatherResult], Error>) in
            switch result {
            case .success(let weather):
                guard let weather = weather.first else {
                    delegate?.handleOutPut(.showWrongCityName(self.parsingError))
                    return
                }
                delegate?.handleOutPut(.showCityWeather(weather))
        case .failure(let error):
            delegate?.handleOutPut(.showError(error.localizedDescription))
            }
        })
    }
    
    func loadForecast(key: String) {
        guard let url = URL(string: WeatherNetworkConstant.ForecastNetwork.forecastURL(key: key)) else { return }
        httpClient?.fetch(url: url,
                          completion: { [delegate] (result: Result<ForecastResult, Error>) in
            switch result {
            case .success(let forecast):
                guard let dailyForecastData = forecast.dailyForecasts else {
                    delegate?.forecastHandleOutPut(.showWrongCityForecast(self.parsingError))
                    return
                }
                    delegate?.forecastHandleOutPut(.searchForecast(dailyForecastData))
            case .failure(let error):
                delegate?.forecastHandleOutPut(.showError(error.localizedDescription))
            }
        })
    }
    
    func loadGeoposition(geoposition: String) {
        guard let url = URL(string: WeatherNetworkConstant.GeopositionNetwork.geopositionURL(geoposition: geoposition)) else { return }
        httpClient?.fetch(url: url,
                          completion: { [delegate] (result: Result<GeopositionResult, Error>) in
            switch result {
            case .success(let geoposition):
                delegate?.geopositionHandleOutPut(.searchGeoposition(geoposition))
            case .failure(let error):
                delegate?.geopositionHandleOutPut(.showError(error.localizedDescription))
            }
        })
    }
    
    func addSearchKey(to name: String) {
        lastSearchManager.addValue(value: name)
    }
    
    func getManager() -> LastSearchManagerProtocol {
        lastSearchManager
    }
}
