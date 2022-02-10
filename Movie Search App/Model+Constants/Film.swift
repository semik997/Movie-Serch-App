//
//  CurrentShowData.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import Foundation
import CoreData

class Films {
    
    private let defaults = UserDefaults.standard
    static let shared = Films()
    
    // MARK: - Data request structure via API from https://www.tvmaze.com/api
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
    
    // MARK: -  request from https://rapidapi.com/apidojo/api/imdb8/
    struct FilmIMDb: Codable {
        let rating: Double?
    }
}
