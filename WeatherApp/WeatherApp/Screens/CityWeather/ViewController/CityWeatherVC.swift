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
        search.searchBar.placeholder = CityWeatherConstant.CityWeaterUIConstant.searchBarPlaceholder.rawValue
        search.searchBar.showsCancelButton = true
        search.searchBar.tintColor = .white
        search.searchBar.barTintColor = .white
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
        label.textAlignment = .center
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
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cityHorizontalWeatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
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
        label.text = CityWeatherConstant.CityWeaterUIConstant.weatherForecast.rawValue
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
            forCellWithReuseIdentifier: CityWeatherCollectionViewCell.reuseIdentifier
                                   )
             return collectionView
         }()
    
    private lazy var lastSearchView: LastSearchView = {
        let view = LastSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var locatoinManager = CLLocationManager()
     
    //MARK: - Properties
    private var forecastCollectionProvider = CityWeatherProvider()
    private var dailyForecastData: [DailyForecast] = []
    private var searchCityName = ""
    private var searchDateTime = ""
    private var currentLocation: CLLocation?
    
    private var cityWeatherViewModel: CityWeatherViewModelProtocol

    
    // MARK: Init
    
    init(viewModel: CityWeatherViewModelProtocol) {
        self.cityWeatherViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        cityWeatherViewModel.delegate = self
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
        configureLastSearchView()
        
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
        makeSearchLastView()
    }
    
    private func configureLastSearchView() {
        view.addSubview(lastSearchView)
        lastSearchView.output = self
        lastSearchView.updateViewModel(viewModel: LastSearchViewModel(lastSearchManager: cityWeatherViewModel.getManager()))
    }
    
    private func configureAnimation() {
        locationAnimationView.animationSpeed = 0.7
        locationAnimationView.play()
    }
    
    private func todayDate(dailyForecast: [DailyForecast]) {
        let todayDate = todayDateFormatter.string(from: .now)
        let stringHour = hourDateFormatter.string(from: .now)
        let hour = Int(stringHour)!
        var backgroundImageString = ""
        var weatherIconString = ""
        
        cityWeatherViewModel.setupUI(hour: hour)
        backgroundImageString = cityWeatherViewModel.getBackgroundImage()
        weatherIconString = cityWeatherViewModel.getweatherIcon()

        
        DispatchQueue.main.async {
            self.dateTime.text = todayDate
            self.viewBackGroundImage.image = UIImage(named: backgroundImageString)
            self.temperature.text = self.cityWeatherViewModel.getTemperature()
            self.weatherPhrase.text = self.cityWeatherViewModel.getWeatherPhrase()
            self.weatherIcon.image = UIImage(named: weatherIconString)
            
        }
    }
}

//MARK: - CLLocationManagerDelegate

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
        
        cityWeatherViewModel.loadGeoposition(geoposition: "\(latLocation),\(longLocation)")
    }
}

//MARK: - CityWeatherViewModelDelegate

extension CityWeatherVC: CityWeatherViewModelDelegate {
    func handleOutPut(_ output: CityWeatherViewModelOutPut) {
        switch output {
        case .showCityWeather(let cityWeather):
            DispatchQueue.main.async {
                self.configureAnimation()
                self.searchCityName = cityWeather.localizedName ?? ""
                self.cityName.text = cityWeather.localizedName ?? ""
                self.setLastSerchVisible(isVisible: true)
            }
            cityWeatherViewModel.loadForecast(key: cityWeather.key ?? "")
        case .showError(let error):
            self.showAlert(error: error,
                           actionTitle: CityWeatherConstant.CityWeatherAlertConstant.errorAction.rawValue)
        case .showWrongCityName(_):
            DispatchQueue.main.async {
                self.lastSearchView.isHidden = true
                self.showAlert(error: CityWeatherConstant.CityWeatherAlertConstant.wrongCityName.rawValue,
                               actionTitle: CityWeatherConstant.CityWeatherAlertConstant.WrongActionTitle.rawValue)
            }
        }
    }
    
    func forecastHandleOutPut(_ output: ForecastViewModelOutPut) {
        switch output {
        case .searchForecast(let forecastData):
            todayDate(dailyForecast: forecastData)
            forecastCollectionProvider.load(value: forecastData)
            
            DispatchQueue.main.async {
                self.forecastCollectionView.reloadData()
            }
        case .showError(let error):
            self.showAlert(error: error,
                           actionTitle: CityWeatherConstant.CityWeatherAlertConstant.errorAction.rawValue)
        case .showWrongCityForecast(_):
            DispatchQueue.main.async {
                self.lastSearchView.isHidden = true
                self.showAlert(error: CityWeatherConstant.CityWeatherAlertConstant.wrongCityKey.rawValue,
                               actionTitle:  CityWeatherConstant.CityWeatherAlertConstant.WrongActionTitle.rawValue)
            }
        }
    }
    
    func geopositionHandleOutPut(_ output: GeopositionViewModelOutPut) {
        switch output {
        case .searchGeoposition(let geoposition):
            guard let key = geoposition.key,
                  let cityName = geoposition.administrativeArea?.englishName else { return }
            cityWeatherViewModel.loadForecast(key: key)
            cityWeatherViewModel.loadSearchCity(term: cityName)
        case .showError(let error):
            showAlert(error: error,
                      actionTitle: CityWeatherConstant.CityWeatherAlertConstant.errorAction.rawValue)
        }
    }
    
    func setLastSerchVisible(isVisible: Bool) {
        DispatchQueue.main.async {
            self.lastSearchView.isHidden = isVisible
        }
    }
}

//MARK: - LastSearchViewOutput

extension CityWeatherVC: LastSearchViewOutput {
    func didSelectCity(name: String) {
        cityWeatherViewModel.loadSearchCity(term: name)
        setLastSerchVisible(isVisible: false)
        self.searchBar.searchBar.resignFirstResponder()
        self.searchBar.searchBar.setShowsCancelButton(true, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension CityWeatherVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        cityWeatherViewModel.loadSearchCity(term: text)
        cityWeatherViewModel.addSearchKey(to: text)
        locationAnimationView.play()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setLastSerchVisible(isVisible: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        lastSearchView.reloadSearchView()
        setLastSerchVisible(isVisible: false)
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

//MARK: - Constraint

extension CityWeatherVC {
    private func makeBackGroundImage() {
        NSLayoutConstraint.activate([
            viewBackGroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            viewBackGroundImage.heightAnchor.constraint(equalToConstant: view.frame.size.height / 1.4),
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
    
    private func makeTemperature() {
        NSLayoutConstraint.activate([
            temperature.topAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.topAnchor, constant: 0),
            temperature.leftAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.leftAnchor, constant: 8),
        ])
    }
    
    private func makeWeatherIcon() {
        NSLayoutConstraint.activate([
            weatherIcon.topAnchor.constraint(equalTo: cityHorizontalWeatherInfoStackView.topAnchor, constant: 0),
            weatherIcon.leftAnchor.constraint(equalTo: temperature.rightAnchor, constant: 0),
            weatherIcon.heightAnchor.constraint(equalToConstant: view.frame.size.height / 22),
            weatherIcon.widthAnchor.constraint(equalToConstant: view.frame.size.width / 5),
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
            customViewinCollection.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2.8),
            customViewinCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            customViewinCollection.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            customViewinCollection.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
        ])
    }
    
    private func makeWeatherForecast() {
        NSLayoutConstraint.activate([
            weatherForecast.topAnchor.constraint(equalTo: customViewinCollection.topAnchor, constant: 36),
            weatherForecast.leftAnchor.constraint(equalTo: customViewinCollection.leftAnchor, constant: 0),
            weatherForecast.rightAnchor.constraint(equalTo: customViewinCollection.rightAnchor, constant: 0),
        ])
    }
    
    private func makeCollection() {
        NSLayoutConstraint.activate([
            forecastCollectionView.topAnchor.constraint(equalTo: weatherForecast.bottomAnchor, constant: 24),
            forecastCollectionView.leftAnchor.constraint(equalTo: customViewinCollection.leftAnchor, constant: 0),
            forecastCollectionView.rightAnchor.constraint(equalTo: customViewinCollection.rightAnchor, constant: 0),
            forecastCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 5),
        ])
    }
    
    private func makeSearchLastView() {
        NSLayoutConstraint.activate([
            lastSearchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lastSearchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lastSearchView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lastSearchView.heightAnchor.constraint(equalToConstant: 232)
        ])
    }
}
