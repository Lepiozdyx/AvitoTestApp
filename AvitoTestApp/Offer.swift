//
//  Offer.swift
//  AvitoTestApp
//
//  Created by Alex on 22.08.2023.
//

import Foundation

// MARK: - Responce
struct Offer: Decodable {
    let result: Result
}
// MARK: - Offer
struct Result: Decodable {
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
    let isSelected: Bool
}
// MARK: - Icon
struct Icon: Decodable {
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case image = "52x52"
    }
}
