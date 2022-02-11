//
//  MainCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData
import Firebase
import FirebaseStorage

class MainCollectionVC: UICollectionViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var collectionViewSpace: UICollectionView!
    @IBOutlet weak var noContentImageView: UIImageView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var tVMazeApiManager = TVMazeApiManager()
    private var rapidApiManager = RapidApiManager()
    private var seguesConstant = SeguesConst()
    private let defaults = UserDefaults.standard
    private var tap = UITapGestureRecognizer()
    private var searchText = ""
    private let indents = UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    private let bigSize = CGSize (width: 400, height: 400)
    private let mediumSize = CGSize (width: 200, height: 200)
    private let smallSize = CGSize (width: 100, height: 150)
    private var chooseSize: SettingViewController.ChooseSize?
    private var defaultSizeCell: CGSize?
    private var userColor: String?
    private var defaultColor: UIColor?
    private var mainMark: SettingViewController.ViewWhitchCame = .main
    private var films: [Films.Film] = [] {
        didSet {
            DispatchQueue.main.async { [self] in
                collectionViewSpace.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the name of the show to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        collectionViewSpace?.delegate = self
        collectionViewSpace?.dataSource = self
        collectionViewSpace.keyboardDismissMode = .onDrag
        receiveFromUserDefault()
        collectionViewSpace.backgroundColor = defaultColor
        navigationController?.navigationBar.backgroundColor = defaultColor
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if films.count == 0 {
            noContentImageView.isHidden = false
        } else {
            noContentImageView.isHidden = true
        }
        return films.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewSpace.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                 for: indexPath) as? FilmCollectionViewCell
        else { return UICollectionViewCell() }
        cell.delegate = self
        if indexPath.row < films.count {
            cell.loadData(film: films[indexPath.row])
        }
        return cell
    }
    
    // MARK: - Detail setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == seguesConstant.showDetail {
            if let cell = sender as? FilmCollectionViewCell,
               let indexPath = collectionViewSpace.indexPath(for: cell) {
                
                let film = films[indexPath.row]
                let nav = segue.destination as? UINavigationController
                let moreInfoMainVC = nav?.topViewController as? MoreInfoViewController
                moreInfoMainVC?.detail = film
            }
        }
        
        // MARK: - Info button
        
        if segue.identifier == seguesConstant.mainSettings {
            if let tvc = segue.destination as? SettingViewController {
                tvc.delegate = self
                tvc.viewCum = mainMark
            }
        }
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    // MARK: - Checking internet connection
    private func presentInternetConnectionAlertController () {
        
        
        let internetAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .cancel)
        internetAlert.addAction(ok)
        present(internetAlert, animated: true)
    }
}


// MARK: - Setting view color and size cell

extension MainCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?, view: SettingViewController.ViewWhitchCame?) {
        
        if view == .main {
            var helpingColor: UIColor?
            if color == UIColor.white {
                guard let chooseColor = UserDefaultManager.shared.mainViewSettings.color else { return }
                helpingColor = UIColor.hexStringToUIColor(hex: chooseColor)
            } else {
                collectionViewSpace.backgroundColor = color
                navigationController?.navigationBar.backgroundColor = color
                helpingColor = color
            }
            self.chooseSize = size
            
            saveToUserDefault(color: helpingColor, size: size)
        }
    }
    
    func saveToUserDefault(color: UIColor?, size: SettingViewController.ChooseSize?) {
        
        let userColor = UIColor.toHexString(color ?? UIColor.white)
        self.userColor = userColor()
        
        UserDefaultManager.shared.saveDefaultSettingMainView(color: self.userColor, sizeCell: size)
    }
    
    func receiveFromUserDefault() {
        
        guard let chooseColor = UserDefaultManager.shared.mainViewSettings.color else { return }
        let defaultColor = UIColor.hexStringToUIColor(hex: chooseColor)
        self.defaultColor = defaultColor
        
        self.chooseSize = UserDefaultManager.shared.mainViewSettings.sizeCell
    }
}

// MARK: - Setting search bar

extension MainCollectionVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchText = searchController.searchBar.text!
        
        if Reachability.isConnectedToNetwork() {
            
            if searchText != "" {
                
                let text = searchText.split(separator: " ").joined(separator: "%20")
                noContentImageView.isHidden = true
                
                if searchText.count >= 3 {
                    
                    noContentImageView.isHidden = true
                    self.tVMazeApiManager.fetchCurrent(onCompletion: {
                        currentShowData in self.films = currentShowData
                    }, forShow: text)
                }
            } else {
                noContentImageView.isHidden = false
                collectionViewSpace.reloadData()
                tVMazeApiManager.fetchCurrent(onCompletion: { [weak self]
                    currentShowData in self?.films = currentShowData
                }, forShow: "")
            }
        } else {
            print("Internet Connection not Available!")
            presentInternetConnectionAlertController ()
        }
    }
}

// MARK: - Saving and deleting from favorites

extension MainCollectionVC: FavoriteDeleteProtocol {
    
    func actionForFavoriteFilm(isFavorite: Bool, idFilm: Double?) {
        
        
        if let idFilm = idFilm, let film = films.first(where: { $0.show?.id == idFilm }) {
            
            guard let originalImage = UIImage.getImage(from: film.show?.image?.original ?? "placeholderFilm") else { return }
            uploadImage(name: film.show?.name ?? "", photo: originalImage)
            
            if isFavorite {
                //for like
                CoreDataManager.shared.saveInData(film: film, idFilm: idFilm)
            } else {
                //for not like
                CoreDataManager.shared.deleteFromData (idFilm: idFilm)
            }
        }
        
        //MARK: - Saving an Image to Firebase
        func uploadImage(name: String, photo: UIImage) {
            
            if let idFilm = idFilm, let film = films.first(where: { $0.show?.id == idFilm }) {
                
                let reference = Storage.storage().reference().child("moviesPicture").child(name)
                guard let image = UIImage.getImage(from: film.show?.image?.original ?? "") else { return }
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                reference.putData(imageData, metadata: metadata)
            }
        }
    }
}

// MARK: - Setting size cell

extension MainCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.chooseSize {
        case .big:
            self.defaultSizeCell = bigSize
        case .medium:
            self.defaultSizeCell = mediumSize
        case .small:
            self.defaultSizeCell = smallSize
        case .noChoose:
            break
        case .none:
            self.defaultSizeCell = nil
        }
        return defaultSizeCell ?? mediumSize
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return self.indents
    }
}
