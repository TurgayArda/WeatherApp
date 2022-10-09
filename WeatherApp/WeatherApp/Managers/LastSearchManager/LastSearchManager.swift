//
//  LastSearchManager.swift
//  WeatherApp
//
// Created by Arda Sisli on 8.10.2022.

import Foundation

protocol LastSearchManagerProtocol {
    
    func addValue(value: String)
    func getValue() -> [String]
    func clearAllValues()
}

class LastSearchManager: LastSearchManagerProtocol {
    
    private var defaults: UserDefaults
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    func addValue(value: String) {
        if let lastedArray = defaults.stringArray(forKey: "asd") {
            addValueToUserDefault(array: lastedArray, value: value)
        } else {
            var array: [String] = []
            array.append(value)
            addValueToUserDefault(array: array, value: value)
        }
    }
    
    private func addValueToUserDefault(array: [String], value: String) {
        var cityNames = array
        if !cityNames.contains(value) {
            cityNames.append(value)
            if cityNames.count > 5 {
                cityNames.removeFirst()
            }
        }

        defaults.set(cityNames, forKey: "asd")
    }
    
    func getValue() -> [String] {
        return defaults.stringArray(forKey: "asd") ?? []
    }
    
    
    func clearAllValues() {
        defaults.removeObject(forKey: "asd")
    }
}
