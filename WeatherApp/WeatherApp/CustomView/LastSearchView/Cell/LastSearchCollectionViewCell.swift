//
//  LastSearchCollectionViewCell.swift
//  WeatherApp
//
// Created by Arda Sisli on 8.10.2022.
//

import UIKit

class LastSearchCollectionViewCell: UICollectionViewCell {
    
    private lazy var cityNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContent() {
        contentView.addSubview(cityNameLabel)
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 0),
            cityNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                                 constant: 0),
            cityNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                                  constant: 0),
            cityNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: 0),
        ])
    }
    
    func setCity(with cityName: String) {
        self.cityNameLabel.text = cityName
    }
}
