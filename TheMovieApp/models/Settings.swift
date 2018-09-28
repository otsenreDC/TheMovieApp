//
//  Settings.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/28/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import Foundation

class Settings {
    
    private static var instance : Settings = Settings()
    
    var sortSelected : SortSetting = .rating
    
    private init() {
        
    }
    
    public static func getInsatance() -> Settings {
        return self.instance;
    }
    
    
}

public enum SortSetting {
    case title
    case rating
    case releaseDate
}
