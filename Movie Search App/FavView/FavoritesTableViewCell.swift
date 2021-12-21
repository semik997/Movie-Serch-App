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
    var oneFilm: Films.Show?
//    var name: String?
//    var language: String?
//    var status: String?
//    var image: String?
    
    //extension FavoritesTableViewCell{
    
    func loadDataFav(film: Films.Film) {
        nameLabelFav.text = film.show?.name
        languageLabelFav.text = film.show?.language
        countryLabelFav.text = film.show?.status
        imageFav.image = getImage(from: film.show?.image?.medium ?? "Not Found")
        oneFilm = film.show
    }
//
//        idFilm = film.show?.id
//        name = film.show?.name
//        language = film.show?.language
//        status = film.show?.status
//        image = film.show?.image?.medium
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
    

