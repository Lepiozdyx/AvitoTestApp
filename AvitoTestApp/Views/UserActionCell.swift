//
//  UserActionCell.swift
//  AvitoTestApp
//
//  Created by Alex on 16.08.2023.
//

import UIKit

final class UserActionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "userAction"
    private let networkManager = NetworkManager.shared
    
    func configure(with list: List) {
        titleLabel.text = list.title
        descriptionLabel.text = list.description
        priceLabel.text = list.price
        
        imageView.image = UIImage(systemName: "photo.circle")
        
        networkManager.fetchImage(from: list.icon.imageUrl) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}
