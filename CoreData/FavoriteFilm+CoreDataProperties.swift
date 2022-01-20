//
//  FavoriteFilm+CoreDataProperties.swift
//  Movie Search App
//
//  Created by Семен Колесников on 19.01.2022.
//
//

import Foundation
import CoreData


extension FavoriteFilm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteFilm> {
        return NSFetchRequest<FavoriteFilm>(entityName: "FavoriteFilm")
    }

    @NSManaged public var url: String?
    @NSManaged public var idFilm: Double
    @NSManaged public var name: String?
    @NSManaged public var medium: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var original: String?
    @NSManaged public var summary: String?
    @NSManaged public var imdb: String?

}

extension FavoriteFilm : Identifiable {

}
