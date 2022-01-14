//
//  CollectionViewCell.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit

protocol FavoriteProtocolC: AnyObject {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, url: String?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fillButton: UIButton!
    
    
    //Initialization of UI fields
    weak var delegate: FavoriteProtocolC?
    var idFilm: Int?
    var url: String?
    var name: String?
    var language: String?
    var status: String?
    var image: String?
    var original: String?
    var summary: String?
    var isFavorite = false
    
    private var currentFilm: Films.Film?
    
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fillButton.setImage(UIImage(systemName: "heart"),
                            for: .normal)
        fillButton.setImage(UIImage(systemName: "heart.fill"),
                            for: .selected)
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        
        if isFavorite {
            //for like
            isFavorite = !isFavorite
            delegate?.selectCell(isFavorite, idFilm: idFilm, url: url, name: name,
                                 language: language, status: status, image: image,
                                 original: original, summary: summary)
        } else {
            //for not like
            fillButton.isSelected = !fillButton.isSelected
            isFavorite = !isFavorite
            delegate?.selectCell(isFavorite, idFilm: idFilm, url: url, name: name,
                                 language: language, status: status, image: image,
                                 original: original, summary: summary)
        }
    }
}

// MARK: - Uploading data to VC

extension CollectionViewCell {
    
    func loadData(film: Films.Film) {
        currentFilm = film
        if film.show?.isFavorite == true {
            nameLabel?.text = film.show?.name
            //            languageLabel.text = film.show?.language
            //            countryLabel.text = film.show?.status
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            url = film.show?.url
            name = film.show?.name
            language = film.show?.language
            status = film.show?.status
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
            fillButton.isSelected = true
            
        } else {
            nameLabel?.text = film.show?.name
            //            languageLabel.text = film.show?.language
            //            countryLabel.text = film.show?.status
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            url = film.show?.url
            name = film.show?.name
            language = film.show?.language
            status = film.show?.status
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
            fillButton.isSelected = false
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
