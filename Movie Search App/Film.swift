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
    
    let defaults = UserDefaults.standard
    static let shared = Films()
    
    struct Film: Codable {
        let show: Show?
    }
    
    struct Show: Codable {
        let idFilm: Int
        let name: String?
        let language: String?
        let status: String?
        let image: Image?
    }
    
    struct Image: Codable {
        let medium: String
    }
    
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
    
    func saveFilms(name: String?, language: String?, status: String?, image: String?) {
        
        let favoriteFilms = Film(show: Show(id: idFilm, name: name, language: language, status: status, image: Image(medium: image ?? " ")))
                                 
        favoriteFilm.insert(favoriteFilms, at: 0)
    }
    
    func deleteFilm(name: String?, language: String?, status: String?, image: String?) {
//        favoriteFilm.removeAll(where: {  == false })
        favoriteFilm = favoriteFilm
    }
}
