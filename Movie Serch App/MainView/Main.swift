//
//  Main.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import UIKit

class Main: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    func instantiateViewController(withIdentifier identifier: String) -> UIView{
    return instantiateViewController(withIdentifier: "MainVC")
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter show name", message: nil, style: .alert) {
            show in
            self.networWeatherManager.fetchCurrentWeather(request: show)
        }
    }
    var networWeatherManager = NetworWeatherManager()
   
    
    let films = [CurrentShowData]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networWeatherManager.onCompletion = { currentWeather in
            print(currentWeather.name)
        }
        networWeatherManager.fetchCurrentWeather(request:"badbaby")
    }
    
    


    // displaying data in a cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
       
        cell.nameLabel?.text = films[indexPath.row].show.name
        cell.premieredLabel.text = films[indexPath.row].show.premiered
        cell.countryLabel.text = films[indexPath.row].show.status
//        cell.imageFilm?.image = UIImage(named: films[indexPath.row].image)
        
        tableView.reloadData()
        return cell
    }
}
