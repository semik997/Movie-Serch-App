//
//  CurrentShowData.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 05.12.2021.
//

import Foundation

// data request structure via API from https://www.tvmaze.com/api

struct CurrentShowData: Codable {
    let show: Show
    
}

struct Show: Codable {
    let name: String
    let premiered: String
    let status: String
//    let image: Image
}
//
//struct Image: Codable {
//    let medium: String
//}
