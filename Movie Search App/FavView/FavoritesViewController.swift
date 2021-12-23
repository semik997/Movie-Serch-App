//
//  Favorites.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private weak var tableViewFav: UITableView!
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell",
                                                       for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.loadData(film: filmsFav[indexPath.row])
        return cell
    }
    
    func presentAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, idFilm: Int) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let yes = UIAlertAction(title: "Yes, I'am sure", style: .default) { action in
            Films.shared.deleteFilm(idFilm: idFilm)
        }
        
        let no = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
        alertController.addAction(yes)
        alertController.addAction(no)
        
        present(alertController, animated: true)
    }
}

extension FavoritesViewController: FavoriteProtocol {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?, language: String?, status: String?, image: String?) {
        
        if isFavorite {
            //for like
            
            Films.shared.saveFilms(idFilm: idFilm, name: name, language: language, status: status, image: image, isFavorite: true)
            
        } else {
            //for not like
            presentAlertController(withTitle: "Do you sure?", message: nil, style: .alert, idFilm: idFilm ?? 0)
        }
    }
}
