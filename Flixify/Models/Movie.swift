//
//  Movie.swift
//  Flixify
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation

struct TrendingMovieResponse : Codable{
    let results: [Movie]
}

struct Movie: Codable {
    
    
    let id :Int
    let adult : Bool?
    let popularity: Double?
    let vote_count : Int?
    let poster_path : String?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids : [Int]?
    let title : String?
    let vote_average: Double?
    let overview : String?
    let release_date : String?
    let media_type : String?
    let video : Bool?
}
