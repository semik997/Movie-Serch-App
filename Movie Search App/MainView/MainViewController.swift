//
//  Main.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchOutlet: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //Creating and filling the array for Display
    var networkManager = NetworkManager()
    let defaults = UserDefaults.standard
    var isFavorite = false
    
    // UserDefaults
    
    var films: [Films.Film] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                tableView?.delegate = self
                tableView?.dataSource = self
                tableView.reloadData()
            }
        }
    }
    
    //Screen identification for segway
    func instantiateViewController(withIdentifier identifier: String) -> UIView {
        return instantiateViewController(withIdentifier: "MainVC")
    }
    
    //Passing data to the search bar and sending a request
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            if searchText.count >= 3 {
                self.networkManager.fetchCurrent(onCompletion: {
                    currentShowData in self.films = currentShowData
                }, forShow: searchText)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutlet.delegate = self
        networkManager.fetchCurrent(onCompletion: {[weak self] currentShowData in
            self?.films = currentShowData
        }, forShow: "")
    }
    
    // MARK: displaying data in a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
                as? TableViewCell else { return UITableViewCell()}
        cell.delegate = self
        if films.count != 0 {
            cell.loadData(film: films[indexPath.row])
        } else {
            cell.nameLabel.text = "Not found"
        }
        return cell
    }
    
    //    func search() {
    //        presentAlertController(withTitle: "Do you sure?", message: nil, style: .alert)
    //    }
}
extension MainViewController: FavoriteProtocol {
    
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?, language: String?, status: String?, image: String?) {
        
        if isFavorite {
            //for like
            //            fillButton = true
            Films.shared.saveFilms(idFilm: idFilm, name: name, language: language, status: status, image: image, isFavorite: true)
            
        } else {
            //for not like
            
            Films.shared.deleteFilm(idFilm: idFilm)
//                        presentAlertController(withTitle: "Did you sure?", message: nil, style: .alert)
        }
    }
    
}
