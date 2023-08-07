//
//  CollectionViewController.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import UIKit

class CollectionViewController: UIViewController {
    
    private var marvelHero = [
        HeroModel(image: "black",
                  name: "Черная пантера",
                  description: "человек"),
        HeroModel(image: "cap",
                  name: "Капитан америка",
                  description: "человек"),
        HeroModel(image: "dead",
                  name: "Дедпул",
                  description: "супер человек"),
        HeroModel(image: "doc",
                  name: "Доктор стрендж",
                  description: "фокусник"),
        HeroModel(image: "groot",
                  name: "Грут",
                  description: "дерево"),
        HeroModel(image: "hulk",
                  name: "Халк",
                  description: "Халк"),
        HeroModel(image: "iron",
                  name: "Железный человек",
                  description: "А я так, просто, железный человек"),
        HeroModel(image: "spider",
                  name: "Человек паук",
                  description: "дружилюбный сосед"),
        HeroModel(image: "thor",
                  name: "Тор",
                  description: "БОГ"),
        HeroModel(image: "vision",
                  name: "Вижн",
                  description: "супер ИИ")
    ]
    
    private let mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let searchContoller = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setDelegates()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mainCollectionView)
        
        mainCollectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.collectionViewCellID)
    }
    
    private func setupNavigationBar() {
        searchContoller.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchContoller
        navigationItem.titleView = createCustomTitle()
        
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonTitle = ""
    }
    
    private func setDelegates() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
    }
    
    private func createCustomTitle() -> UIView {
        let view = UIView()
        
        let heightNavBar = navigationController?.navigationBar.frame.height ?? 0
        let widthNavBar = navigationController?.navigationBar.frame.width ?? 0
        
        view.frame = CGRect(x: 0, y: 0, width: widthNavBar, height: heightNavBar)
        
        let marvelLogoImageView = UIImageView()
        marvelLogoImageView.image = UIImage(named: "logo")
        marvelLogoImageView.contentMode = .left
        marvelLogoImageView.frame = CGRect(x: 10, y: 0, width: widthNavBar, height: heightNavBar)
        
        view.addSubview(marvelLogoImageView)
        return view
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        marvelHero.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.collectionViewCellID, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        
        let model = marvelHero[indexPath.row]
        cell.cellConfigure(model: model)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width / 3.02,
               height: collectionView.frame.width / 3.02)
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = marvelHero[indexPath.row]
        let detailsVC = DetailsViewController()
        
        detailsVC.heroModel = model
        detailsVC.heroArray = marvelHero
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - SetConstraints

extension CollectionViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            mainCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }
}

