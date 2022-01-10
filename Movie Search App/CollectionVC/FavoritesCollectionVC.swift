//
//  FavoritesCollectionVC.swift
//  Movie Search App
//
//  Created by Семен Колесников on 10.01.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavoritesCollectionVC: UICollectionViewController {
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    
    
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
        
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the name of the show to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableViewFav.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    
}


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell",
                                                   for: indexPath) as? TableViewCell else {
        return UITableViewCell()
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
        self.tableViewFav.reloadData()
    }
    
    let no = UIAlertAction(title: "No thanks", style: .cancel){ action in
        self.tableViewFav.reloadData()
    }
    alertController.addAction(yes)
    alertController.addAction(no)
    
    present(alertController, animated: true)
}

// MARK: - Detail setting

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetailMain" {
        guard let indexPath = tableViewFav.indexPathForSelectedRow else { return }
        let film: Films.Film
        if isFiltering {
            film = filtredFilms[indexPath.row]
        } else {
            film = filmsFav[indexPath.row ]
        }
        let nav = segue.destination as! UINavigationController
        let MoreInfoFavoritesTableVC = nav.topViewController as! MoreInfoViewController
        MoreInfoFavoritesTableVC.detailedInformation = film
    }
}
}

// MARK: - Save and delete to favorites

extension FavoritesViewController: FavoriteProtocol {
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

extension FavoritesViewController: UISearchResultsUpdating {
func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
}

private func filterContentForSearchText(_ searchText: String) {
    
    filtredFilms = filmsFav.filter { (film: Films.Film) -> Bool in
        return film.show?.name?.lowercased().contains(searchText.lowercased()) ?? false
    }
    tableViewFav.reloadData ()
}
}
