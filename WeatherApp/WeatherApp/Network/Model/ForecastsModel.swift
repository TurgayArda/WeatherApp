//
//  ForecastsModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

// MARK: - ForcestResult

struct ForecastResult: Codable {
    let headline: Headline?
    let dailyForecasts: [DailyForecast]?

    enum CodingKeys: String, CodingKey {
        case headline = "Headline"
        case dailyForecasts = "DailyForecasts"
    }
}

// MARK: - DailyForecast

struct DailyForecast: Codable {
    let date: String?
    let epochDate: Int?
    let temperature: Temperature?
    let day, night: Day?
    let sources: [String]?
    let mobileLink, link: String?

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case epochDate = "EpochDate"
        case temperature = "Temperature"
        case day = "Day"
        case night = "Night"
        case sources = "Sources"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
}

// MARK: - Day

struct Day: Codable {
    let icon: Int?
    let iconPhrase: String?
    let hasPrecipitation: Bool?

    enum CodingKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
        case hasPrecipitation = "HasPrecipitation"
    }
}

// MARK: - Temperature

struct Temperature: Codable {
    let minimum, maximum: Imum?

    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

// MARK: - Imum

struct Imum: Codable {
    let value: Int?
    let unit: Unit?
    let unitType: Int?

    enum CodingKeys: String, CodingKey {
        case value = "Value"
        case unit = "Unit"
        case unitType = "UnitType"
    }
}

enum Unit: String, Codable {
    case f = "F"
}

 //MARK: - Headline

struct Headline: Codable {
    let effectiveDate: Date?
    let effectiveEpochDate, severity: Int?
    let text, category: String?
    let mobileLink, link: String?

    enum CodingKeys: String, CodingKey {
        case effectiveDate = "EffectiveDate"
        case effectiveEpochDate = "EffectiveEpochDate"
        case severity = "Severity"
        case text = "Text"
        case category = "Category"
        case mobileLink = "MobileLink"
        case link = "Link"
    }
}
