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
            let text = searchText.split(separator: " ").joined(separator: "%20")
            if searchText.count >= 3 {
                self.networkManager.fetchCurrent(onCompletion: {
                    currentShowData in self.films = currentShowData
                }, forShow: text)
            }
        } else {
            tableView.reloadData()
            networkManager.fetchCurrent(onCompletion: {[weak self]
                currentShowData in self?.films = currentShowData
            }, forShow: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutlet.delegate = self
        networkManager.fetchCurrent(onCompletion: {[weak self]
            currentShowData in self?.films = currentShowData
        }, forShow: "")
    }
    
    // MARK: - Detail setting
    
    @IBAction func cancelActionMain(_ segue: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailMain" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let film = films[indexPath.row]
            let nav = segue.destination as! UINavigationController
            let moreInfoMainVC = nav.topViewController as! MoreInfoViewController
            moreInfoMainVC.detailedInformation = film
        }
    }
    
    // MARK: - Displaying data in a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell",
                                                       for: indexPath) as? TableViewCell
        else { return UITableViewCell()}
        cell.delegate = self
        if films.count != 0 {
            cell.loadData(film: films[indexPath.row])
        } else {
            cell.nameLabel.text = "Not found"
        }
        return cell
    }
}

// MARK: - Save and delete to favorites

extension MainViewController: FavoriteProtocol {
    
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?) {
        
        if isFavorite {
            //for like
            Films.shared.saveFilms(idFilm: idFilm, name: name,
                                   language: language, status: status,
                                   image: image, isFavorite: true,
                                   original: original, summary: summary ??
                                   "No description text")
            
        } else {
            //for not like
            Films.shared.deleteFilm(idFilm: idFilm)
            self.tableView.reloadData()
            self.films = Films.shared.favoriteFilm
            
        }
    }
    
}
