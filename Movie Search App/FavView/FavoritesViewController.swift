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
    var filmsFav: [Film] = []
    func didSet() {
        DispatchQueue.main.async {
            self.tableViewFav.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.fetchCurrentWeather(onCompletion: { CurrentShowData in
            self.filmsFav = CurrentShowData
        }, forShow: "girl")
    }
    
    // displaying data in a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsFav.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavoritesTableViewCell
        
        cell.loadDataFav(films: self.filmsFav[indexPath.row])
        return cell
    }
}
