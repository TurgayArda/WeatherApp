//
//  CityWeatherContracts.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

//MARK: - ViewModel

protocol CityWeatherViewModelProtocol {
    var delegate: CityWeatherViewModelDelegate? { get set }
    func loadSearchCity(term: String)
    func loadForecast(key: String)
    func loadGeoposition(geoposition: String)
    func getManager() -> LastSearchManagerProtocol
    func addSearchKey(to name: String)
    func setupUI(hour: Int)
    func getBackgroundImage() -> String
    func getTemperature() -> String
    func getWeatherPhrase() -> String
    func getweatherIcon() -> String
}

enum CityWeatherViewModelOutPut {
    case showCityWeather(CityWeatherResult)
    case showWrongCityName(String)
    case showError(String)
}

enum ForecastViewModelOutPut {
    case searchForecast([DailyForecast])
    case showWrongCityForecast(String)
    case showError(String)
}

enum GeopositionViewModelOutPut {
    case searchGeoposition(GeopositionResult)
    case showError(String)
}

protocol CityWeatherViewModelDelegate {
    func handleOutPut(_ output: CityWeatherViewModelOutPut)
    func forecastHandleOutPut(_ output: ForecastViewModelOutPut)
    func geopositionHandleOutPut(_ output: GeopositionViewModelOutPut)
}

//MARK: - Provider

protocol CityWeatherProviderProtocol {
    var delegate: CityWeatherProviderDelegate? { get set }
    func load(value: [DailyForecast])
}

protocol CityWeatherProviderDelegate {
    func selected(at select: Any)
}
