//
//  HeroMarvelModel.swift
//  Marvelgram
//
//  Created by Sergey Savinkov on 17.08.2023.
//

import Foundation

struct HeroMarvelModel: Decodable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
    
}

struct Thumbnail: Decodable {
    let path: String
    let `extension`: String
    
    var url:  URL? {
        return URL(string: path + "." + `extension`)
    }
}

extension HeroMarvelModel: Hashable {
    static func == (lhs: HeroMarvelModel, rhs: HeroMarvelModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
