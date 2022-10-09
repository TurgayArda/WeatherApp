//
//  CityWeatherVC.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import UIKit
import Lottie
import CoreLocation

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
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.backgroundColor = .clear
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
        label.adjustsFontSizeToFitWidth = true
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
    
    private lazy var customViewinCollection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 48
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = .white
        return view
    }()
    
    
    private lazy var weatherForecast: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "Weather Forecast"
        //label.backgroundColor = .clear
        return label
    }()
    
    private lazy var forecastCollectionView: UICollectionView = {
             let layout = UICollectionViewFlowLayout()
             layout.scrollDirection = .horizontal
             let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
             collectionView.translatesAutoresizingMaskIntoConstraints = false
             collectionView.backgroundColor = .white
            collectionView.register(
                CityWeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: CityWeatherCollectionViewCell.Identifier.path.rawValue
                                   )
             return collectionView
         }()
    
    private lazy var locatoinManager = CLLocationManager()
     
    //MARK: - Properties
    private var forecastCollectionProvider = CityWeatherProvider()
    private var dailyForecastData: [DailyForecast] = []
    private var searchCityName = ""
    private var searchDateTime = ""
    private var currentLocation: CLLocation?
    
    var cityWeatherViewModel: CityWeatherViewModelProtocol?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initDelegate()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupLocation()
    }
    
    //MARK: - Private Func
    
    private func setupLocation() {
        locatoinManager.delegate = self
        locatoinManager.requestWhenInUseAuthorization()
        locatoinManager.startUpdatingLocation()
    }
    
    private func initDelegate() {
        navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        cityWeatherViewModel?.delegate = self
        //forecastCollectionProvider.delegate = self
        forecastCollectionView.delegate = forecastCollectionProvider
        forecastCollectionView.dataSource = forecastCollectionProvider
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .white
        view.addSubview(viewBackGroundImage)
        view.addSubview(cityVerticalLocationStackView)
        view.addSubview(cityVerticalWeatherInfoStackView)
        view.addSubview(customViewinCollection)

        cityVerticalLocationStackView.addArrangedSubview(cityHorizontalLocationStackView)
        cityVerticalLocationStackView.addArrangedSubview(dateTime)
        
        cityHorizontalLocationStackView.addArrangedSubview(locationAnimationView)
        cityHorizontalLocationStackView.addArrangedSubview(cityName)
        
        cityVerticalWeatherInfoStackView.addArrangedSubview(cityHorizontalWeatherInfoStackView)
        cityVerticalWeatherInfoStackView.addArrangedSubview(weatherPhrase)
        
        cityHorizontalWeatherInfoStackView.addArrangedSubview(temperature)
        cityHorizontalWeatherInfoStackView.addArrangedSubview(weatherIcon)
        
        customViewinCollection.addSubview(weatherForecast)
        customViewinCollection.addSubview(forecastCollectionView)
        
        viewBackGroundImage.image = UIImage(named: "Daytime")
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        makeCollection()
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
        makeCustomView()
        makeWeatherForecast()
        
        configureAnimation()
    }
    
    private func configureAnimation() {
        locationAnimationView.animationSpeed = 0.7
        locationAnimationView.play()
    }
    
    private func todayDate(dailyForecast: [DailyForecast]) {
        let todayDate = todayDateFormatter.string(from: .now)
        let stringHour = hourDateFormatter.string(from: .now)
        var backgroundImageTwo = UIImage()
        var temperatureTwo = ""
        var weatherPhraseTwo = ""
        var weatherIconTwo = UIImage()
        var iconNumber = 0
        let fahrenheit = dailyForecast[0].temperature?.maximum?.value ?? 0
        let hour = Int(stringHour)!
        
        switch hour {
        case 5...18:
            backgroundImageTwo = UIImage(named:"Daytime")!
            let fahrenheit =  dailyForecast[0].temperature?.minimum?.value ?? 0
            temperatureTwo = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhraseTwo = dailyForecast[0].day?.iconPhrase ?? ""
            iconNumber = dailyForecast[0].day?.icon ?? 0
            weatherIconTwo = UIImage(named: "Image-\(iconNumber)")!
        case 18...24:
            backgroundImageTwo = UIImage(named: "NightDay")!
            temperatureTwo = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhraseTwo = dailyForecast[0].night?.iconPhrase ?? ""
            iconNumber = dailyForecast[0].night?.icon ?? 0
            weatherIconTwo = UIImage(named: "Image-\(iconNumber)")!
        default:
            backgroundImageTwo = UIImage(named:"NightDay")!
            temperatureTwo = "\(calculateCelsius(fahrenheit: fahrenheit))" + "°"
            weatherPhraseTwo = dailyForecast[0].night?.iconPhrase ?? ""
            iconNumber = dailyForecast[0].night?.icon ?? 0
            weatherIconTwo = UIImage(named: "Image-\(iconNumber)")!
        }
        
        DispatchQueue.main.async {
            self.dateTime.text = todayDate
            self.viewBackGroundImage.image = backgroundImageTwo
            self.temperature.text = temperatureTwo
            self.weatherPhrase.text = weatherPhraseTwo
            self.weatherIcon.image = weatherIconTwo
        }
    }
    
    func calculateCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}

extension CityWeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locatoinManager.startUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else { return }
        let longLocation = currentLocation.coordinate.longitude
        let latLocation = currentLocation.coordinate.latitude
        
        cityWeatherViewModel?.loadGeoposition(geoposition: "\(latLocation),\(longLocation)")
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
            todayDate(dailyForecast: forecastData)
            dailyForecastData.removeAll()
            for i in 0...2 {
                dailyForecastData.append(forecastData[i])
            }
            forecastCollectionProvider.load(value: dailyForecastData)
            
            DispatchQueue.main.async {
                self.forecastCollectionView.reloadData()
            }
        case .showError(let error):
            print(error)
        }
    }
    
    func geopositionHandleOutPut(_ output: GeopositionViewModelOutPut) {
        switch output {
        case .searchGeoposition(let geoposition):
            guard let key = geoposition.key, let cityName = geoposition.administrativeArea?.englishName else { return }
            cityWeatherViewModel?.loadForecast(key: key)
            cityWeatherViewModel?.loadSearchCity(term: cityName)
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
        //cityWeatherViewModel?.loadSearchCity(term: "")
    }
}

//extension CityWeatherVC: CityWeatherProviderDelegate {
//    func selected(at select: Any) {
//        print("Arda")
//    }
//}

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
            cityVerticalWeatherInfoStackView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 9),
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
            weatherPhrase.leftAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.leftAnchor, constant: 8),
            weatherPhrase.rightAnchor.constraint(equalTo: cityVerticalWeatherInfoStackView.rightAnchor, constant: 0),
        ])
    }

    private func makeCustomView() {
        NSLayoutConstraint.activate([
            customViewinCollection.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2.6),
            customViewinCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            customViewinCollection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            customViewinCollection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
        ])
    }
    
    private func makeWeatherForecast() {
        NSLayoutConstraint.activate([
            weatherForecast.topAnchor.constraint(equalTo: customViewinCollection.topAnchor, constant: 48),
            weatherForecast.leftAnchor.constraint(equalTo: customViewinCollection.leftAnchor, constant: 0),
            weatherForecast.rightAnchor.constraint(equalTo: customViewinCollection.rightAnchor, constant: 0),
        ])
    }
    
    private func makeCollection() {
        NSLayoutConstraint.activate([
            forecastCollectionView.topAnchor.constraint(equalTo: weatherForecast.bottomAnchor, constant: 48),
            forecastCollectionView.leftAnchor.constraint(equalTo: customViewinCollection.leftAnchor, constant: 0),
            forecastCollectionView.rightAnchor.constraint(equalTo: customViewinCollection.rightAnchor, constant: 0),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 5),
        ])
    }
   
}
