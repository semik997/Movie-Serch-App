//
//  CollectionViewCell.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit

protocol FavoriteProtocol: AnyObject {
    func selectCell(_ isFavorite: Bool, idFilm: Int?, url: String?, name: String?, image: String?,
                    original: String?, summary: String?, imdb: String?)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fillButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    //Initialization of UI fields
    weak var delegate: FavoriteProtocol?
    var secondAPI = SecondAPI()
    var idFilm: Int?
    var url: String?
    var name: String?
    var image: String?
    var original: String?
    var summary: String?
    var imdb: String?
    var rating: Double?
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
                                 image: image, original: original, summary: summary,
                                 imdb: imdb)
        } else {
            //for not like
            fillButton.isSelected = !fillButton.isSelected
            isFavorite = !isFavorite
            delegate?.selectCell(isFavorite, idFilm: idFilm, url: url, name: name,
                                 image: image,original: original, summary: summary,
                                 imdb: imdb)
        }
    }
}

// MARK: - Uploading data to VC

extension CollectionViewCell {
    
    func loadData(film: Films.Film) {
        currentFilm = film
        if film.show?.isFavorite == true {
            nameLabel?.text = film.show?.name
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            url = film.show?.url
            name = film.show?.name
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
            imdb = film.show?.externals?.imdb
            fillButton.isSelected = true
            self.secondAPI.fetchShowRaiting(forShow: imdb ?? "") { [self] currentShowIMDb in
                self.rating = currentShowIMDb.rating
            }
            ratingLabel.text = "\(rating ?? 0)/10"
            
        } else {
            nameLabel?.text = film.show?.name
            mainImage.image = getImage(from: film.show?.image?.medium ?? placeholderFilm)
            idFilm = film.show?.id
            url = film.show?.url
            name = film.show?.name
            image = film.show?.image?.medium
            isFavorite = ((film.show?.isFavorite) != nil)
            original = film.show?.image?.original
            summary = film.show?.summary
            imdb = film.show?.externals?.imdb
            fillButton.isSelected = false
            ratingLabel.text = "\(rating ?? 0)/10"
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
