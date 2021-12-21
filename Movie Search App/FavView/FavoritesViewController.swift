//
//  Favorites.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var tableViewFav: UITableView!
    //Creating and Populating an Array for Display
    
    var networkManager = NetworkManager()
    var mainViewController = MainViewController()
    var delegate: FavoritesViewControllerDelegate?
    var isLiked = false
    var filmsFav: [Films.Film] = Films.shared.favoriteFilm
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filmsFav = Films.shared.favoriteFilm
        tableViewFav.reloadData()
    }
    
    // displaying data in a cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsFav.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell",
                                                       for: indexPath) as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        cell.loadDataFav(film: filmsFav[indexPath.row])
        return cell
    }
}
