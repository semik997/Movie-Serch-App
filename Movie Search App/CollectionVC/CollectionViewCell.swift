//
//  CollectionViewCell.swift
//  Movie Search App
//
//  Created by Семен Колесников on 10.01.2022.
//

import UIKit

protocol FavoriteProtocolC: AnyObject {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    
    //Initialization of UI fields
    weak var delegate: FavoriteProtocolC?
    var idFilm: Int?
    var name: String?
    var language: String?
    var status: String?
    var image: String?
    var original: String?
    var summary: String?
    var isFavorite = false
    
    private var currentFilm: Films.Film?
    
    let defaults = UserDefaults.standard
    
}

// MARK: - Uploading data to VC

extension CollectionViewCell {
    
    func loadData(film: Films.Film) {
        currentFilm = film
        if film.show?.isFavorite == true {
//            nameLabel?.text = film.show?.name
//            languageLabel.text = film.show?.language
//            countryLabel.text = film.show?.status
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            name = film.show?.name
            language = film.show?.language
            status = film.show?.status
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
//            fillButton.isSelected = true
            
        } else {
//            nameLabel?.text = film.show?.name
//            languageLabel.text = film.show?.language
//            countryLabel.text = film.show?.status
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            name = film.show?.name
            language = film.show?.language
            status = film.show?.status
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
//            fillButton.isSelected = false
        }
    }
    
    // MARK: - String in image conversion
    
    func getImage(from string: String) -> UIImage? {
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
            print(error.localizedDescription)
        }
        return image
    }
}
