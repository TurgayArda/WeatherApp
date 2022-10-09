//
//  LastSearchView.swift
//  WeatherApp
//
// Created by Arda Sisli on 8.10.2022.
//

import UIKit

protocol LastSearchViewOutput {
    func didSelectCity(name: String)
}

class LastSearchView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(LastSearchCollectionViewCell.self,
                                forCellWithReuseIdentifier: LastSearchCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private var viewModel: LastSearchViewModelProtocol?
    var output: LastSearchViewOutput?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupContent()
    }
    
    func updateViewModel(viewModel: LastSearchViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    private func setupContent() {
        backgroundColor = .white
        layer.opacity = 0.8
        isHidden = true
        setupCosntraints()
    }
    
    
    private func setupCosntraints() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        self.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: 16),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor,
                                                 constant: 16),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor,
                                                  constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -16),
        ])
    }
    
    func reloadSearchView() {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getCityCount() ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastSearchCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? LastSearchCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setCity(with: viewModel?.getCitysName()[indexPath.row] ?? "")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 32 ,
                      height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output?.didSelectCity(name: viewModel?.getCitysName()[indexPath.row] ?? "")
    }
}
