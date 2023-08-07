//
//  CollectionModel.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 02.08.2023.
//

import Foundation

struct HeroModel {
    
    let image: String
    let name: String
    let description: String
}

extension HeroModel: Hashable {
    static func == (lhs: HeroModel, rhs: HeroModel) -> Bool {
        return lhs.name == rhs.name
    }
}
