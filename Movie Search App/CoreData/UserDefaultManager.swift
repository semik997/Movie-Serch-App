//
//  UserDefaultManager.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 10.02.2022.
//

import Foundation
import UIKit

struct UserSettings: Codable {
    var color: String?
    var colorButton: String?
    var sizeCell: SettingViewController.ChooseSize?
}

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    enum SettingType {
        case mainScreen
        case favoriteScreen
        
        var defaultsKey: String {
            switch self {
            case .mainScreen:
                return UserDefaultConst.mainSettingsKey
            case .favoriteScreen:
                return UserDefaultConst.favoriteSettingKey
            }
        }
    }
    
    private let defaults = UserDefaults.standard
    
    private init() {}

    func saveDefaultSetting(_ setting: UserSettings,
                            type: SettingType) {
        guard let data = try? PropertyListEncoder().encode(setting) else {
            print("Data dont save")
            return
        }
        defaults.set(data,
                     forKey: type.defaultsKey)
    }
    
    
    func getDefaultSettings(type: SettingType) -> UserSettings? {
        guard let data = defaults.value(forKey: type.defaultsKey) as? Data else {
            return nil
        }
        return try? PropertyListDecoder().decode(UserSettings.self,
                                                 from: data)
    }
}
