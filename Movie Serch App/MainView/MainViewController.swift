//
//  Main.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var searchOutlet: UISearchBar!
    
    
    //Screen identification for segway
    
    func instantiateViewController(withIdentifier identifier: String) -> UIView{
        return instantiateViewController(withIdentifier: "MainVC")
    }
    
    //Creating and filling the array for Display
    
//    var films = [Film(name: "Bad Boys", premiered: "20.01.21", status: "Ended", image: "BadBoys")]
    
    var networkManager = NetworkManager()
    var films: [Film] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        films.append(Film(name: "Bad girls", premiered: "19.02.2021", status: "Ended", image: "Badgirls"))
        
        networkManager.onCompletion = {
            currentShow in print(currentShow.name)
            self.films = [currentShow]
            
        }
//         networking load data
//         completion block self.files = data
//         tableView reload data
    }
    
    
    // displaying data in a cell

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell

        cell.loadData(films[indexPath.row])
        cell.nameLabel?.text = films[indexPath.row].name
        cell.premieredLabel.text = films[indexPath.row].premiered
        cell.countryLabel.text = films[indexPath.row].status
//        cell.imageFilm.image = UIImage(named: films[indexPath.row].image)
        return cell
    }
}
