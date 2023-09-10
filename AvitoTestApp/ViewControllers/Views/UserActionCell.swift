//
//  UserActionCell.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkmarkImage.tintColor = UIColor(named: "AvitoBlue")
    }
    
    func configure(with viewModel: UserActionCellViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = viewModel.price
        
        viewModel.fetchImage { [weak self] data in
            DispatchQueue.main.async {
                if let imageData = data {
                    self?.imageView.image = UIImage(data: imageData)
                } else {
                    self?.imageView.image = UIImage(systemName: "photo.circle")
                }
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
