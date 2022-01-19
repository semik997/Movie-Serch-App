//
//  FavoritesCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData

class FavoritesCollectionVC: UICollectionViewController {
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var findImage: UIImageView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var filtredFilms: [FavoriteFilm] = []
    var filmsFav: [FavoriteFilm] = []
    var settingViewController = SettingViewController()
    var small: Bool?
    var medium: Bool?
    var big: Bool?
    var defaultSizeCell = CGSize (width: 200, height: 200)
    var context: NSManagedObjectContext! // fix !
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        filmsFav = FavoriteFilm(context: context)
        findImage.isHidden = true
        settingViewController.delegate = self
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the name of the show to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteCollectionView.reloadData()
//        filmsFav = FavoriteFilm(context: context)
        let context = getContext()
        let fetchRequest: NSFetchRequest<FavoriteFilm> = FavoriteFilm.fetchRequest()
        do {
            filmsFav = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
// MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            if filtredFilms.count == 0 {
                findImage.isHidden = false
                return filtredFilms.count
            }
            findImage.isHidden = true
            return filtredFilms.count
        } else {
            if filmsFav.count == 0 {
                findImage.isHidden = false
                return filmsFav.count
            }
            findImage.isHidden = true
            return filmsFav.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                    for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        var film: [FavoriteFilm]
        if isFiltering {
            film = [filtredFilms[indexPath.row]]
            cell.loadDataFavorite(film: filtredFilms[indexPath.row])
        } else {
            film = [filmsFav[indexPath.row]]
            cell.loadDataFavorite(film: filmsFav[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
// MARK: - Setting up an alert controller
    
    func presentAlertController(withTitle title: String?, message: String?,
                                style: UIAlertController.Style, idFilm: Int) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: style)
        let yes = UIAlertAction(title: "Yes, I'am sure", style: .default) { action in
            guard let index = self.filmsFav.firstIndex(where: { $0.idFilm == idFilm})
            else { return }
            self.filmsFav.remove(at: index)
            Films.shared.deleteFilm(idFilm: idFilm)
            self.favoriteCollectionView.reloadData()
        }
        
        let no = UIAlertAction(title: "No thanks", style: .cancel){ action in
            self.favoriteCollectionView.reloadData()
        }
        alertController.addAction(yes)
        alertController.addAction(no)
        
        present(alertController, animated: true)
    }
    
// MARK: - Detail setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = favoriteCollectionView.indexPathsForSelectedItems else { return }
            let film: FavoriteFilm
            if isFiltering {
                film = filtredFilms[indexPath[0].row]
            } else {
                film = filmsFav[indexPath[0].row]
            }
            let nav = segue.destination as! UINavigationController
            let MoreInfoFavoritesTableVC = nav.topViewController as! MoreInfoViewController
//            MoreInfoFavoritesTableVC.detailedInformation = film
        }
        
// MARK: - Info button
        
        if segue.identifier == "popVC" {
            if let tvc = segue.destination as? InfoTableViewController {
                tvc.delegateFav = self
                tvc.delegateSetting = self
                if let ppc = tvc.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        }
    }
}

extension FavoritesCollectionVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

// MARK: - Setting view color

extension FavoritesCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, big: Bool?, medium: Bool?, small: Bool?) {
        
        if color == UIColor.white {
        } else {
            favoriteCollectionView.backgroundColor = color
            navigationController?.navigationBar.backgroundColor = color
        }
        self.big = big
        self.medium = medium
        self.small = small
        favoriteCollectionView.reloadData()
    }
}

// MARK: - Save and delete to favorites

extension FavoritesCollectionVC: FavoriteProtocol {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, url: String?, name: String?,
                    image: String?, original: String?, summary: String?,
                    imdb: String?) {
        
        if isFavorite {
            //for like
            
            Films.shared.saveFilms(idFilm: idFilm, url: url, name: name, image: image, isFavorite: true,
                                   original: original, summary: summary ?? "No description text", imdb: imdb)
            
        } else {
            //for not like
            presentAlertController(withTitle: "Do you sure?", message: nil, style: .alert,
                                   idFilm: idFilm ?? 0)
        }
    }
}

// MARK: - Search in Favorite

extension FavoritesCollectionVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filtredFilms = filmsFav.filter { (film: FavoriteFilm) -> Bool in
            return film.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        favoriteCollectionView.reloadData ()
    }
}

// MARK: - Setting size cell

extension FavoritesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.small == false && self.medium == false && self.big == false {
            return defaultSizeCell
        } else {
            // apply small size cell
            if self.small ?? false {
                let sizeCell = CGSize (width: 100, height: 150)
                self.defaultSizeCell = sizeCell
                return sizeCell
                // apply medium size cell
            } else if self.medium ?? false {
                let sizeCell = CGSize (width: 200, height: 200)
                self.defaultSizeCell = sizeCell
                return sizeCell
                // apply big size cell
            } else if self.big ?? false {
                let sizeCell = CGSize (width: 400, height: 400)
                self.defaultSizeCell = sizeCell
                return sizeCell
            }
            return defaultSizeCell
        }
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    }
}
