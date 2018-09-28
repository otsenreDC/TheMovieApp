//
//  FavoriteButtonHelper.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/26/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import UIKit

class FavoriteButtonHelper {
    
    private var button: UIButton!
    private var isFavorite: Bool = false
    private var delegate: FavoriteDelegate!
    
    init(favoriteButton: UIButton!, isFavorite: Bool, delegate: FavoriteDelegate) {
        self.button = favoriteButton
        self.isFavorite = isFavorite
        self.delegate = delegate
        
        configureButton()
        setButtonAction()
    }
    
    private func configureButton() {
        if self.isFavorite {
            configureButtonAsNoFavorite()
        } else  {
            configureButtonAsFavorite()
        }
    }
    
    private func configureButtonAsFavorite() {
        self.button.setTitle("FAVORITE", for: .normal)
    }
    
    private func configureButtonAsNoFavorite() {
        self.button.setTitle("NO FAVORITE", for: .normal)
    }
    
    private func setButtonAction() {
        self.button.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
    }
    
    @objc private func didButtonClick() {
        self.isFavorite = !self.isFavorite
        print("\(self.isFavorite)")
        if let delegate = self.delegate {
            delegate.onFavoriteStateChanged(isFavorite: self.isFavorite)
        }
        configureButton()
    }
}

protocol FavoriteDelegate {
    func onFavoriteStateChanged(isFavorite: Bool)
}

