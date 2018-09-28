//
//  MovieCollectionViewCell.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/25/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieCollectionViewCell : UICollectionViewCell
{
    private var _movie: Movie? = nil
    public var movie: Movie? {
        set {
            _movie = newValue
            showMovieInfo(movie: _movie)
        }
        get {
            return self._movie
        }
    }
    
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var image: UIImageView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak private var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var favoriteStar: UIImageView!
    
    private func showMovieInfo(movie: Movie?) {
        if movie != nil {
            self.title.text = movie?.title
            self.rating.text = "\(movie?.voteAverage ?? 0)"
        }
        if let poster = movie?.poster {
            self.loadingView.startAnimating()
            loadImage(imagePath: poster)
        }
        
        self.favoriteStar.isHidden = !(movie?.favorite ?? false)
    }
    
    private func loadImage(imagePath: String) {
        ImageLoader.loadimage(imagePath: imagePath, size: .w500) {image in
            self.image.image = image
            self.loadingView.stopAnimating()
        }
    }
}
