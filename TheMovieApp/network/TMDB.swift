//
//  Movies.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/24/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//
import Moya

public enum TMBDApi {
    static private let TOKEN = <<TOKEN_HERE>>
    
    case movies(Int)
}

extension TMBDApi : TargetType {
    
    public var baseURL : URL {
        return URL(string: "https://api.themoviedb.org/4")!;
    }
    
    public var path: String {
        switch self {
        case .movies(let id): return "/list/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .movies: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: ["page" : "1"], encoding: URLEncoding.queryString)
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json;charset=utf-8",
                "Authorization" : "Bearer " +  TMBDApi.TOKEN]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
