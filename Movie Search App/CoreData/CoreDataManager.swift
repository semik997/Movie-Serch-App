//
//  CoreDataManager.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.01.2022.
//

import CoreData
import UIKit

class CoreDataManager: NSObject {
    
    static let shared = CoreDataManager()
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Movie_Search_App")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        if context.hasChanges {
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Saving film to Core Data
    func saveInData(film: Films.Film, idFilm: Double) {
        
        let originalImage = UIImage.getImage(from: film.show?.image?.original ?? "placeholderFilm")
        let imageImage = UIImage.getImage(from: film.show?.image?.medium ?? "placeholderFilm")
        let originalImageData = originalImage?.jpegData(compressionQuality: 1.0)
        let imageData = imageImage?.jpegData(compressionQuality: 1.0)
        
        let likeFilms = FavoriteFilm(context: context)
        likeFilms.isFavorite = true
        likeFilms.idFilm = idFilm
        likeFilms.url = film.show?.url
        likeFilms.name = film.show?.name
        likeFilms.original = originalImageData
        likeFilms.medium = imageData
        likeFilms.summary = film.show?.summary
        likeFilms.imdb = film.show?.externals?.imdb
        
        do {
            try context.save()
        } catch {
            context.rollback()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    // MARK: - Deleting a movie from Core Data
    func deleteFromData(idFilm: Double) {
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteFilm")
        request.predicate = NSPredicate(format:"idFilm = %@", "\(idFilm)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

