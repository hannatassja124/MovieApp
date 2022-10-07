//
//  Movie.swift
//  MovieAppTest
//
//  Created by Hannatassja Hardjadinata on 04/10/22.
//

import Foundation

struct List: Codable {
    let page: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey{
        case page
        case results
    }
}

struct Movie: Codable {
    let adult: Bool
    let poster: String
    let id: Int
    let title: String
    let description: String
    let duration: Int?
    let rating: Double
    
    enum CodingKeys: String, CodingKey{
        case adult
        case poster = "backdrop_path"
        case id
        case title
        case description = "overview"
        case duration = "runtime"
        case rating = "vote_average"
    }
}

