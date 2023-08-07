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
    private func setupViews() {
        backgroundColor = .clear
        
        addSubview(cellImageView)
    }
    
    func cellConfigure(model: HeroModel) {
        self.cellImageView.image = UIImage(named: model.image)
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
