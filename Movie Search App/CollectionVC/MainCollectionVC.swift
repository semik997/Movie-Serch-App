//
//  MainCollectionVC.swift
//  Movie Search App
//
//  Created by Семен Колесников on 10.01.2022.
//

import UIKit

class MainCollectionVC: UICollectionViewController {

    @IBOutlet var collectionViewSpace: UICollectionView!
   
    //Creating and filling the array for Display
    var networkManager = NetworkManager()
    let defaults = UserDefaults.standard
    var tap = UITapGestureRecognizer()
    
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
            cell.nameLabel.text = "Not found"
        }
    
        return cell
    }

    
}
