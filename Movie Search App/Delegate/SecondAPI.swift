//
//  SecondAPI.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 14.01.2022.
//

import Foundation
import UIKit
import SystemConfiguration

class SecondAPI {
    
    func fetchCurrent(forShow show: String) {
        
        let headers = [
            "x-rapidapi-host": "imdb8.p.rapidapi.com",
            "x-rapidapi-key": "SIGN-UP-FOR-KEY"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(secondLinkAPI)\(show)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                let currentShow = self.parseJSON(withData: data)
                //                {
                //                    onCompletion?(currentShow)
                //                }
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Call completion block with json
    
    func parseJSON(withData data: Data) -> [Films.Film]? {
        let decoder = JSONDecoder()
        var currentShow: [Films.Film] = []
        do {
            let currentShowData = try decoder.decode([Films.Film].self, from: data)
            
            for index in currentShowData {
                currentShow.append(index)
            }
            return currentShow
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
}

