//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import Foundation

// api request

struct NetworkManager {
    
    func fetchCurrentWeather(request querty: String){
        let urlString = "https://api.tvmaze.com/search/shows?q=badbaby"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, response, error in
        }
    task.resume()
}
    
    func parseJACON(withData data: Data){
        let decoder = JSONDecoder()
        do {
            let currentShowData = try decoder.decode([CurrentShowData].self, from: data)
            _ = currentShowData[0].show.name
            _ = currentShowData[1].show.premiered
            _ = currentShowData[2].show.status
        }catch let error as NSError{
            print(error)
        }
    }
}
