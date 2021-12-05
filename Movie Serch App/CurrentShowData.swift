//
//  CurrentShowData.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 05.12.2021.
//

import Foundation

struct CurrentShowData: Codable {
    let show: Show
    
}

struct Show: Codable {
    let name: String
    let premiered: String
    let status: String
    let image: Image
}

struct Image: Codable {
    let medium: String
}
