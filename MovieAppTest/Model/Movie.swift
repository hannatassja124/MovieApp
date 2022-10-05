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

struct Trailer: Codable {
    let key: String
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case key
        case type
    }
}

struct ReviewList: Codable {
    let page: Int
    let results: [Review]
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
    }
}

struct Review: Codable {
    let author: String
    let rating: Double
    let content: String
    
    enum OuterKeys: String, CodingKey {
        case author, author_details, content, created_at, id, updated_at, url
    }
    
    enum AuthorDetailKeys: String, CodingKey {
        case rating
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
        let authorDetailContainer = try outerContainer.nestedContainer(keyedBy: AuthorDetailKeys.self, forKey: .author_details)
        
        self.author = try outerContainer.decode(String.self, forKey: .author)
        self.rating =  try authorDetailContainer.decode(Double.self, forKey: .rating)
        self.content = try outerContainer.decode(String.self, forKey: .content)
        
    }
}

