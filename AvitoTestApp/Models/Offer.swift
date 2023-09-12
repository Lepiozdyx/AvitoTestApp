//
//  Offer.swift
//  AvitoTestApp
//
//  Created by Alex on 22.08.2023.
//

import Foundation

// MARK: - Offer
struct Offer: Decodable {
    let result: Results
}
// MARK: - Responce
struct Results: Decodable {
    let title: String
    let list: [List]
}
// MARK: - List
struct List: Decodable {
    let id: String
    let title: String
    let description: String?
    let icon: Icon
    let price: String
    var isSelected: Bool
}
// MARK: - Icon
struct Icon: Decodable {
    let imageUrl: URL
        
    enum CodingKeys: String, CodingKey {
        case imageUrl = "52x52"
    }
}

