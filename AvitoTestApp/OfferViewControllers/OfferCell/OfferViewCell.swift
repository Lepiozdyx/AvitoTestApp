//
//  OfferViewCell.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
//

import UIKit

final class OfferViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmarkImage: UIImageView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let reuseIdentifier = "userAction"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTintColor()
    }
    
    func configure(with viewModel: OfferCellViewModelProtocol) {
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
    
    private func setTintColor() {
        checkmarkImage.tintColor = UIColor(named: "AvitoBlue")
    }
    
}
