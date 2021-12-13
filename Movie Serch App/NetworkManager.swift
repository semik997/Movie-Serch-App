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
    
    func fetchCurrentWeather(onCompletion: ((Film) -> Void)?){
        let urlString = "https://api.tvmaze.com/search/shows?q=Birdgirlll"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {data, response, error in
            if let data = data {
                if let currentShow = self.parseJSON(withData: data){
                    onCompletion?(currentShow)
            }
        }
            // data into json
            
            //call completion block with json
            
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> Film?{
        let decoder = JSONDecoder()
        do {
            let currentShowData = try decoder.decode([CurrentShowData].self, from: data)
            var array: [Film] = []
            array.append(currentShowData)
//            guard let currentShow = Film(currentShowData: currentShowData) else {
//                return nil
//            }
            return array
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
}
