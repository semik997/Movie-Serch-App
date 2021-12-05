//
//  AllertController.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 05.12.2021.
//

import Foundation
import UIKit

extension Main {
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String)->Void){
        let ac = UIAlertController(title: title, message: message, preferredStyle: style)
                ac.addTextField { tf in
                    let cities = "Enter the name of the show"
                    tf.placeholder = cities
                }
                let search = UIAlertAction(title: "Search", style: .default) { action in
                    let textField = ac.textFields?.first
                    guard let showName = textField?.text else { return }
                    if showName != "" {
                        let show = showName.split(separator: " ").joined(separator: "%20")
                        completionHandler(show)
                    }
                }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
                ac.addAction(search)
                ac.addAction(cancel)
                present(ac, animated: true, completion: nil)
    }

}
