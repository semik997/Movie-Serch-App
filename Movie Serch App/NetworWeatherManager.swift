//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import Foundation

// api request

struct NetworWeatherManager {
    
    func fetchCurrentWeather(request querty: String, completionHandler: @escaping (Film) -> Void){
    
    let urlString = "https://api.tvmaze.com/search/shows?q=\(querty)"
    guard let url = URL(string: urlString) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) {data, response, error in
        if let data = data {
            if let currentShow = self.parseJACON(withData: data){
            completionHandler(currentShow)
        }
        }
    }
    task.resume()
}
    
    func parseJACON(withData data: Data) -> Film?{
        let decoder = JSONDecoder()
        do {
            let currentShowData = try decoder.decode(CurrentShowData.self, from: data)
            guard let currentShow = Film(currentShowData: currentShowData) else {
                return nil
            }
            return currentShow
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
}
