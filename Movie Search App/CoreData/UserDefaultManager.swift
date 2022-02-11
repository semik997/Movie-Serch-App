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
    private var userDefaultConst = UserDefaultConst()
    static let shared = UserDefaultManager()
    
    struct UserSettings: Codable {
        var color: String?
        var sizeCell: SettingViewController.ChooseSize?
    }
    
    var mainViewSettings: UserSettings {
        
        get {
            if let data = defaults.value(forKey: userDefaultConst.mainSettingsKey) as? Data {
                guard let defaultsData = try? PropertyListDecoder().decode(UserSettings.self, from: data) else { return UserSettings() }
                return defaultsData
            } else {
                return UserSettings()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userDefaultConst.mainSettingsKey)
            }
        }
    }
    
    var favoriteViewSettings: UserSettings {
        
        get {
            if let data = defaults.value(forKey: userDefaultConst.favoriteSettingKey) as? Data {
                guard let defaultsData = try? PropertyListDecoder().decode (UserSettings.self, from: data) else { return UserSettings() }
                return defaultsData
            } else {
                return UserSettings()
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: userDefaultConst.favoriteSettingKey)
            }
        }
    }
    
    func saveDefaultSetting() {
        
        
        
    }
    
    
    func getDefaultSettings() {
        
        
        
    }
    
    
    
    func saveDefaultSettingMainView(color: String?, sizeCell: SettingViewController.ChooseSize?) {
        
        let settings = UserSettings(color: color, sizeCell: sizeCell)
        self.mainViewSettings = settings
    }
    
    func saveDefaultSettingFavoriteView(color: String?, sizeCell: SettingViewController.ChooseSize?) {
        
        let settings = UserSettings(color: color, sizeCell: sizeCell)
        self.favoriteViewSettings = settings
    }
    
    
    
}
