//
//  MainTableViewCell.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit
protocol FavoriteProtocol: AnyObject {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, name: String?,
                    language: String?, status: String?, image: String?,
                    original: String?, summary: String?)
}

//Initialization of UI fields

class TableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageFilm: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var fillButton: UIButton!
    weak var delegate: FavoriteProtocol?
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
            fillButton.isSelected = !fillButton.isSelected
            isFavorite = !isFavorite
            delegate?.selectCell(isFavorite, idFilm: idFilm, name: name,
                                 language: language, status: status, image: image,
                                 original: original, summary: summary)
        } else {
            //for not like
            fillButton.isSelected = !fillButton.isSelected
            isFavorite = !isFavorite
            delegate?.selectCell(isFavorite, idFilm: idFilm, name: name,
                                 language: language, status: status, image: image,
                                 original: original, summary: summary)
        }
    }
}

// MARK: - Uploading data to VC

extension TableViewCell {
    
    func loadData(film: Films.Film) {
        currentFilm = film
        if film.show?.isFavorite == true {
            nameLabel?.text = film.show?.name
            languageLabel.text = film.show?.language
            countryLabel.text = film.show?.status
            imageFilm.image = getImage(from: film.show?.image?.medium ?? "Not found")
            idFilm = film.show?.id
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
            languageLabel.text = film.show?.language
            countryLabel.text = film.show?.status
            imageFilm.image = getImage(from: film.show?.image?.medium ?? "Not found")
            idFilm = film.show?.id
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
        }catch {
            print(error.localizedDescription)
        }
        return image
    }
}
