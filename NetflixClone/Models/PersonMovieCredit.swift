//
//  PersonMovieCredit.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 14/08/23.
//

import Foundation
struct PersonMovieCredit: Codable {


    let cast: [Movie]?
    let id: Int?
}
struct PersonMovieCreditCast: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    
    private enum CodingKeys: String, CodingKey {
        case adult, backdropPath = "backdrop_path", genreIds = "genre_ids", id, originalLanguage = "original_language", originalTitle = "original_title", overview, popularity, posterPath = "poster_path", releaseDate = "release_date", title, video, voteAverage = "vote_average", voteCount = "vote_count", character, creditId = "credit_id", order
    }
}
