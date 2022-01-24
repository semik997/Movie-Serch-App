//
//  CurrentShowData.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import Foundation
import UIKit
import CoreData


class Films {
    
    private let defaults = UserDefaults.standard
    static let shared = Films()
    
    // data request structure via API from https://www.tvmaze.com/api
    struct Film: Codable {
        var show: Show?
    }
    
    struct Show: Codable {
        let id: Double?
        let url: String?
        var name: String?
        let image: Image?
        let externals: Externals?
        let summary: String?
        var isFavorite: Bool?
    }
    
    struct Externals: Codable {
        let imdb: String?
    }
    
    struct Image: Codable {
        let medium: String
        let original: String?
    }
    
    // request from https://rapidapi.com/apidojo/api/imdb8/
    struct FilmIMDb: Codable {
        let rating: Double?
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
    
    func saveFilms(idFilm: Double?, url: String?, name: String?,
                   image: String?, isFavorite: Bool, original: String?,
                   summary: String?, imdb: String?) {
        
        let favoriteFilms = Film(show: Show(id: idFilm, url: url, name: name, image: Image(medium: image ?? placeholderFilm, original: original ?? placeholderFilm), externals: Externals(imdb: imdb), summary: summary, isFavorite: true))
        favoriteFilm.insert(favoriteFilms, at: 0)
    }
    
    func deleteFilm(idFilm: Double?) {
        favoriteFilm.removeAll(where: {$0.show?.id == idFilm})
        favoriteFilm = favoriteFilm
    }
}
