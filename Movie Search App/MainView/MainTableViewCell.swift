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
    
    var isLiked = false
    
    @IBAction func likeButton(_ sender: UIButton) {
        isLiked = !isLiked
        
        if isLiked {
            //for like
            fillButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            ManagerFilmsDefaults.filmName = name
        } else {
            //for not like
            fillButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}


extension MainTableViewCell {
    
    func loadData(film: Film) {
        nameLabel?.text = film.show?.name
        languageLabel.text = film.show?.language
        countryLabel.text = film.show?.status
        imageFilm.image = getImage(from: film.show?.image?.medium ?? "Not found")
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
