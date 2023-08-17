//
//  NetworkImageFetch.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 17.08.2023.
//

import Foundation

class NetworkImageFetch {
    
    static let shared = NetworkImageFetch()
    private init() {}
    
    func requestImage(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
