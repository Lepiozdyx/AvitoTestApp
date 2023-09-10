//
//  MainViewModel.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
//

protocol MainViewModelProtocol {
    var title: String { get }
    var list: [List] { get }
    func fetchData(completion: @escaping (Result<Void, NetworkError>) -> Void)
    func selectItem(at index: Int)
}

class MainViewModel: MainViewModelProtocol {
    var title: String {
        offer?.result.title ?? ""
    }
    var list: [List] {
        internalList
    }
    private var offer: Offer?
    private var internalList: [List] = []
    
    func fetchData(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        NetworkManager.shared.fetchInfo { [weak self] result in
            switch result {
            case .success(let offer):
                self?.offer = offer
                self?.internalList = offer.result.list
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func selectItem(at index: Int) {
        if internalList[index].isSelected {
                internalList[index].isSelected = false
            } else {
                for (i, _) in internalList.enumerated() {
                    internalList[i].isSelected = false
                }
                internalList[index].isSelected = true
            }
    }
    
}

