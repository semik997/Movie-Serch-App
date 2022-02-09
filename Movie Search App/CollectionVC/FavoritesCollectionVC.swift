//
//  FavoritesCollectionVC.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData

class FavoritesCollectionVC: UICollectionViewController {
    
    @IBOutlet var favoriteCollectionView: UICollectionView!
    @IBOutlet weak var findImage: UIImageView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var filtredFilms: [FavoriteFilm] = []
    private var filmsFav: [FavoriteFilm] = []
    private var settingViewController = SettingViewController()
    private var seguesConstant = SeguesConst()
    private var chooseSize: SettingViewController.ChooseSize?
    private var defaultSizeCell: CGSize?
    var context: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findImage.isHidden = true
        settingViewController.delegate = self
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter name to search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteCollectionView.reloadData()
        let context = getContext()
        let fetchRequest: NSFetchRequest<FavoriteFilm> = FavoriteFilm.fetchRequest()
        do {
            filmsFav = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return context! }
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            if filtredFilms.count == 0 {
                findImage.isHidden = false
                return filtredFilms.count
            }
            findImage.isHidden = true
            return filtredFilms.count
        } else {
            if filmsFav.count == 0 {
                findImage.isHidden = false
                return filmsFav.count
            }
            findImage.isHidden = true
            return filmsFav.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt
                                 indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: "mainCell",
                                                                    for: indexPath) as? CollectionViewCell
        else {  return UICollectionViewCell() }
        var film: [FavoriteFilm]
        if isFiltering {
            film = [filtredFilms[indexPath.row]]
            cell.loadDataFavorite(film: filtredFilms[indexPath.row])
        } else {
            film = [filmsFav[indexPath.row]]
            cell.loadDataFavorite(film: filmsFav[indexPath.row])
        }
        cell.delegateDelete = self
        return cell
    }
    
    // MARK: - Setting up an alert controller
    
    private func presentAlertController(withTitle title: String?, message: String?,
                                        style: UIAlertController.Style, idFilm: Double) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: style)
        let yes = UIAlertAction(title: "Yes, I'am sure", style: .default) { action in
            self.deleteFilm(withTitle: title, message: message, idFilm: idFilm)
        }
        
        let no = UIAlertAction(title: "No thanks", style: .cancel){ action in
            self.favoriteCollectionView.reloadData()
        }
        alertController.addAction(yes)
        alertController.addAction(no)
        
        present(alertController, animated: true)
    }
    
    private func deleteFilm(withTitle title: String?, message: String?, idFilm: Double) {
        
        guard let index = self.filmsFav.firstIndex(where: { $0.idFilm == idFilm})
        else { return }
        let context = self.getContext()
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteFilm")
        request.predicate = NSPredicate(format:"idFilm = %@", "\(idFilm)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        self.filmsFav.remove(at: index)
        self.favoriteCollectionView.reloadData()
        
    }
    
    
    // MARK: - Detail setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguesConstant.showDetail {
            guard let indexPath = favoriteCollectionView.indexPathsForSelectedItems else { return }
            let film: FavoriteFilm
            if isFiltering {
                film = filtredFilms[indexPath[0].row]
            } else {
                film = filmsFav[indexPath[0].row]
            }
            let nav = segue.destination as? UINavigationController
            let MoreInfoFavoritesTableVC = nav?.topViewController as? MoreInfoViewController
            MoreInfoFavoritesTableVC?.detailedInformation = film
        }
        
        //MARK: - Info button
        
        if segue.identifier == seguesConstant.infoButton {
            if let tvc = segue.destination as? InfoTableViewController {
                tvc.delegateFav = self
                tvc.delegateSetting = self
                if let ppc = tvc.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        }
    }
}

extension FavoritesCollectionVC: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

// MARK: - Setting view color

extension FavoritesCollectionVC: SettingViewControllerDelegate {
    
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?) {
        
        if color == UIColor.white {
        } else {
            favoriteCollectionView.backgroundColor = color
            navigationController?.navigationBar.backgroundColor = color
        }
        self.chooseSize = size
        favoriteCollectionView.reloadData()
    }
}

// MARK: - Search in Favorite

extension FavoritesCollectionVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filtredFilms = filmsFav.filter { (film: FavoriteFilm) -> Bool in
            return film.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        favoriteCollectionView.reloadData ()
    }
}

// MARK: - Save and delete to favorites

extension FavoritesCollectionVC: FavoriteDeletProtocol {
    func deleteFavoriteFilm(isFavorite: Bool, idFilm: Double?) {
        
        if isFavorite == false {
            //for not like
            presentAlertController(withTitle: "Are you sure??", message: nil, style: .alert,
                                   idFilm: idFilm ?? 0)
        }
    }
}

// MARK: - Setting size cell

extension FavoritesCollectionVC: UICollectionViewDelegateFlowLayout {
    
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
        return defaultSizeCell ?? CGSize (width: 200, height: 200)
    }
    
    // setting cell intervals
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 100, right: 0)
    }
}
