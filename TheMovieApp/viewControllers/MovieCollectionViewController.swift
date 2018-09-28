//
//  MovieCollectionViewController.swift
//  TheMovieApp
//
//  Created by Ernesto De los Santos Cordero on 9/25/18.
//  Copyright © 2018 BananaLabs. All rights reserved.
//
import UIKit
import CoreData
import Moya

class MoviewCollectionViewController : UIViewController {
    
    private let SEARCH = 0
    private let FAVORITES = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBar!
    
    private var fetchedResultController: NSFetchedResultsController<MovieMO>? = nil;
    
    var moviesMO : [MovieMO] = []
    var showingFavorites = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.selectedItem = self.tabBar.items?[0]
        
        self.prepareFetchController()
        self.fetchMovies()
        self.downloadMovies()
    }
    
    private func downloadMovies() {
        let provider = MoyaProvider<TMBDApi>()
        
        provider.request(.movies(1)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(MoviesResponse.self, from: response.data)
                    for movie in results.movies {
                        _ = MovieMO.addMovie(context: CoreDataHelper.getInstance().manageContext, movie: movie)
                    }
                } catch {
                    print ("error")
                }
                break
            case .failure(_):
                print ("error")
            }
        }
    }
    
    private func fetchMovies() {
        do {
            fetchedResultController?.fetchRequest.predicate = createPredicate(favorites: self.showingFavorites)
            fetchedResultController?.fetchRequest.sortDescriptors = createSortDescriptorts()
            try fetchedResultController?.performFetch()
            self.moviesMO = fetchedResultController?.fetchedObjects ?? []
            self.collectionView.reloadData()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    private func getMovie(indexPath: IndexPath) -> Movie {
        
        return self.moviesMO[indexPath.row].asMovie()
        
    }
    
    private func createPredicate(favorites: Bool) -> NSPredicate? {
        if favorites {
            return NSPredicate(format: "favorite == %@", NSNumber(value: favorites))
        }else{
            return nil
        }
    }
    
    private func createSortDescriptorts() -> [NSSortDescriptor] {
        var key = ""
        switch Settings.getInsatance().sortSelected {
        case .rating:
            key = "voteAverage"
        case .title:
            key = "title"
        case .releaseDate:
            key = "releaseDate"
        }
        return [NSSortDescriptor(key: key, ascending: true)]
    }
}

extension MoviewCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = self.moviesMO.count
        if count == 0 {
            collectionView.setEmptyMessage("No movie found")
        } else {
            collectionView.restore()
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Movie", for: indexPath) as! MovieCollectionViewCell
        
        cell.movie = self.moviesMO[indexPath.row].asMovie()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Movie" {
            if let cell = sender as? MovieCollectionViewCell {
                if let controller = segue.destination as? MovieViewController {
                    controller.movie = getMovie(
                        indexPath: self.collectionView.indexPath(for: cell)!)
                }
            }
        } else if segue.identifier == "Show Settings" {
            if let controller = segue.destination as? SettingsViewController {
                controller.delegate = self
            }
        }
    }
    
}

extension MoviewCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.fetchMovies()
    }
}

extension MoviewCollectionViewController {
    
    private func prepareFetchController() {
        let context = CoreDataHelper.getInstance().manageContext
        let fetchRequest = NSFetchRequest<MovieMO>(entityName: "Movie")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "voteAverage", ascending: true)]
        self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultController?.delegate = self
    }
}

extension MoviewCollectionViewController : UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case SEARCH:
            self.showingFavorites = false
            break
        case FAVORITES:
            self.showingFavorites = true
            break
        default:
            self.showingFavorites = false
        }
        
        self.fetchMovies()
    }
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir-Light", size: 18)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension MoviewCollectionViewController: SettingsChangeDelegate {
    func sortSettingHasChanged() {
        self.fetchMovies()
    }
}
