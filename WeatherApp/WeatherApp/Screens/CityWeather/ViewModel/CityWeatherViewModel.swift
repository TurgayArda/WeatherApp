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
    private var dailyForecastData: [DailyForecast] = []
    private let parsingError = "parsing error"
    
    
    
    init(httpClient: HttpClientProtocol,
         lastSearchManager: LastSearchManagerProtocol) {
        self.httpClient = httpClient
        self.lastSearchManager = lastSearchManager
    }
    
    var backgroundImage = ""
    var temperature = ""
    var weatherPhrase = ""
    var weatherIcon = ""
    var iconNumber = 0
    var fahrenheit = 0
    
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
                guard let dailyForecastDataTwo = forecast.dailyForecasts else {
                    delegate?.forecastHandleOutPut(.showWrongCityForecast(self.parsingError))
                    return
                }
                self.dailyForecastData.removeAll()
                for i in 0...2 {
                    self.dailyForecastData.append(dailyForecastDataTwo[i])
                }
                delegate?.forecastHandleOutPut(.searchForecast(self.dailyForecastData))
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
    
    func calculateCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}

extension CityWeatherViewModel {
    func setupUI(hour: Int) {
        switch hour {
        case 5...18:
            backgroundImage = "Daytime"
            fahrenheit =  dailyForecastData.first?.temperature?.minimum?.value ?? 0
            temperature = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhrase = dailyForecastData.first?.day?.iconPhrase ?? ""
            iconNumber = dailyForecastData.first?.day?.icon ?? 0
            weatherIcon = "Image-\(iconNumber)"
        case 18...24:
            backgroundImage = "NightDay"
            fahrenheit = dailyForecastData.first?.temperature?.maximum?.value ?? 0
            temperature = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhrase = dailyForecastData.first?.night?.iconPhrase ?? ""
            iconNumber = dailyForecastData.first?.night?.icon ?? 0
            weatherIcon = "Image-\(iconNumber)"
        default:
            backgroundImage = "NightDay"
            fahrenheit = dailyForecastData.first?.temperature?.maximum?.value ?? 0
            temperature = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhrase = dailyForecastData.first?.night?.iconPhrase ?? ""
            iconNumber = dailyForecastData.first?.night?.icon ?? 0
            weatherIcon = "Image-\(iconNumber)"
        }
    }
    
    func getBackgroundImage() -> String {
        backgroundImage
    }
    
    func getTemperature() -> String {
        temperature
    }
    
    func getWeatherPhrase() -> String {
        weatherPhrase
    }
    
    func getweatherIcon() -> String {
        weatherIcon
    }
}
