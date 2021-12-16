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
    
    //Creating and filling the array for Display
    var networkManager = NetworkManager()
    var films: [Film] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Screen identification for segway
    func instantiateViewController(withIdentifier identifier: String) -> UIView{
        return instantiateViewController(withIdentifier: "MainVC")
    }
    
    //Passing data to the search bar and sending a request
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText != ""{
            if searchText.count >= 3{
            self.networkManager.fetchCurrent(onCompletion: { currentShowData in self.films = currentShowData }, forShow: searchText)
        }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchOutlet.delegate = self
        networkManager.fetchCurrent(onCompletion: { currentShowData in self.films = currentShowData }, forShow: "")
    }
    
    // displaying data in a cell
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainTableViewCell
        if indexPath.count != 0 {
            cell.loadData(films: self.films[indexPath.row])
        }else{
            print("Array zero")
        }
        return cell
    }
    
}
