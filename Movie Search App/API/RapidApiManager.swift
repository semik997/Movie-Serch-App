//
//  RapidApiManager.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 14.01.2022.
//

import Foundation
import UIKit
import SystemConfiguration

class RapidApiManager {
    
    // MARK: - Fetch show raiting
    func fetchShowRaiting(forShow show: String, completionHandler: @escaping (Films.FilmIMDb) -> Void) {
        
        let headers = [
            "x-rapidapi-host": "\(apiHost)",
            "x-rapidapi-key": "\(apiKey)"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "\(raitingAPI)\(show)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: timeoutInterval)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let data = data {
                if let currentShowIMDb = self.parseJSONRaitinig(withData: data) {
                    completionHandler(currentShowIMDb)
                }
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Call completion block with json
    private func parseJSONRaitinig(withData data: Data) -> Films.FilmIMDb? {
        let decoder = JSONDecoder()
        var currentShowIMDb: Films.FilmIMDb
        do {
            let currentShowData = try decoder.decode(Films.FilmIMDb.self, from: data)
            currentShowIMDb = currentShowData
            return currentShowIMDb
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
}

