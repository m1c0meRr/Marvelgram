//
//  CollectionViewController.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import UIKit

class CollectionViewController: UIViewController {
    
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
    private var filtredHeroArray = [HeroMarvelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHeroesArray()
        setupViews()
        setupNavigationBar()
        setDelegates()
        setConstraints()
    }
    
    private func getHeroesArray() {
        NetworkDataFetch.shared.fetchHero { [weak self] heroData, error in
            guard let self = self else { return } // проверяем есть ли ссылка
            if error != nil {
                print("error")
            } else {
                guard let heroData = heroData else { return }
                self.heroesArray = heroData
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
        searchController.searchBar.delegate = self
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
    
    private func refreshData() {
        
        isFiltred = false
        setAlphaForCell(alpha: 1)
        filtredHeroArray.removeAll()
        mainCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        isFiltred ? filtredHeroArray.count : heroesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.collectionViewCellID, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
        
        let model = isFiltred ? filtredHeroArray[indexPath.row] : heroesArray[indexPath.row]
        
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
        
        let model = isFiltred ? filtredHeroArray[indexPath.row] : heroesArray[indexPath.row]
        let detailsVC = DetailsViewController()
        
        detailsVC.heroModel = model
        detailsVC.heroArray = heroesArray
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if self.mainCollectionView.visibleCells.contains(cell) {
                if self.isFiltred {
                    cell.alpha = (self.filtredArray.contains(indexPath) ? 1 : 0.3)
                }
            }
        }
    }
}

// MARK: - UISearchControllerDelegate

extension CollectionViewController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        filtredHeroArray = heroesArray
        isFiltred = true
        setAlphaForCell(alpha: 0.3)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        refreshData()
    }
}

extension CollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filterContentForSearchText(text)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        for (value, hero) in filtredHeroArray.enumerated() {
            let indexPath: IndexPath = [0, value]
            guard let cell = mainCollectionView.cellForItem(at: indexPath) else { return }
            
            if hero.name.lowercased().contains(searchText.lowercased()) {
                filtredArray.removeAll()
                filtredArray.append(indexPath)
                
                let firstHero = filtredHeroArray.startIndex
                filtredHeroArray.swapAt(value, firstHero)
                
                mainCollectionView.reloadData()
                
                cell.alpha = 1
            } else {
                cell.alpha = 0.3
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension CollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltred = (searchText.count > 0 ? true : false)
        setAlphaForCell(alpha: 0.3)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refreshData()
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
