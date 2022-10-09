//
//  CityWeatherProvider.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import UIKit

class CityWeatherProvider: NSObject, CityWeatherProviderProtocol {
    var delegate: CityWeatherProviderDelegate?
    var dailyForecastData: [DailyForecast] = []
}

extension CityWeatherProvider {
    func load(value: [DailyForecast]) {
        self.dailyForecastData = value
    }
}

extension CityWeatherProvider: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyForecastData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as? CityWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.cellViewModel = CityWeatherCollectionCellViewModel()
       
        cell.saveModel(item: dailyForecastData[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let with = collectionView.bounds.width
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: with / 10, bottom: 10, right: with / 10)
//        flowLayout.minimumInteritemSpacing = 20
//        flowLayout.minimumLineSpacing = 20
        let width = (with / 4)
        let height = width * 1
        return CGSize(width: width, height: height)
    }
}
