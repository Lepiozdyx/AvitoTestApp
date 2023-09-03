//
//  NetworkManager.swift
//  AvitoTestApp
//
//  Created by Alex on 25.08.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let imageCache = NSCache<NSURL, NSData>()
    
    private init() {}
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        // Проверяем наличие данных изображения в кеше
        if let cachedImageData = imageCache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(.success(cachedImageData as Data))
            }
            return
        }
        
        // Загружаем данные, если их нет в кеше
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            
            // Сохраняем данные изображения в кеше
            self.imageCache.setObject(imageData as NSData, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
    
    func fetchInfo(completion: @escaping (Result<Offer, NetworkError>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/avito-tech/internship/main/result.json") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let offer = try JSONDecoder().decode(Offer.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(offer))
                }
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}
