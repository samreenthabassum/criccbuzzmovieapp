//
//  MovieModel.swift
//  CriccBuzzMovieApp
//
//  Created by Samreen Thabassum on 30/07/24.
//

import Foundation
enum RatingSites: Int, CaseIterable {
    case imdb, internetMovieDb, metacritic, rottenTomatoes
    
    var title: String {
        switch self {
        case .imdb:
            return "IMDB"
        case .internetMovieDb:
            return "Internet Movie Database"
        case .metacritic:
            return "Metacritic"
        case .rottenTomatoes:
            return "Rotten Tomatoes"
        }
    }
}
enum MovieDataList: Int, CaseIterable {
    case year
    case genre
    case directors
    case actors
    case allMovies

    var title: String {
        switch self {
        case .year:
            return "Year"
        case .genre:
            return "Genre"
        case .directors:
            return "Directors"
        case .actors:
            return "Actors"
        case .allMovies:
            return "All Movies"
        }
    }
}
struct Rating: Codable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

struct Movie: Codable {
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
}
