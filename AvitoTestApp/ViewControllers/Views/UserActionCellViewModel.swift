//
//  UserActionCellViewModel.swift
//  AvitoTestApp
//
//  Created by Alex on 03.09.2023.
//

import Foundation

class UserActionCellViewModel {
    var title: String {
        list.title
    }
    var description: String? {
        list.description
    }
    var price: String {
        list.price
    }
    var isSelected: Bool {
        list.isSelected
    }
    
    init(list: List) {
        self.list = list
    }
    
    private let list: List
    
    func fetchImage(completion: @escaping (Data?) -> Void) {
        NetworkManager.shared.fetchImage(from: list.icon.imageUrl) { result in
            switch result {
            case .success(let imageData):
                completion(imageData)
            case .failure:
                completion(nil)
            }
        }
    }
    
}
