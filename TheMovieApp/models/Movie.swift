//
//  Movie.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/24/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import Foundation
import Moya

public struct Movie {
    public var id: Int64
    public var title: String
    public var poster: String
    public var overview: String
    public var voteAverage: Double
    public var favorite: Bool
    public var releaseDate: Date
    
    init() {
        id = 0
        title = ""
        poster = ""
        overview = ""
        voteAverage = 0.0
        favorite = false
        releaseDate = Date()
    }
}

extension Movie: Decodable {
    
    private enum MovieKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieKeys.self)
        
        id = try container.decode(Int64.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        poster = try container.decode(String.self, forKey: .posterPath)
        overview = try container.decode(String.self, forKey: .overview)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        favorite = false
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: releaseDateString) {
            releaseDate = date
        } else {
            releaseDate = Date()
        }
    }

}


protocol MovieProtocol {
    func asMovie() -> Movie
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
