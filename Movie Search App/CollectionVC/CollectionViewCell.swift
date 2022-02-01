//
//  CollectionViewCell.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.01.2022.
//

import UIKit
import CoreData

protocol FavoriteDeletProtocol: AnyObject {
    func actionForFavoriteFilm(isFavorite: Bool, idFilm: Double?)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fillButton: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    //Initialization of UI fields
//    let imageCache = NSCache<NSString, UIImage>()
    weak var delegateDelete: FavoriteDeletProtocol?
    private var rapidApiManager = RapidApiManager()
    private var idFilm: Double?
    private var url: String?
    private var name: String?
    private var image: String?
    private var original: String?
    private var imageFav: UIImage?
    private var originalFav: UIImage?
    private var summary: String?
    private var imdb: String?
    private var rating: Double?
    private var isFavorite = false
    private var getImage: UIImage?
    
    private var currentFilm: Films.Film?
    var context: NSManagedObjectContext?
    let defaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fillButton.setImage(UIImage(systemName: "heart"),
                            for: .normal)
        fillButton.setImage(UIImage(systemName: "heart.fill"),
                            for: .selected)
    }
    
    @IBAction private func likeButton(_ sender: UIButton) {
        
        if isFavorite {
            //delited like
            fillButton.isSelected = false
            isFavorite = !isFavorite
            delegateDelete?.actionForFavoriteFilm(isFavorite: isFavorite, idFilm: idFilm)
            
        } else {
            //add to like
            fillButton.isSelected = true
            isFavorite = !isFavorite
            delegateDelete?.actionForFavoriteFilm(isFavorite: isFavorite, idFilm: idFilm)
        }
    }
}

// MARK: - Uploading data to VC

extension CollectionViewCell {
    
    func loadData(film: Films.Film) {
        currentFilm = film
        nameLabel?.text = film.show?.name
        setImage(from: (film.show?.image?.medium ?? placeholderFilm))
        
//        mainImage.image = getImage(from: (film.show?.image?.medium ?? placeholderFilm))
        
        idFilm = film.show?.id
        url = film.show?.url
        name = film.show?.name
        image = film.show?.image?.medium
        isFavorite = ((film.show?.isFavorite) != nil)
        original = film.show?.image?.original
        summary = film.show?.summary
        imdb = film.show?.externals?.imdb
        fillButton.isSelected = false
        self.rapidApiManager.fetchShowRaiting(forShow: imdb ?? "") { [self] currentShowIMDb in
            self.rating = currentShowIMDb.rating
        }
        ratingLabel.text = "\(rating ?? 0)/10"
    }
    
    func loadDataFavorite(film: FavoriteFilm) {
        nameLabel?.text = film.name
        mainImage.image = UIImage(data: film.medium!)
        idFilm = film.idFilm
        url = film.url
        name = film.name
        imageFav = UIImage(data: film.medium!)
        isFavorite = film.isFavorite
        originalFav = UIImage(data: film.original!)
        summary = film.summary
        imdb = film.imdb
        fillButton.isSelected = true
        ratingLabel.text = "\(rating ?? 0)/10"
    }
    
    // MARK: - String in image conversion
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.mainImage.image = image
            }
        }
    }
//
//    func loadImageUsingCache(withUrl urlString : String) {
//            let url = URL(string: urlString)
//            if url == nil {return}
//            self.mainImage = nil
//
//            // check cached image
//            if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
//                self.mainImage = cachedImage
//                return
//            }
//
//        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
//            addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            activityIndicator.center = self.center
//
//            // if not, download image from url
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    if let image = UIImage(data: data!) {
//                        self.imageCache.setObject(image, forKey: urlString as NSString)
//                        self.mainImage = image
//                        activityIndicator.removeFromSuperview()
//                    }
//                }
//
//            }).resume()
//        }
//
}
