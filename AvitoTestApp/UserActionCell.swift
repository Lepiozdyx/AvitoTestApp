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
    
    func configure(with list: List) {
        titleLabel.text = list.title
        descriptionLabel.text = list.description
        priceLabel.text = list.price
        
        if let url = URL(string: list.icon.image) {
            fetchImage(form: url)
        }
    }
}

// MARK: - Networking
extension UserActionCell {
    func fetchImage(form url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.imageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }.resume()
    }
}
