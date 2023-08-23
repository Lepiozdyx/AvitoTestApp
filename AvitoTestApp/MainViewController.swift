//
//  MainViewController.swift
//  AvitoTestApp
//
//  Created by Alex on 16.08.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectButton: UIButton!
    
    private let reuseIdentifier = "userAction"
    
    private var userActions: [List] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInfo()
    }
    
    @IBAction func selectButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
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
        for (index, _) in userActions.enumerated() {
            userActions[index].isSelected = index == indexPath.item
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
        guard let url = URL(string: "https://raw.githubusercontent.com/avito-tech/internship/main/result.json") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let offer = try JSONDecoder().decode(Offer.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: offer)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
