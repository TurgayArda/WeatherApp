//
//  CityWeatherVC.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import UIKit
import Lottie

class CityWeatherVC: UIViewController {

    //MARK: - Views
    
    private lazy var  viewBackGroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.sizeToFit()
        image.backgroundColor = .green
        return image
    }()
    
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "search Podcast"
        search.searchBar.showsCancelButton = true
        return search
    }()
    
//    private lazy var searchListCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .systemGray6
//        collectionView.register(
//            SearchListPodcastCollectionViewCell.self,
//            forCellWithReuseIdentifier: SearchListPodcastCollectionViewCell.Identifier.path.rawValue
//        )
//        return collectionView
//    }()
    
    private let cityHorizontalLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    
    private lazy var  cityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var  dateTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cityVerticalLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .firstBaseline
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        return stackView
    }()
   
    
    private lazy var locationAnimationView: AnimationView = {
        var animation = AnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation = .init(name: "location")
        animation.backgroundColor  = .clear
        return animation
    }()
    
    private var todayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter
    }()
    
    private var hourDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    private lazy var temperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "27.5"
        return label
    }()
    
    private lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        return image
    }()
    
    private lazy var weatherPhrase: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.text = "Mostly cloudy"
        return label
    }()
    
    private let cityHorizontalWeatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .lastBaseline
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    private let cityVerticalWeatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .lastBaseline
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    
     
    //MARK: - Properties
    
    private var searchCityName = ""
    private var searchDateTime = ""
    
    var cityWeatherViewModel: CityWeatherViewModelProtocol?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDelegate()
    }
    
    //MARK: - Private Func
    
    private func initDelegate() {
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        cityWeatherViewModel?.delegate = self
//        searchCollectionProvider.delegate = self
//        searchListCollectionView.delegate = searchCollectionProvider
//        searchListCollectionView.dataSource = searchCollectionProvider
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(viewBackGroundImage)
        view.addSubview(cityVerticalLocationStackView)
        view.addSubview(cityVerticalWeatherInfoStackView)
        //view.addSubview(searchListCollectionView)
    
        cityVerticalLocationStackView.addArrangedSubview(cityHorizontalLocationStackView)
        cityVerticalLocationStackView.addArrangedSubview(dateTime)
        
        cityHorizontalLocationStackView.addArrangedSubview(locationAnimationView)
        cityHorizontalLocationStackView.addArrangedSubview(cityName)
        
        cityVerticalWeatherInfoStackView.addArrangedSubview(cityHorizontalWeatherInfoStackView)
        cityVerticalWeatherInfoStackView.addArrangedSubview(weatherPhrase)
        
        cityHorizontalWeatherInfoStackView.addArrangedSubview(temperature)
        cityHorizontalWeatherInfoStackView.addArrangedSubview(weatherIcon)
        
        viewBackGroundImage.image = UIImage(named: "Daytime")
        weatherIcon.image = UIImage(systemName: "sun.min")
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        //makeCollection()
        makeBackGroundImage()
        makeLocationStackView()
        makeAnimationView()
        makeCityName()
        makeDateTimeStackView()
        makeDateTime()
        makeWeatherInfoVerticalStackView()
        makeWeatherInfoHorizontalStackView()
        makeTemperature()
        makeWeatherIcon()
        makeWeatherPhrase()
        
        configureAnimation()
    }
    
    private func configureAnimation() {
        //locationAnimationView = .init(name: "location")
        //locationAnimationView.contentMode = .scaleAspectFit
        //locationAnimationView.loopMode = .loop
        locationAnimationView.animationSpeed = 0.7
        locationAnimationView.play()
        
        todayDate()
    }
    
    private func todayDate() {
        let todayDate = todayDateFormatter.string(from: .now)
        dateTime.text = todayDate
        
        let stringHour = hourDateFormatter.string(from: .now)
        let hour = Int(stringHour)!
        
        switch hour {
        case 5...18:
            self.viewBackGroundImage.image = UIImage(named:"Daytime")
        case 18...24:
            self.viewBackGroundImage.image = UIImage(named: "NightDay")
        default:
            self.viewBackGroundImage.image = UIImage(named:"NightDay")
        }
    }
}

extension CityWeatherVC: CityWeatherViewModelDelegate {
    func handleOutPut(_ output: CityWeatherViewModelOutPut) {
        switch output {
        case .showCityWeather(let cityWeather):
            searchCityName = cityWeather[0].localizedName ?? ""
            DispatchQueue.main.async {
                self.cityName.text = cityWeather[0].localizedName ?? ""
            }
            guard let key = cityWeather[0].key else { return }
            cityWeatherViewModel?.loadForecast(key: key)
            print(cityWeather[0].localizedName ?? "")
        case .showError(let error):
            print(error)
        }
    }
    
    func forecastHandleOutPut(_ output: ForecastViewModelOutPut) {
        switch output {
        case .searchForecast(let forecastData):
            print(forecastData[0].temperature?.maximum?.value ?? 0.0)
        case .showError(let error):
            print(error)
        }
    }
}

extension CityWeatherVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print(text)
        cityWeatherViewModel?.loadSearchCity(term: text)
        locationAnimationView.play()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cityWeatherViewModel?.loadSearchCity(term: "")
        self.cityName.text = ""
    }
}

extension CityWeatherVC {
    private func makeBackGroundImage() {
        NSLayoutConstraint.activate([
            viewBackGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewBackGroundImage.heightAnchor.constraint(equalToConstant: view.frame.size.height / 1.5),
            viewBackGroundImage.widthAnchor.constraint(equalToConstant: view.frame.size.width),
        ])
    }
    
    private func makeLocationStackView() {
        NSLayoutConstraint.activate([
            cityVerticalLocationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            cityVerticalLocationStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            cityVerticalLocationStackView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 10),
            cityVerticalLocationStackView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2.5),
        ])
    }
    
    private func makeAnimationView() {
        NSLayoutConstraint.activate([
            locationAnimationView.topAnchor.constraint(equalTo: cityHorizontalLocationStackView.topAnchor, constant: 0),
            locationAnimationView.leftAnchor.constraint(equalTo: cityHorizontalLocationStackView.leftAnchor, constant: 8),
            locationAnimationView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 16),
            locationAnimationView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 7),
        ])
    }
    
    private func makeCityName() {
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: cityHorizontalLocationStackView.topAnchor, constant: 0),
            cityName.leftAnchor.constraint(equalTo: locationAnimationView.rightAnchor, constant: 8),
        ])
    }
    
    private func makeDateTimeStackView() {
        NSLayoutConstraint.activate([
            cityHorizontalLocationStackView.topAnchor.constraint(equalTo: cityVerticalLocationStackView.bottomAnchor, constant: 0),
            cityHorizontalLocationStackView.leftAnchor.constraint(equalTo: cityVerticalLocationStackView.leftAnchor, constant: 0),
            cityHorizontalLocationStackView.rightAnchor.constraint(equalTo: cityVerticalLocationStackView.rightAnchor, constant: 0),
        ])
    }
    
    private func makeDateTime() {
        NSLayoutConstraint.activate([
            dateTime.topAnchor.constraint(equalTo: cityHorizontalLocationStackView.bottomAnchor, constant: 0),
            dateTime.leftAnchor.constraint(equalTo: cityVerticalLocationStackView.leftAnchor, constant: 8 + (view.frame.size.width / 14)),
            dateTime.rightAnchor.constraint(equalTo: cityVerticalLocationStackView.rightAnchor, constant: 0),
        ])
    }
    
    private func makeWeatherInfoVerticalStackView() {
        NSLayoutConstraint.activate([
            cityVerticalWeatherInfoStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 88),
            cityVerticalWeatherInfoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            cityVerticalWeatherInfoStackView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 10),
            cityVerticalWeatherInfoStackView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2.5),
        ])
    }
    
    private func makeWeatherInfoHorizontalStackView() {
        NSLayoutConstraint.activate([
            cityHorizontalWeatherInfoStackView.topAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.bottomAnchor, constant: 0),
            cityHorizontalWeatherInfoStackView.leftAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.leftAnchor, constant: 0),
            cityHorizontalWeatherInfoStackView.rightAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.rightAnchor, constant: 0),
        ])
    }
    
    private func makeWeatherIcon() {
        NSLayoutConstraint.activate([
            weatherIcon.topAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.topAnchor, constant: 0),
            weatherIcon.leftAnchor.constraint(equalTo: temperature.rightAnchor, constant: 8),
            weatherIcon.heightAnchor.constraint(equalToConstant: view.frame.size.height / 16),
            temperature.widthAnchor.constraint(equalToConstant: view.frame.size.width / 7),
        ])
    }
    
    private func makeTemperature() {
        NSLayoutConstraint.activate([
            temperature.topAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.topAnchor, constant: 0),
            temperature.leftAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.leftAnchor, constant: 8),
        ])
    }
    
    private func makeWeatherPhrase() {
        NSLayoutConstraint.activate([
            weatherPhrase.topAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.bottomAnchor, constant: 0),
            weatherPhrase.leftAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.leftAnchor, constant: 8 + (view.frame.size.width / 14)),
            weatherPhrase.rightAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.rightAnchor, constant: 0),
        ])
    }
}
