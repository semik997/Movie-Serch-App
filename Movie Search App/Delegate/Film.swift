//
//  CurrentShowData.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import Foundation
import UIKit

// data request structure via API from https://www.tvmaze.com/api
class Films {
    
    private let defaults = UserDefaults.standard
    static let shared = Films()
    
    struct Film: Codable {
        let show: Show?
    }
    
    struct Show: Codable {
        let id: Int?
        let name: String?
        let language: String?
        let status: String?
        let image: Image?
        let summary: String?
        var isFavorite: Bool?
    }
    
    struct Image: Codable {
        let medium: String
        let original: String?
    }
    
    // MARK: - User Data persistence model
    
    var favoriteFilm: [Films.Film] {
        
        get {
            if let data = defaults.value(forKey: "favoriteFilm") {
                return try! PropertyListDecoder().decode([Films.Film].self, from: data as! Data)
            } else {
                return [Films.Film] ()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "favoriteFilm")
            }
        }
    }
    
    // MARK: - Models for working with data in User Data
    
    func saveFilms(idFilm: Int?, name: String?, language: String?, status: String?, image: String?, isFavorite: Bool, original: String?, summary: String) {
        
        let favoriteFilms = Film(show: Show(id: idFilm, name: name, language: language, status: status, image: Image(medium: image ?? placeholderFilm, original: original ?? placeholderFilm), summary: summary, isFavorite: true))
        favoriteFilm.insert(favoriteFilms, at: 0)
    }
    
    func deleteFilm(idFilm: Int?) {
        favoriteFilm.removeAll(where: {$0.show?.id == idFilm})
        favoriteFilm = favoriteFilm
    }
}
