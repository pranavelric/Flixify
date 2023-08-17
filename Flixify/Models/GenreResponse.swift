//
//  GenreResponse.swift
//  Flixify
//
//  Created by Pranav Choudhary on 23/07/23.
//

import Foundation

struct GenreResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
