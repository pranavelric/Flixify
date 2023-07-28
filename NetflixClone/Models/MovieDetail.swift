//
//  MovieDetail.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 28/07/23.
//

import Foundation

struct MovieDetail: Codable {
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let id: Int?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    private enum CodingKeys: String, CodingKey {
        case adult, backdropPath = "backdrop_path", belongsToCollection = "belongs_to_collection", budget, genres, homepage, id, imdbId = "imdb_id",
             originalLanguage = "original_language", originalTitle = "original_title", overview, popularity, posterPath = "poster_path",
             productionCompanies = "production_companies", productionCountries = "production_countries", releaseDate = "release_date",
             revenue, runtime, spokenLanguages = "spoken_languages", status, tagline, title, video, voteAverage = "vote_average", voteCount = "vote_count"
    }
}

struct BelongsToCollection: Codable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, posterPath = "poster_path", backdropPath = "backdrop_path"
    }
}

struct ProductionCompany: Codable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, logoPath = "logo_path", name, originCountry = "origin_country"
    }
}

struct ProductionCountry: Codable {
    let iso_3166_1: String?
    let name: String?
}

struct SpokenLanguage: Codable {
    let englishName: String?
    let iso_639_1: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case englishName = "english_name", iso_639_1, name
    }
}
