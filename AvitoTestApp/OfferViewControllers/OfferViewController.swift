//
//  OfferViewController.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
//

import UIKit

final class OfferViewController: UIViewController {
    
    // MARK: IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: Private properties
    private var viewModel: OfferViewModelProtocol!
    
    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OfferViewModel()
        collectionView.collectionViewLayout = createCompositionalLayout()
        setTintColor()
        fetchInfo()
    }
    
    // MARK: IB Actions
    @IBAction func selectButtonTapped(_ sender: Any) {
        if let selectedOffer = viewModel.list.first(where: { $0.isSelected }) {
            showAlert(message: "Вы выбрали: \(selectedOffer.title)")
        } else {
            showAlert(message: "Услуга не выбрана")
        }
    }
    
}

// MARK: - Private Methods
private extension OfferViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Информация", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
    
    func updateUI() {
        self.titleLabel.text = viewModel.title
        self.collectionView.reloadData()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let inset: CGFloat = 10
        let sideInset = (UIScreen.main.bounds.width * 0.05)
        section.interGroupSpacing = inset
        section.contentInsets = NSDirectionalEdgeInsets(
            top: inset,
            leading: sideInset,
            bottom: inset,
            trailing: sideInset
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func setTintColor() {
        selectButton.tintColor = UIColor(named: "AvitoBlue")
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension OfferViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferViewCell.reuseIdentifier, for: indexPath)
        guard let cell = cell as? OfferViewCell else { return UICollectionViewCell() }
        
        let listModel = viewModel.list[indexPath.item]
        let cellViewModel = OfferCellViewModel(list: listModel)
        cell.configure(with: cellViewModel)
        cell.checkmarkImage.isHidden = !listModel.isSelected
        
        return cell
    }
}

extension OfferViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectItem(at: indexPath.item)
        collectionView.reloadData()
    }
}

// MARK: - Networking
extension OfferViewController {
    private func fetchInfo() {
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
