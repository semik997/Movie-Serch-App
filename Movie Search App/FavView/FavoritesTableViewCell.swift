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
    @IBOutlet weak var premLabelFav: UILabel!
    @IBOutlet weak var countryLabelFav: UILabel!
    @IBOutlet weak var favoritesControl: UIButton!
    
    var isLiked = false
    
    @IBAction func isFavorites(_ sender: UIButton) {
        isLiked = !isLiked
        
        if isLiked {
            //for not like
            favoritesControl.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            //for like
            favoritesControl.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

//}
//
//extension FavoritesTableViewCell{
    
    func loadDataFav(films: Film) {
        DispatchQueue.main.async { [self] in
            nameLabelFav?.text = films.show?.name
            premLabelFav.text = films.show?.language
            countryLabelFav.text = films.show?.status
            imageFav.image = getImage(from: films.show?.image?.medium ?? "Not Found")
        }
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
