//
//  DetailsViewController.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let detailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel = UILabel(text: "",
                                           font: .systemFont(ofSize: 12)) // посмотреть фигму
    
    private let exploreMoreLabel = UILabel(text: "Explore more",
                                           font: .systemFont(ofSize: 25)) // посмотреть фигму
    
    private let randomCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15 // посмотреть фигму
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var heroModel: HeroMarvelModel?
    var heroArray = [HeroMarvelModel]()
    var randomArray = [HeroMarvelModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupHeroInfo()
        setupRandom()
        setDelegates()
        setConstraints()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(detailsImageView)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(exploreMoreLabel)
        scrollView.addSubview(randomCollectionView)
        
        randomCollectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.collectionViewCellID)
    }
    
    private func setupHeroInfo() {
        guard let heroModel = heroModel else { return }
        title = heroModel.name
        descriptionLabel.text = heroModel.description
        if descriptionLabel.text == "" {
            descriptionLabel.text = "The data on this hero is classified as 'TOP SECRET'"
        }
        
        guard let url = heroModel.thumbnail.url else { return }
        NetworkImageFetch.shared.requestImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
                
            case .success(let data):
                let image = UIImage(data: data)
                self.detailsImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupRandom() {
        while randomArray.count < 10 {
            
            let randomInt = Int.random(in: 0...heroArray.count - 1)
            randomArray.append(heroArray[randomInt])
            let someSet = Set(randomArray)
            randomArray = Array(someSet)
        }
    }
    
    private func setDelegates() {
        randomCollectionView.dataSource = self
        randomCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        randomArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.collectionViewCellID, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell()}
        
        let model = randomArray[indexPath.row]
        cell.cellConfigure(model: model)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width / 3,
               height: collectionView.frame.width / 3)
    }
}

// MARK: - UICollectionViewDelegate

extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = randomArray[indexPath.row]
        let detailsVC = DetailsViewController()
        
        detailsVC.heroModel = model
        detailsVC.heroArray = heroArray
        
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - setConstraints

extension DetailsViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            detailsImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            detailsImageView.widthAnchor.constraint(equalToConstant: view.frame.width),
            detailsImageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            
            descriptionLabel.topAnchor.constraint(equalTo: detailsImageView.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            exploreMoreLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            exploreMoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            exploreMoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            randomCollectionView.topAnchor.constraint(equalTo: exploreMoreLabel.bottomAnchor, constant: 5),
            randomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            randomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            randomCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            randomCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10)
        ])
    }
}
