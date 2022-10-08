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
        stackView.alignment = .lastBaseline
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        return stackView
    }()
    
    
    private lazy var  searchImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.backgroundColor = .white
        image.layer.cornerRadius = 8
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return image
    }()
    
    private lazy var  searchName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var  searchPrice: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .black
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
    
    override func prepareForReuse() {
        setImage(value: "")
    }
    
    private func setImage(value: String) {
        if let url = URL(string: value) {
            DispatchQueue.global().async {
                let data  = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    guard let dataTwo = data else { return }
                    self.searchImage.image = UIImage(data: dataTwo)
                }
            }
        }
    }
    
    private func configure() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(searchImage)
        stackView.addArrangedSubview(searchName)
        stackView.addArrangedSubview(searchPrice)
        
        
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeImage()
        makeVStack()
        makeName()
        makePrice()
    }
    
//    private func propertyUI(item: SearchList) {
//        guard let name = item.trackName, let price = item.trackPrice, let image = item.artworkUrl100 else { return }
//        
//        searchName.text = "Name: \(name)"
//        searchPrice.text = "Price: \(price)"
//        setImage(value: image)
//    }
//    
//    func saveModel(item: SearchList) {
//        propertyUI(item: item)
//    }
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
            searchImage.heightAnchor.constraint(equalToConstant: contentView.frame.size.height / 1.6),
            searchImage.widthAnchor.constraint(equalToConstant: contentView.frame.size.width),
        ])
    }
    
    private func makeName() {
        NSLayoutConstraint.activate([
            searchName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            searchName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
    
    private func makePrice() {
        NSLayoutConstraint.activate([
            searchPrice.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            searchPrice.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
        ])
    }
}
