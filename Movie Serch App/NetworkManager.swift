//
//  NetworWeatherManager.swift
//  Movie Serch App
//
//  Created by Sem Koliesnikov on 04.12.2021.
//

import Foundation

// api request

struct NetworkManager {
    
    var onCompletion: ((Film) -> Void)?
    
    func fetchCurrentWeather(){
        let urlString = "https://api.tvmaze.com/search/shows?q=badbaby"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, response, error in
            if let data = data {
                if let currentShow = self.parseJACON(withData: data){
                    self.onCompletion?(currentShow)
            }
        }
            // data into json
            
            //call completion block with json
            
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
