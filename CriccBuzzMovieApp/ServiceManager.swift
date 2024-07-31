//
//  ServiceManager.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import Foundation

// Function to load JSON
class ServiceManager: NSObject {
    
    func loadJSON(completion: @escaping ([Movie]?, Error?) -> Void) {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
               DispatchQueue.global().async {
                   do {
                       let data = try Data(contentsOf: url)
                       let decoder = JSONDecoder()
                       let movies = try decoder.decode([Movie].self, from: data)
                       DispatchQueue.main.async {
                           completion(movies, nil)
                       }
                   } catch {
                       DispatchQueue.main.async {
                           completion(nil, error)
                       }
                   }
               }
           } else {
               completion(nil, NSError(domain: "JSON file not found", code: 404, userInfo: nil))
           }
    }
}
