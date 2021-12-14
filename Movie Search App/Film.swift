//
//  PlaceModel.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import Foundation

// Array structure

struct Film {
    
    var name: String
    var premiered: String
    var status: String
//    var image: String
    
    init?(currentShowData: [CurrentShowData]){
        self.name = currentShowData[0].show.name
        self.premiered = currentShowData[1].show.premiered
        self.status = currentShowData[2].show.status
//        self.image = currentShowData.show.image.medium
    }
}


