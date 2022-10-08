//
//  SearchCityWeatherModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

// MARK: - CityWeatherResult

struct CityWeatherResult: Codable {
    let version: Int?
    let key, type: String?
    let rank: Int?
    let localizedName, englishName: String?

    enum CodingKeys: String, CodingKey {
        case version = "Version"
        case key = "Key"
        case type = "Type"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}



