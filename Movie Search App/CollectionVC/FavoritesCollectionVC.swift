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
    private var chooseSize: SettingViewController.ChooseSize?
    private var defaultSizeCell: CGSize?
    private let insret = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    private let bigSize = CGSize (width: 400, height: 400)
    private let mediumSize = CGSize (width: 200, height: 200)
    private let smallSize = CGSize (width: 100, height: 150)
    private var defaultColor: UIColor?
    private var settingType: UserDefaultManager.SettingType = .favoriteScreen
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findImage.isHidden = true
        settingViewController.delegate = self
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter name to search"
        navigationItem.searchController = searchController
        favoriteCollectionView.keyboardDismissMode = .onDrag
        definesPresentationContext = true
        receiveFromUserDefault()
        favoriteCollectionView.backgroundColor = defaultColor
        navigationController?.navigationBar.backgroundColor = defaultColor
        
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
        
        if segue.identifier == SeguesConst.showDetail {
            if let cell = sender as? FilmCollectionViewCell,
               let indexPath = favoriteCollectionView.indexPath(for: cell){
                let film: FavoriteFilm
                
                if isFiltering {
                    film = filtredFilms[indexPath.row]
                } else {
                    film = filmsFav[indexPath.row]
                }
                
                let nav = segue.destination as? UINavigationController
                let moreInfoFavoritesTableVC = nav?.topViewController as? MoreInfoViewController
                moreInfoFavoritesTableVC?.detailedInformation = film
            }
        }
        
        //MARK: - Settings button
        
        if segue.identifier == SeguesConst.favoriteSettings {
            if let tvc = segue.destination as? SettingViewController {
                tvc.delegate = self
                tvc.settingType = .favoriteScreen
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
        alertController.addAction(
            UIAlertAction(title: "Yes",
                          style: .destructive,
                          handler: { action in
                              guard let index = self.filmsFav.firstIndex(where: { $0.idFilm == idFilm})
                              else { return }
                              CoreDataManager.shared.deleteFromData(idFilm: idFilm)
                              self.filmsFav.remove(at: index)
                              self.favoriteCollectionView.reloadData()
                          })
        )
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            self.favoriteCollectionView.reloadData()
        }))
        present(alertController, animated: true)
    }
}


// MARK: - Setting view color and size cell

extension FavoritesCollectionVC: SettingViewControllerDelegate {
    // Transferring data and updating from the settings screen
    func updateInterface(color: UIColor?,
                         size: SettingViewController.ChooseSize?,
                         type: UserDefaultManager.SettingType) {
        if type == .favoriteScreen {
            var helpingColor: UIColor?
            if color == UIColor.white, let chooseColor = UserDefaultManager.shared.getDefaultSettings(type: self.settingType)?.color {
                helpingColor = UIColor.hexStringToUIColor(hex: chooseColor)
            } else {
                favoriteCollectionView.backgroundColor = color
                navigationController?.navigationBar.backgroundColor = color
                helpingColor = color
            }
            self.chooseSize = size
            favoriteCollectionView.reloadData()
            
            let userColor = UIColor.toHexString(helpingColor ?? UIColor.white)
            let userStringColor = userColor()
            UserDefaultManager.shared.saveDefaultSetting(UserSettings.init(color: userStringColor, sizeCell: size),
                                                         type: type)
        }
    }
    
    func receiveFromUserDefault() {
        
        let defaultModel = UserDefaultManager.shared.getDefaultSettings(type: settingType)
        guard let chooseColor = defaultModel?.color else { return }
        let defaultColor = UIColor.hexStringToUIColor(hex: chooseColor)
        self.defaultColor = defaultColor
        
        self.chooseSize = defaultModel?.sizeCell
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
            presentAlertController(withTitle: "Remove from favorites??", message: nil, style: .alert,
                                   idFilm: idFilm ?? 0)
        }
    }
}

// MARK: - Setting size cell

extension FavoritesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.chooseSize {
        case .big:
            let sizeCell = bigSize
            self.defaultSizeCell = sizeCell
        case .medium:
            let sizeCell = mediumSize
            self.defaultSizeCell = sizeCell
        case .small:
            let sizeCell = smallSize
            self.defaultSizeCell = sizeCell
        case .noChoose:
            break
        case .none:
            let sizeCell = defaultSizeCell
            self.defaultSizeCell = sizeCell
        }
        return defaultSizeCell ?? CGSize (width: 200, height: 200)
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.insret
    }
}
