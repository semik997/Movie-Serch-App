//
//  FavoritesCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit

class FavoritesCollectionVC: UICollectionViewController {
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var findImage: UIImageView!
    
    
    let itemPerRow: CGFloat = 3  // number of objects in a row
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var filtredFilms: [Films.Film] = []
    var filmsFav: [Films.Film] = Films.shared.favoriteFilm {
        didSet {
            favoriteCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmsFav = Films.shared.favoriteFilm
        findImage.isHidden = true
        
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
        filmsFav = Films.shared.favoriteFilm
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if isFiltering {
            return filtredFilms.count
        } else {
            return filmsFav.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                    for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        var film: [Films.Film]
        if isFiltering {
            film = [filtredFilms[indexPath.row]]
            cell.loadData(film: filtredFilms[indexPath.row])
        } else {
            film = [filmsFav[indexPath.row]]
            cell.loadData(film: filmsFav[indexPath.row])
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
            guard let index = self.filmsFav.firstIndex(where: { $0.show?.id == idFilm})
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
            let film: Films.Film
            if isFiltering {
                film = filtredFilms[indexPath[0].row]
            } else {
                film = filmsFav[indexPath[0].row]
            }
            let nav = segue.destination as! UINavigationController
            let MoreInfoFavoritesTableVC = nav.topViewController as! MoreInfoViewController
            MoreInfoFavoritesTableVC.detailedInformation = film
        }
    }
    
    
}

// MARK: - Save and delete to favorites

extension FavoritesCollectionVC: FavoriteProtocolC {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?) {
        
        if isFavorite {
            //for like
            
            Films.shared.saveFilms(idFilm: idFilm, name: name, language: language,
                                   status: status, image: image, isFavorite: true,
                                   original: original, summary: summary ?? "No description text")
            
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
        
        filtredFilms = filmsFav.filter { (film: Films.Film) -> Bool in
            return film.show?.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        favoriteCollectionView.reloadData ()
    }
}

// MARK: - Setting size cell

extension FavoritesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)  // number of indents in a row
        let availableWidth = collectionView.frame.width - paddingWidth  // the area that the cell can occupy
        let widthPerItem = availableWidth / itemPerRow  // calculating the width and height of a cell
        return CGSize (width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
}
