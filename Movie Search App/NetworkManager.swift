//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import Foundation
import UIKit

// api request

struct NetworkManager {
    
    var onCompletion: (([Film]) -> Void)?
    
    func fetchCurrentWeather(onCompletion: (([Film]) -> Void)?, forShow show: String){
        let urlString = "https://api.tvmaze.com/search/shows?q=\(show)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, response, error in
            if let data = data {
                if let currentShow = self.parseJSON(withData: data){
                    onCompletion?(currentShow)
                }
            }
            
            //call completion block with json
            
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> [Film]?{
        let decoder = JSONDecoder()
        var currentShow: [Film] = []
        do {
            let currentShowData = try decoder.decode([Film].self, from: data)
            
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
