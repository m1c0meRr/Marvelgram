//
//  NetworkDataFetch.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 17.08.2023.
//  HeroMarvelModel
//  Получили данные и пытаемся их декодировать
//  Fetch - извлечь/привести(к типу)

import UIKit


class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchHero(responce: @escaping ([HeroMarvelModel]?, Error?) -> Void) {
        NetworkRequest.shared.requestData { result in
            switch result {
            case .success(let data): //если успех - создаем свойство ДАТА и с помощью Do декодировать
                do {
                    let hero = try JSONDecoder().decode([HeroMarvelModel].self, from: data)
                    responce(hero, nil)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError.localizedDescription )
                }
            case .failure(let error):
                print("Error received requstingdata: \(error.localizedDescription)")
                responce(nil, error)
            }
        }
    }
}
