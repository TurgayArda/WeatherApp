//
//  LastSearchViewModel.swift
//  WeatherApp
//
// Created by Arda Sisli on 8.10.2022.//

import Foundation

protocol LastSearchViewModelProtocol {
    func getCitysName() -> [String]
    func getCityCount() -> Int
}

struct LastSearchViewModel: LastSearchViewModelProtocol {
    
    private var lastSearchManager: LastSearchManagerProtocol
    private var lastSearchData: [String] = []
    
    init(lastSearchManager: LastSearchManagerProtocol) {
        self.lastSearchManager = lastSearchManager
    }
    
    func getCitysName() -> [String] {
        lastSearchManager.getValue()
    }
    
    func getCityCount() -> Int {
        lastSearchManager.getValue().count
    }
}
