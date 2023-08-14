//
//  NetworkRequest.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 10.08.2023.
//  Сетевой слой/запрос

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}

    func requestData(copletion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://static.upstarts.work/tests/marvelgram/klsZdDg50j2.json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            DispatchQueue.main.async {
                if let error = error {
                    copletion(.failure(error))
                    return
                }
                guard let data = data else { return }
                copletion(.success(data))
            }
        }
        .resume() // запуск запроса/отправка
    }
}
