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
    
    private let searchController = UISearchController()
    private var isFiltred = false
    
    private var filtredArray = [IndexPath]()
    private var heroesArray = [HeroMarvelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setDelegates()
        setConstraints()
        getHeroesArray()
    }
    
    private func getHeroesArray() {
        NetworkDataFetch.shared.fetchHero { [weak self] heroMarvelArray, error in
            guard let self = self else { return } // проверяем есть ли ссылка
            if error != nil {
                print("error")
            } else {
                guard let heroMarvelArray = heroMarvelArray else { return }
                self.heroesArray = heroMarvelArray
                
                self.mainCollectionView.reloadData()
            }
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(mainCollectionView)
        
        mainCollectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.collectionViewCellID)
    }
    
    private func setupNavigationBar() {
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        navigationItem.titleView = createCustomTitle()
        
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backButtonTitle = ""
    }
    
    private func setDelegates() {
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.delegate = self
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
    
    private func setAlphaForCell(alpha: Double) {
        mainCollectionView.visibleCells.forEach { cell in
            cell.alpha = alpha
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.collectionViewCellID, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        
        let model = heroesArray[indexPath.row]
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
        
        let model = heroesArray[indexPath.row]
        let detailsVC = DetailsViewController()
        
        detailsVC.heroModel = model
        detailsVC.heroArray = heroesArray
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if isFiltred {
            cell.alpha = (filtredArray.contains(indexPath) ? 1 : 0.3)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        for (value, hero) in marvelHero.enumerated() {
            let indexPath: IndexPath = [0, value]
            let cell = mainCollectionView.cellForItem(at: indexPath)
            
            if hero.name.lowercased().contains(searchText.lowercased()) {
                
                filtredArray.append(indexPath)
                
                cell?.alpha = 1
                
                mainCollectionView.reloadData()
            } else {
                cell?.alpha = 0.3
            }
        }
    }
}

// MARK: - UISearchControllerDelegate

extension CollectionViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        isFiltred = true
        setAlphaForCell(alpha: 0.3)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        isFiltred = false
        setAlphaForCell(alpha: 1)
    }
}

// MARK: - SetConstraints

extension CollectionViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


