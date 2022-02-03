//
//  FavoriteFilm+CoreDataClass.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 20.01.2022.
//
//

import Foundation
import CoreData


public class FavoriteFilm: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteFilm> {
        return NSFetchRequest<FavoriteFilm>(entityName: "FavoriteFilm")
    }
    
    @NSManaged public var idFilm: Double
    @NSManaged public var imdb: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var medium: Data?
    @NSManaged public var name: String?
    @NSManaged public var original: Data?
    @NSManaged public var summary: String?
    @NSManaged public var url: String?

    public var nonEmptySummary: String {
        if let summary = summary {
            return summary.isEmpty ? "Stub" : summary
        }
        return "Stub"
    }

    
    
}
