//
//  someCollectionViewCell.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    static let collectionViewCellID = "collectionViewCellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    override func prepareForReuse() {
        self.cellImageView.image = nil
    }
    
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(cellImageView)
    }
    
    func cellConfigure(model: HeroMarvelModel) {
        guard let url = model.thumbnail.url else { return }
        
        NetworkImageFetch.shared.requestImage(url: url) { [weak self] result in
            
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.cellImageView.image = image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
