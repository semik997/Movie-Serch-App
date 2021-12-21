//
//  MainTableViewCell.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import UIKit

//Initialization of UI fields

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageFilm: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var fillButton: UIButton!
    
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriteLanguageLabel: UILabel!
    @IBOutlet weak var favoriteStatusLabel: UILabel!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var deleteFavoriteButton: UIButton!
    
    var idFilm: Int?
    var name: String?
    var language: String?
    var status: String?
    var image: String?
    var isFavorite = false
    
    let defaults = UserDefaults.standard
    
    @IBAction func likeButton(_ sender: UIButton) {
        isFavorite = !isFavorite
        
        if isFavorite {
            //for like
            fillButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            Films.shared.saveFilms(idFilm: idFilm, name: name, language: language, status: status, image: image, isFavorite: true)
        } else {
            //for not like
            fillButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            self.presentAlertController(withTitle: "Did you sure?", message: nil, style: .alert)
        }
    }
}


extension MainTableViewCell {
    
    func loadData(film: Films.Film) {
        nameLabel?.text = film.show?.name
        languageLabel.text = film.show?.language
        countryLabel.text = film.show?.status
        imageFilm.image = getImage(from: film.show?.image?.medium ?? "Not found")
        idFilm = film.show?.id
        name = film.show?.name
        language = film.show?.language
        status = film.show?.status
        image = film.show?.image?.medium
    }
    
    func loadDataFav(film: Films.Film) {
        favoriteNameLabel.text = film.show?.name
        favoriteLanguageLabel.text = film.show?.language
        favoriteStatusLabel.text = film.show?.status
        favoriteImage.image = getImage(from: film.show?.image?.medium ?? "Not Found")
//        oneFilm = film.show
    }
    
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
