//
//  FavoritesCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData

class FavoritesCollectionVC: UICollectionViewController, UIPopoverPresentationControllerDelegate {
    
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
    private var filmsFav: [FavoriteFilm] = []
    private var settingViewController = SettingViewController()
    private var seguesConstant = SeguesConst()
    private var chooseSize: SettingViewController.ChooseSize?
    private var defaultSizeCell: CGSize?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findImage.isHidden = true
        settingViewController.delegate = self
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter name to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoriteCollectionView.reloadData()
        filmsFav = CoreDataManager.shared.fetchFilm()
    }
    
    // MARK: - Setting the number of cells and their filling
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            
            if filtredFilms.count == 0 {
                findImage.isHidden = false
            }
            findImage.isHidden = true
            return filtredFilms.count
        } else {
            if filmsFav.count == 0 {
                findImage.isHidden = false
            }
            findImage.isHidden = true
            return filmsFav.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt
                                 indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                    for: indexPath) as? FilmCollectionViewCell
        else {  return UICollectionViewCell() }
        
        if isFiltering {
            cell.loadDataFavorite(film: filtredFilms[indexPath.row])
        } else {
            cell.loadDataFavorite(film: filmsFav[indexPath.row])
        }
        cell.delegate = self
        return cell
    }
    
    // MARK: - Detail setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == seguesConstant.showDetail {
            if let cell = sender as? FilmCollectionViewCell,
               let indexPath = favoriteCollectionView.indexPath(for: cell){
                let film: FavoriteFilm
                
                if isFiltering {
                    film = filtredFilms[indexPath.row]
                } else {
                    film = filmsFav[indexPath.row]
                }
                
                let nav = segue.destination as? UINavigationController
                let MoreInfoFavoritesTableVC = nav?.topViewController as? MoreInfoViewController
                MoreInfoFavoritesTableVC?.detailedInformation = film
            }
        }
        
        //MARK: - Info button
        
        if segue.identifier == seguesConstant.infoButton {
            
            if let tvc = segue.destination as? InfoTableViewController {
                
                tvc.delegateFav = self
                tvc.delegateSetting = self
                
                if let ppc = tvc.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Setting up an alert controller
    
    private func presentAlertController(withTitle title: String?, message: String?,
                                        style: UIAlertController.Style, idFilm: Double) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: style)
        let yes = UIAlertAction(title: "Yes, I'am sure", style: .default) { action in
            guard let index = self.filmsFav.firstIndex(where: { $0.idFilm == idFilm})
            else { return }
            CoreDataManager.shared.deleteFromData(idFilm: idFilm)
            self.filmsFav.remove(at: index)
            self.favoriteCollectionView.reloadData()
        }
        
        let noButton = UIAlertAction(title: "No thanks", style: .cancel){ action in
            self.favoriteCollectionView.reloadData()
        }
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        
        present(alertController, animated: true)
    }
}


// MARK: - Setting view color

extension FavoritesCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?) {
        
        if color == UIColor.white {
        } else {
            favoriteCollectionView.backgroundColor = color
            navigationController?.navigationBar.backgroundColor = color
        }
        self.chooseSize = size
        favoriteCollectionView.reloadData()
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

// MARK: - Show alert to delete movie

extension FavoritesCollectionVC: FavoriteDeleteProtocol {
    func actionForFavoriteFilm(isFavorite: Bool, idFilm: Double?) {
        
        if isFavorite == false {
            //for not like
            presentAlertController(withTitle: "Are you sure??", message: nil, style: .alert,
                                   idFilm: idFilm ?? 0)
        }
    }
}

// MARK: - Setting size cell

extension FavoritesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.chooseSize {
        case .big:
            let sizeCell = CGSize (width: 400, height: 400)
            self.defaultSizeCell = sizeCell
        case .medium:
            let sizeCell = CGSize (width: 200, height: 200)
            self.defaultSizeCell = sizeCell
        case .small:
            let sizeCell = CGSize (width: 100, height: 150)
            self.defaultSizeCell = sizeCell
        case .noChoose:
            break
        case .none:
            let sizeCell = CGSize (width: 200, height: 200)
            self.defaultSizeCell = sizeCell
        }
        return defaultSizeCell ?? CGSize (width: 200, height: 200)
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    }
}
