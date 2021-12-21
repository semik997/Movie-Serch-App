//
//  FavoritesTableViewCell.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import UIKit

//Initialization of UI fields

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageFav: UIImageView!
    @IBOutlet weak var nameLabelFav: UILabel!
    @IBOutlet weak var languageLabelFav: UILabel!
    @IBOutlet weak var countryLabelFav: UILabel!
    @IBOutlet weak var favoritesControl: UIButton!
    var name: String?
    var language: String?
    var status: String?
    var image: String?
    
    var isLiked = false
    
    @IBAction func isFavorites(_ sender: UIButton) {
        isLiked = !isLiked
        
        if isLiked {
            //for not like
            favoritesControl.setImage(UIImage(systemName: "heart"), for: .normal)
            Films.shared.deleteFilm(name: name, language: language,
                                    status: status, image: image)
        } else {
            //for like
            favoritesControl.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    
    //extension FavoritesTableViewCell{
    
    func loadDataFav(film: Films.Film) {
        nameLabelFav.text = film.show?.name
        languageLabelFav.text = film.show?.language
        countryLabelFav.text = film.show?.status
        imageFav.image = getImage(from: film.show?.image?.medium ?? "Not Found")
        name = film.show?.name
        language = film.show?.language
        status = film.show?.status
        image = film.show?.image?.medium
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
        }
        catch {
            print(error.localizedDescription)
        }
        return image
    }
    
}
