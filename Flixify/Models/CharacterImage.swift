//
//  CharacterImage.swift
//  Flixify
//
//  Created by Pranav Choudhary on 13/08/23.
//

import Foundation
struct CharacterImage: Codable {
    let aspectRatio: Double?
    let height: Int?
    let iso639_1: String?
    let filePath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let width: Int?

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct CharacterImages: Codable {
    let id: Int?
    let profiles: [CharacterImage]?
}
