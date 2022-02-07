//
//  MainCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData

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
    
    //Creating and filling the array for Display
    private var tVMazeApiManager = TVMazeApiManager()
    private var rapidApiManager = RapidApiManager()
    private var seguesConstant = SeguesConst()
    private let defaults = UserDefaults.standard
    private var tap = UITapGestureRecognizer()
    private var searchText = ""
    private var chooseSize: SettingViewController.ChooseSize?
    private var defaultSizeCell = CGSize (width: 200, height: 200)
    
    var context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    private var films: [Films.Film] = [] {
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
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if films.count == 0 {
            noContentImageView.isHidden = false
            return films.count
        } else {
            noContentImageView.isHidden = true
            return films.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionViewSpace.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                 for: indexPath) as? CollectionViewCell
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
            guard let indexPath = collectionViewSpace.indexPathsForSelectedItems else { return }
            let film = films[indexPath[0].row]
            let nav = segue.destination as? UINavigationController
            let moreInfoMainVC = nav?.topViewController as? MoreInfoViewController
            moreInfoMainVC?.detail = film
        }
        
        // MARK: - Info button
        
        if segue.identifier == seguesConstant.infoButton {
            
            if let tvc = segue.destination as? InfoTableViewController {
                tvc.delegate = self
                tvc.delegateSetting = self
                if let ppc = tvc.popoverPresentationController {
                    ppc.delegate = self
                }
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
    
    // MARK: - Save in CoreData
    
    private func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return context }
        return appDelegate.persistentContainer.viewContext
    }
}


// MARK: - Setting view color

extension MainCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?) {
        if color == UIColor.white {
        } else {
            collectionViewSpace.backgroundColor = color
            navigationController?.navigationBar.backgroundColor = color
        }
        self.chooseSize = size
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

// MARK: - Save and delete to favorites

extension MainCollectionVC: FavoriteProtocol {
    
    func changeFilm(_ isFavorite: Bool, idFilm: Double?, url: String?,
                    name: String?, image: String?, original: String?,
                    summary: String?, imdb: String?) {
        
        if isFavorite {
            //for like
            
            let originalImage = getImage(from: original!)
            let imageImage = getImage(from: image!)
            let originalImageData = originalImage?.jpegData(compressionQuality: 1.0)
            let imageData = imageImage?.jpegData(compressionQuality: 1.0)
            
            let likeFilms = FavoriteFilm(context: self.context)
            likeFilms.isFavorite = true
            likeFilms.idFilm = idFilm ?? 0
            likeFilms.url = url
            likeFilms.name = name
            likeFilms.original = originalImageData
            likeFilms.medium = imageData
            likeFilms.summary = summary
            likeFilms.imdb = imdb
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            //for not like
            
            let context = self.getContext()
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteFilm")
            request.predicate = NSPredicate(format:"idFilm = %@", "\(idFilm ?? 0)")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - String in image conversion
    
    private func getImage(from string: String) -> UIImage? {
        //Get valid URL
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
        }
        var image: UIImage? = nil
        do {
            //Get valid data
            let data = try Data(contentsOf: url, options: [])
            
            //Make image
            image = UIImage(data: data)
        } catch {
            image = getImage(from: placeholderFilm)
        }
        return image
    }
}

// MARK: - Setting size cell

extension MainCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch self.chooseSize {
        case .big:
            let sizeCell = CGSize (width: 400, height: 400)
            self.defaultSizeCell = sizeCell
        case .medium:
            let sizeCell = CGSize (width: 200, height: 200)
            self.defaultSizeCell = sizeCell
        case .small:
            let sizeCell = CGSize (width: 100, height: 150)
            self.defaultSizeCell = sizeCell
        case .noChoose:
            break
        case .none:
            let sizeCell = CGSize (width: 200, height: 200)
            self.defaultSizeCell = sizeCell
        }
        return defaultSizeCell
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    }
}
