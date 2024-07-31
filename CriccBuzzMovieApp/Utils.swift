//
//  Utils.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

class Utils {
    func filterMovies(by inputText: String, in movies: [Movie]) -> [Movie] {
        let inputText = inputText.lowercased()
        return movies.filter { movie in
            movie.actors.lowercased().contains(inputText) || movie.director.lowercased().contains(inputText) || movie.title.lowercased().contains(inputText) || movie.genre.lowercased().contains(inputText)
        }
    }
}
