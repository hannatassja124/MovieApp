//
//  Trailer.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 07/10/22.
//

import Foundation

struct TrailerList: Codable {
    let results: [Trailer]
}

struct Trailer: Codable {
    let key: String
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case type, key
    }
}
