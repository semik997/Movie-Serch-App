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
       
    var networkManager = NetworkManager()
    var films: [Film] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        networkManager.fetchCurrentWeather { Film in
            //currentShow in print(currentShow.name)
            //self.films = [currentShow]
        }
    }
    
    // displaying data in a cell

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
        cell.loadData(films: films[indexPath.row])
        return cell
    }
}
