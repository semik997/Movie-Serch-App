//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Семен Колесников on 04.12.2021.
//

import Foundation

struct NetworWeatherManager {
    
    func fetchCurrentWeather(request querty: String){
    
    let urlString = "https://api.tvmaze.com/search/shows?q=\(querty)"
    guard let url = URL(string: urlString) else { return }
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: url) {data, response, error in
        if let data = data {
            let dataString = String(data: data, encoding: .utf8)
            print(dataString!)
        }
    }
    task.resume()
}

}
