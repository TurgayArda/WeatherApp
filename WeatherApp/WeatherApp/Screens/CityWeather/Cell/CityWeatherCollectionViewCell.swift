//
//  CityWeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import UIKit

class CityWeatherCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    
    private lazy var  weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        return image
    }()
    
    private lazy var  weatherDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    private lazy var weathertemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    enum Identifier: String {
        case path = "Cell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(weatherIcon)
        stackView.addArrangedSubview(weatherDate)
        stackView.addArrangedSubview(weathertemperature)
        
        
//        contentView.backgroundColor = .white
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.gray.cgColor
//        contentView.layer.cornerRadius = 8
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeImage()
        makeVStack()
        makeTemperature()
        makeDate()
    }
    
    private func propertyUI(item: DailyForecast) {
        guard let date = item.date , let temperature = item.temperature?.minimum?.value, let image = item.day?.icon else { return }
//
        weatherDate.text = date
        weathertemperature.text = "\(temperature)" + "°"
        weatherIcon.image = UIImage(named: "Image-\(image)")
    }
    
    func saveModel(item: DailyForecast) {
        propertyUI(item: item)
    }
}

//MARK: - Constraints

extension  CityWeatherCollectionViewCell {
    private func makeVStack() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
    
    private func makeImage() {
        NSLayoutConstraint.activate([
            weatherIcon.heightAnchor.constraint(equalToConstant: contentView.frame.size.height / 3.2),
            weatherIcon.widthAnchor.constraint(equalToConstant: contentView.frame.size.width / 1.5),
        ])
    }
    
    private func makeDate() {
        NSLayoutConstraint.activate([
            //weatherDate.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 0),
            weatherDate.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            weatherDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
    
    private func makeTemperature() {
        NSLayoutConstraint.activate([
            //weathertemperature.topAnchor.constraint(equalTo: weatherDate.bottomAnchor, constant: 0),
            weathertemperature.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            weathertemperature.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
}
