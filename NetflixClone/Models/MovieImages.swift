//
//  MovieImages.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 05/08/23.
//

import Foundation
struct Backdrop: Codable {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount: Int
    let width: Int
    
    private enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct Logo: Codable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int?
    
    private enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct Poster: Codable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int?
    
    private enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct MovieImages: Codable {
    let backdrops: [Backdrop]
    let id: Int
    let logos: [Logo]
    let posters: [Poster]
}

