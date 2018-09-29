//
//  MovieDA.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/26/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//

import CoreData

extension MovieMO {
    
    public static func fetchMovieWith(context: NSManagedObjectContext, id: Int64) -> Movie? {
        var movie: Movie? = nil
        if let data = fetchMovieMOWith(context: context, id: id) {
            movie = Movie()
            movie?.id = data.id
            movie?.title = data.title ?? ""
            movie?.poster = data.poster ?? ""
            movie?.overview = data.overview ?? ""
            movie?.voteAverage = data.voteAverage
            movie?.favorite = data.favorite
            movie?.releaseDate = data.releaseDate ?? Date()
        }
        return movie
    }
    
    public static func addMovie(context: NSManagedObjectContext, movie: Movie) -> Bool {
        if movie.id > 0 {
            if !exists(context: context, id: movie.id) {
                let movieMO = MovieMO(context: context)
                movieMO.id = movie.id
                movieMO.title = movie.title
                movieMO.poster = movie.poster
                movieMO.overview = movie.overview
                movieMO.voteAverage = movie.voteAverage
                movieMO.releaseDate = movie.releaseDate
                do {
                    try context.save()
                    return true
                } catch {
                    return false
                }
            }
        }
        return true
        
    }
    
    public static func setAsFavorite(context: NSManagedObjectContext, id: Int64, favorite: Bool) -> Bool {
        if let movie = fetchMovieMOWith(context: context, id: id) {
            movie.favorite = favorite
            do {
                try context.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    public static func deleteMovie(context: NSManagedObjectContext, id: Int64) -> Bool {
        if let movie = fetchMovieMOWith(context: context, id: id) {
            context.delete(movie)
            return true
        } else {
            return false
        }
    }
    
    private static func exists(context: NSManagedObjectContext, id: Int64) -> Bool {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            return result.count > 0
        } catch {
            print("request failed")
        }
        return false
    }
    
    public static func fetchMovieMOWith(context: NSManagedObjectContext, id: Int64) -> MovieMO? {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                if let data = result[0] as? MovieMO {
                    return data
                }
            }
        } catch {
            print("request failed")
        }
        return nil
    }
    
}

extension MovieMO: MovieProtocol {
    func asMovie() -> Movie {
        var movie = Movie()
        
        movie.id = self.id
        movie.title = self.title ?? ""
        movie.poster = self.poster ?? ""
        movie.overview = self.overview ?? ""
        movie.voteAverage = self.voteAverage
        movie.favorite = self.favorite
        movie.releaseDate = self.releaseDate ?? Date()
        
        return movie
    }
}
