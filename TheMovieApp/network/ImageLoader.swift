//
//  ImageLoader.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/26/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import Foundation
import UIKit.UIImageView
import Alamofire
import AlamofireImage

class ImageLoader {
    
    static private let baseURL = "https://image.tmdb.org/t/p/"
    
    static public func loadimage(imagePath: String, size: ImageSize, completion : @escaping (Image) -> Void ) {
        
        Alamofire.request("\(baseURL)\(size)\(imagePath)").responseImage { response in
            if let image = response.result.value {
                completion(image)
            }
        }
    }
}

enum ImageSize: String {
    case original = "original"
    case w500 = "w500"
}
