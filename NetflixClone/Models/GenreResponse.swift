//
//  GenreResponse.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 23/07/23.
//

import Foundation

struct GenreResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
