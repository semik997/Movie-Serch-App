//
//  Constants.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 20.12.2021.
//

import Foundation
import UIKit

// MARK: - API link
let linkAPI = "https://api.tvmaze.com/search/shows?q="
let raitingAPI = "https://imdb8.p.rapidapi.com/title/get-ratings?tconst="
let apiHost = "imdb8.p.rapidapi.com"
let apiKey = "ece2314f79msh4522e10877770d5p170740jsn01828e60d0af"
let timeoutInterval = 10.0

// MARK: - Other link
let appYouTubeLink = "youtube://www.youtube.com/results?search_query="
let safariYouTubeLink = "https://www.youtube.com/results?search_query="
let placeholderFilm = "https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-1-scaled.png"

// MARK: - Constants from Segue
struct SeguesConst {
    static let showDetail = "showDetail"
    static let mainSettings = "mainSettings"
    static let favoriteSettings = "favoriteSettings"
}

// MARK: - Constants from UserDefault

struct UserDefaultConst {
    static let mainSettingsKey = "mainViewSettings"
    static let favoriteSettingKey = "favoriteViewSettings"
}

//MARK: - Other constants
let checkConection = sockaddr_in(sin_len: 0, sin_family: 0,
                                 sin_port: 0, sin_addr: in_addr(s_addr: 0),
                                 sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
let white = "#FFFFFF"
