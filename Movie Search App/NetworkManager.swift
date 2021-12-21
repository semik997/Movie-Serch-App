//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import Foundation
import UIKit

// MARK: api request

struct NetworkManager {
    
    var onCompletion: (([Films.Film]) -> Void)?
    
    func fetchCurrent(onCompletion: (([Films.Film]) -> Void)?, forShow show: String){
        let urlString = "\(linkAPI)\(show)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, response, error in
            if let data = data {
                if let currentShow = self.parseJSON(withData: data){
                    onCompletion?(currentShow)
                }
            }
            // MARK: call completion block with json
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> [Films.Film]?{
        let decoder = JSONDecoder()
        var currentShow: [Films.Film] = []
        do {
            let currentShowData = try decoder.decode([Films.Film].self, from: data)
            
            for index in currentShowData{
                currentShow.append(index)
            }
            
            return currentShow
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
}
