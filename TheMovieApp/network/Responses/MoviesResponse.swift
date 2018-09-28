//
//  MovieResponse.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/25/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import Foundation
import Moya

struct MoviesResponse {
    var movies : [Movie]
}

extension MoviesResponse: Decodable {
    
    private enum ResultKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKeys.self)
        
        movies = try container.decode([Movie].self, forKey: .results)
    }
}
