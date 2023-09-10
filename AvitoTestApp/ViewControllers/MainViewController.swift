//
//  MainViewController.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: Private properties
    private let viewModel = MainViewModel()
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInfo()
        selectButton.tintColor = UIColor(named: "AvitoBlue")
    }
    
    // MARK: IB Actions
    @IBAction func selectButtonTapped(_ sender: Any) {
        if let selectedOffer = viewModel.list.first(where: { $0.isSelected }) {
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
    
    private func updateUI() {
        self.titleLabel.text = viewModel.title
        self.collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserActionCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? UserActionCell else { return UICollectionViewCell() }
        
        let listModel = viewModel.list[indexPath.item]
        let cellViewModel = UserActionCellViewModel(list: listModel)
        cell.configure(with: cellViewModel)

        cell.checkmarkImage.isHidden = !listModel.isSelected
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.item)
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
        viewModel.fetchData { [weak self] result in
            switch result {
            case .success:
                self?.updateUI()
            case .failure(let error):
                self?.showAlert(message: "Error: \(error)")
            }
        }
    }
}
