//
//  MainCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit

class MainCollectionVC: UICollectionViewController {
    
    @IBOutlet weak var collectionViewSpace: UICollectionView!
    @IBOutlet weak var findImage: UIImageView!
    
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
    var secondAPI = SecondAPI()
    let defaults = UserDefaults.standard
    var tap = UITapGestureRecognizer()
    var searchText = ""
    var small: Bool?
    var medium: Bool?
    var big: Bool?
    var defaultSizeCell = CGSize (width: 200, height: 200)
    
    // UserDefaults
    var films: [Films.Film] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
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
        collectionViewSpace?.delegate = self
        collectionViewSpace?.dataSource = self
    }
    
// MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if films.count == 0 {
            findImage.isHidden = false
            return films.count
        } else {
            findImage.isHidden = true
            return films.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewSpace.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                 for: indexPath) as? CollectionViewCell
        else { return UICollectionViewCell()}
        cell.delegate = self
        if indexPath.row < films.count {
            cell.loadData(film: films[indexPath.row])
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
    
// MARK: - Detail setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = collectionViewSpace.indexPathsForSelectedItems else { return }
            let film = films[indexPath[0].row]
            let nav = segue.destination as! UINavigationController
            let moreInfoMainVC = nav.topViewController as! MoreInfoViewController
            moreInfoMainVC.detailedInformation = film
        }
        
// MARK: - Info button
        
        if segue.identifier == "popVC" {
            
            if let tvc = segue.destination as? InfoTableViewController {
                tvc.delegate = self
                tvc.delegateSetting = self
                if let ppc = tvc.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        }
    }
}

extension MainCollectionVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

// MARK: - Setting view color

extension MainCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, big: Bool?, medium: Bool?, small: Bool?) {
        if color == UIColor.white {
        } else {
            collectionViewSpace.backgroundColor = color
            navigationController?.navigationBar.backgroundColor = color
        }
        self.big = big
        self.medium = medium
        self.small = small
    }
}


// MARK: - Setting search bar

extension MainCollectionVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text!
        
        // Check Internet connection
        if Reachability.isConnectedToNetwork() {
            // Check void text
            if searchText != "" {
                let text = searchText.split(separator: " ").joined(separator: "%20")
                findImage.isHidden = true
                // Check count symbol
                if searchText.count >= 3 {
                    // need add timer in this fragment
                    findImage.isHidden = true
                    self.networkManager.fetchCurrent(onCompletion: {
                        currentShowData in self.films = currentShowData
                    }, forShow: text)
                }
            } else {
                findImage.isHidden = false
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

// MARK: - Save and delete to favorites

extension MainCollectionVC: FavoriteProtocol {
    
    func selectCell(_ isFavorite: Bool, idFilm: Int?, url: String?,
                    name: String?, image: String?, original: String?,
                    summary: String?, imdb: String?) {
        
        if isFavorite {
            //for like
            Films.shared.saveFilms(idFilm: idFilm, url: url, name: name,
                                   image: image, isFavorite: true,
                                   original: original, summary: summary ??
                                   "No description text", imdb: imdb)
        } else {
            //for not like
            Films.shared.deleteFilm(idFilm: idFilm)
            self.collectionViewSpace.reloadData()
        }
    }
    
}

// MARK: - Setting item size

extension MainCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.small == false && self.medium == false && self.big == false {
            return defaultSizeCell
        } else {
            // apply small size cell
            if self.small ?? false {
                let sizeCell = CGSize (width: 100, height: 150)
                self.defaultSizeCell = sizeCell
                return sizeCell
                // apply medium size cell
            } else if self.medium ?? false {
                let sizeCell = CGSize (width: 200, height: 200)
                self.defaultSizeCell = sizeCell
                return sizeCell
                // apply big size cell
            } else if self.big ?? false {
                let sizeCell = CGSize (width: 400, height: 400)
                self.defaultSizeCell = sizeCell
                return sizeCell
            }
            return defaultSizeCell
        }
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    }
}
