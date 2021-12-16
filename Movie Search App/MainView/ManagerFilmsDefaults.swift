//
//  ManagerFilmsDefaults.wift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 16.12.2021.
//

import Foundation

class ManagerFilmsDefaults {
    
    enum SettingsKeys: String {
        case filmName
    }
    
   static var filmName: String? {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.filmName.rawValue)
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.filmName.rawValue
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
