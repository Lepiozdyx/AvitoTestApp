//
//  MainViewController.swift
//  AvitoTestApp
//
//  Created by Alex on 16.08.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: Private properties
    private let networkManager = NetworkManager.shared
    private let reuseIdentifier = "userAction"
    private var userActions: [List] = []
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInfo()
    }
    
    // MARK: IB Actions
    @IBAction func selectButtonTapped(_ sender: Any) {
        if let selectedOffer = userActions.first(where: { $0.isSelected }) {
            showAlert(message: "Вы выбрали: \(selectedOffer.title)")
        } else {
            showAlert(message: "Услуга не выбрана")
        }
    }
    
    // MARK: Private methods
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Информация", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
    
    private func updateUI(with offer: Offer) {
        self.titleLabel.text = offer.result.title
        self.userActions = offer.result.list
        self.collectionView.reloadData()
    }

}

// MARK: - Extensions
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        
        let offer = userActions[indexPath.item]
        cell.configure(with: offer)
        
        cell.checkmarkImage.isHidden = !offer.isSelected
            
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userActions[indexPath.item].isSelected {
            userActions[indexPath.item].isSelected = false
        } else {
            for (index, _) in userActions.enumerated() {
                userActions[index].isSelected = false
            }
            userActions[indexPath.item].isSelected = true
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 24, height: 150)
    }
}

// MARK: - Networking
extension MainViewController {
    
    func fetchInfo() {
        networkManager.fetchInfo { [weak self] result in
            switch result {
            case .success(let offer):
                self?.updateUI(with: offer)
            case .failure(let error):
                self?.showAlert(message: "Ошибка: \(error)")
            }
        }
    }
    
}
