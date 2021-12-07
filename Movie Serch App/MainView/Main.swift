//
//  Main.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import UIKit

class Main: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter show name", message: nil, style: .alert) {
            show in
            self.networWeatherManager.fetchCurrentWeather(request: show) { currentShow in
            }
        }
    }
    let networWeatherManager = NetworWeatherManager()
   
    func film(current: Film){
        _ = current.name
        _ = current.premiered
        _ = current.status
    }
    
    let films = [Film(currentShowData: film)]
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        networWeatherManager.fetchCurrentWeather(request:"badbaby"){ currentShow in
        }
    }
    
    


    // displaying data in a cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
       
        cell.nameLabel?.text = films[indexPath.row].name
        cell.premieredLabel.text = films[indexPath.row].premiered
        cell.countryLabel.text = films[indexPath.row].status
//        cell.imageFilm?.image = UIImage(named: films[indexPath.row].image)
        
        return cell
    }
   
//    func favouritAction (at indexPath: IndexPath) -> UIContextualAction {
//        var object = films[indexPath.row]
////        let button = UIButton(coder: 1)
//        let acttion = UIContextualAction(style: .normal, title: "Like") {
//            (action, view, completion) in
//            object.isFavorites = !object.isFavorites
//            self.films[indexPath.row] = object
//            completion(true)
//        }
//        acttion.backgroundColor = object.isFavorites ? .systemPink : .darkGray
//        acttion.image = UIImage(systemName: "heart")
//        return acttion
//    }

}
