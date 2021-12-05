//
//  Favorites.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import UIKit

class Favorites: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var filmsFav = [name: "asA", ]

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsFav.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavoritesTableViewCell

        cell.nameLabelFav.text = filmsFav[indexPath.row].name
        cell.premLabelFav.text = filmsFav[indexPath.row].premiered
        cell.countryLabelFav.text = filmsFav[indexPath.row].country
        cell.imageFav.image = UIImage(named: filmsFav[indexPath.row].image)
        
        return cell
    }

}

