//
//  Clip.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 02/08/23.
//

import Foundation
struct MovieClip: Codable {
    let id: Int
    let results: [ClipResult]?
}

struct ClipResult: Codable {
    let iso639_1: String?
    let iso3166_1: String?
    let name: String?
    let key: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let published_at: String?
    let clipId: String?
    
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official, published_at
        case clipId = "id"
    }
}
