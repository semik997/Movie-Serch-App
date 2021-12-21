//
//  AlertController.swift
//  Movie Search App
//
//  Created by Семен Колесников on 21.12.2021.
//

import Foundation
import UIKit

protocol FavoritesViewControllerDelegate {
    func allertCall(_: FavoritesViewController, with film: ())
}

//extension FavoritesViewController {
//
//    func presentAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
//        let yes = UIAlertAction(title: "Yes, I am sure", style: .default) { [self] action in
//            Films.shared.deleteFilm(idFilm: idFilm, name: name, language: language,
//                                    status: status, image: image)
//        }
//        let no = UIAlertAction(title: "No thanks", style: .cancel, handler: nil)
//        alertController.addAction(yes)
//        alertController.addAction(no)
//
//        present(alertController, animated: true)
//    }
//}
