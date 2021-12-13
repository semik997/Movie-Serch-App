//
//  PlaceModel.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import Foundation

// Array structure

struct Film{
    
    var name: String
    var premiered: String
    var status: String
//    var image: String
    
    init?(currentShowData: CurrentShowData){
        self.name = currentShowData.show.name
        self.premiered = currentShowData.show.premiered
        self.status = currentShowData.show.status
//        self.image = currentShowData.show.image.medium
    }
}


