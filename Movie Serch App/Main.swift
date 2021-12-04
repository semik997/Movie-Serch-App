//
//  Main.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import UIKit

class Main: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchOutlet: UISearchBar!
    let networWeatherManager = NetworWeatherManager()
    
    let filmNames = ["Bad Boys", "Bad girls", "Haus", "100"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networWeatherManager.fetchCurrentWeather(request:"badboy")
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        cell.textLabel?.text = filmNames[indexPath.row]
        cell.imageView?.image = UIImage(named: filmNames[indexPath.row])
        
        return cell
    }
    
}



