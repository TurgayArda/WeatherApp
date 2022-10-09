//
//  GeopositionModel.swift
//  WeatherApp
//
//  Created by Arda Sisli on 9.10.2022.
//

import Foundation

// MARK: - GeopositionResult

struct GeopositionResult: Codable {
    let key: String?
    let administrativeArea: AdministrativeArea?
    
    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case administrativeArea = "AdministrativeArea"
    }
}

// MARK: - AdministrativeArea

struct AdministrativeArea: Codable {
    let localizedName, englishName: String?
  
    enum CodingKeys: String, CodingKey {
        case localizedName = "LocalizedName"
        case englishName = "EnglishName"
    }
}

