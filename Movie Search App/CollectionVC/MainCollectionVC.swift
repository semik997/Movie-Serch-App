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
    var settingViewController = SettingViewController()
    let defaults = UserDefaults.standard
    var tap = UITapGestureRecognizer()
    var searchText = ""
    let itemPerRow: CGFloat = 3  // number of objects in a row
    let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var selectColor = UIColor.white
    
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
        
        settingViewController.delegate = self
        
        navigationController?.navigationBar.backgroundColor = selectColor
        collectionViewSpace.backgroundColor = selectColor
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
        
        // MARK: - info button
        
        if segue.identifier == "popVC" {
            if let tvc = segue.destination as? InfoTableViewController {
                tvc.delegate = self
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
        print(color ?? 1)
        self.selectColor = color ?? UIColor.red
        navigationController?.navigationBar.backgroundColor = color
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
                    self.secondAPI.fetchCurrent(forShow: text)

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

extension MainCollectionVC: FavoriteProtocolC {
    
    func selectCell(_ isFavorite: Bool, idFilm: Int?, url: String?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?) {
        
        if isFavorite {
            //for like
            Films.shared.saveFilms(idFilm: idFilm, url: url, name: name,
                                   language: language, status: status,
                                   image: image, isFavorite: true,
                                   original: original, summary: summary ??
                                   "No description text")
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
        var min = false
        var medium = false
        var max = true
        
        if min {
            return CGSize (width: 100, height: 100)
        } else if medium {
            return CGSize (width: 200, height: 200)
        } else if max {
            return CGSize (width: 400, height: 400)
        }
        
//        let paddingWidth = sectionInserts.left * (itemPerRow + 1)  // number of indents in a row
//        let availableWidth = collectionView.frame.width - paddingWidth  // the area that the cell can occupy
//        let widthPerItem = availableWidth / itemPerRow  // calculating the width and height of a cell
//        return CGSize (width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInserts = UIEdgeInsets(top: 50, left: 100, bottom: 100, right: 100)
        return sectionInserts
    }
    
}
