//
//  Favorites.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Creating and Populating an Array for Display
    
    var filmsFav = [Film(name: "Haus", premiered: "11.06.20", status: "Goes on", image: "Haus")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmsFav.append(Film(name: "Bohem Rapsody", premiered: "19.07.2020", status: "Ended", image: "Bohem Rapsody"))
    }
    
    // displaying data in a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavoritesTableViewCell
        cell.nameLabelFav.text = filmsFav[indexPath.row].name
        cell.premLabelFav.text = filmsFav[indexPath.row].premiered
        cell.countryLabelFav.text = filmsFav[indexPath.row].status
        cell.imageFav.image = UIImage(named: filmsFav[indexPath.row].image)
        return cell
    }
}

