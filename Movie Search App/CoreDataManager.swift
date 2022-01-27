//
//  CoreDataManager.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 27.01.2022.
//

import CoreData
import UIKit

class CoreDataManager: UICollectionViewController {
    
    var context = (UIApplication.shared.delegate as!
                   AppDelegate).persistentContainer.viewContext
    
    func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return context }
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveInData () {
        do {
            try context.save()
        } catch {
            context.rollback()
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteFromData (idFilm: Double) {
        let context = getContext()
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

