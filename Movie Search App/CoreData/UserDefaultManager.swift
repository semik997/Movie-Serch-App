//
//  UserDefaultManager.swift
//  Movie Search App
//
//  Created by Семен Колесников on 10.02.2022.
//

import Foundation
import UIKit

class UserDefaultManager {
    
    let defaults = UserDefaults.standard
    
    static let shared = UserDefaultManager()
    
    struct UserSettings: Codable {
        var color: String?
        var sizeCell: SettingViewController.ChooseSize?
    }
    
    var settings:[UserSettings] {
        
        get {
            if let data = defaults.value(forKey: "adderesses") as? Data {
                return try! PropertyListDecoder().decode([UserSettings].self, from: data)
            } else {
                return[UserSettings]()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "adderesses")
            }
        }
    }
    
    
    func saveDefaultSetting(color: String?, sizeCell: SettingViewController.ChooseSize?) {
        
        let settings = UserSettings(color: color, sizeCell: sizeCell)
        self.settings.insert(settings, at: 0)
        
    }
    
    
    
    
    
}
