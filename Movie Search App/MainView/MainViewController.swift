//
//  Main.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    @IBOutlet weak var searchOutlet: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    //Screen identification for segway
    
    func instantiateViewController(withIdentifier identifier: String) -> UIView{
        return instantiateViewController(withIdentifier: "MainVC")
    }
    
    //Creating and filling the array for Display
    
    var networkManager = NetworkManager()
    var films: [Film] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchOutlet.delegate = self
        networkManager.fetchCurrentWeather(onCompletion: { currentShowData in self.films = currentShowData }, forShow: "")
    }
    
    // displaying data in a cell
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
        
        cell.loadData(films: self.films[indexPath.row])
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText != ""{
            self.networkManager.fetchCurrentWeather(onCompletion: { currentShowData in self.films = currentShowData }, forShow: searchText)
        }
        
    }
}
