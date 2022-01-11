//
//  MainCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit

class MainCollectionVC: UICollectionViewController {

    @IBOutlet var collectionViewSpace: UICollectionView!
   
    private let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    //Creating and filling the array for Display
    var networkManager = NetworkManager()
    let defaults = UserDefaults.standard
    var tap = UITapGestureRecognizer()
    var searchText = ""
    let itemPerRow: CGFloat = 3  // number of objects in a row
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    // UserDefaults
    var films: [Films.Film] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                collectionViewSpace?.delegate = self
                collectionViewSpace?.dataSource = self
                collectionViewSpace.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the name of the show to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return films.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewSpace.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                       for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell()}
        cell.delegate = self
        if films.count != 0 {
            cell.loadData(film: films[indexPath.row])
        } else {
//            cell.mainImage.image
        }
    
        return cell
    }

    func  presentInternetConnectionAlertController () {
        let internetAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel){ action in
            self.collectionViewSpace.reloadData()
        }
        internetAlert.addAction(ok)
        
        present(internetAlert, animated: true)
    }
    
    
}

extension MainCollectionVC: FavoriteProtocolC {
    
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?, language: String?, status: String?, image: String?, original: String?, summary: String?) {
        print(isFavorite, idFilm!, name!, language!, status!, image!, original!, summary!)
    }
}

extension MainCollectionVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text!
        
        // Check Internet connection
        if Reachability.isConnectedToNetwork() {
            // Check void text
            if searchText != "" {
                let text = searchText.split(separator: " ").joined(separator: "%20")
                // Check count symbol
                if searchText.count >= 3 {
                    // need add timer in this fragment
                    self.networkManager.fetchCurrent(onCompletion: {
                        currentShowData in self.films = currentShowData
                    }, forShow: text)
                    
                }
            } else {
                collectionViewSpace.reloadData()
                networkManager.fetchCurrent(onCompletion: { [weak self]
                    currentShowData in self?.films = currentShowData
                } , forShow: "")
            }
                // print("Internet Connection Available!")
        } else {
            print("Internet Connection not Available!")
            presentInternetConnectionAlertController ()
        }
    }
}




extension MainCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemPerRow + 1)  // number of indents in a row
        let availableWidth = collectionView.frame.width - paddingWidth  // the area that the cell can occupy
        let widthPerItem = availableWidth / itemPerRow  // calculating the width and height of a cell
        return CGSize (width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
}
