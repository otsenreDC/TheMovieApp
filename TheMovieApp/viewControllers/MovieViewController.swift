//
//  MovieViewController.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/25/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import UIKit
import CoreData

class MovieViewController : UIViewController {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var ratingView: UILabel!
    @IBOutlet weak var overviewField: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movie: Movie? = nil
    var favoriteButtonHelper : FavoriteButtonHelper? = nil
    
    override func viewDidLoad() {
        
        configureFavoriteButton(button: self.favoriteButton)
        showMovieInformation()
    }
    
    private func configureFavoriteButton(button: UIButton) {
        self.favoriteButtonHelper = FavoriteButtonHelper(
            favoriteButton: button,
            isFavorite: self.isFavorite(movie: self.movie ?? Movie()),
            delegate: self)
    }
    
    private func showMovieInformation() {
        if self.movie != nil {
            self.title = self.movie?.title
            self.ratingView.text = "\(self.movie?.voteAverage ?? 0)"
            self.overviewField.text = self.movie?.overview
            if let poster = self.movie?.poster {
                loadImage(poster: poster)
            }
        }
    }
    
    private func loadImage(poster: String) {
        ImageLoader.loadimage(imagePath: poster, size: .original) { image in
            self.posterView.image = image
        }
    }
    
    private func isFavorite(movie: Movie) -> Bool {
        return movie.favorite
    }
}

extension MovieViewController : FavoriteDelegate {
    func onFavoriteStateChanged(isFavorite: Bool) {
        let context = CoreDataHelper.getInstance().manageContext
        if self.movie != nil {
            _ = MovieMO.setAsFavorite(context: context, id: self.movie!.id, favorite: isFavorite)
        }
        
    }
}

