//
//  Tv.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation



struct TrendingTvResponse: Codable{
    let results : [Tv]
}

struct Tv : Codable{
    let id :Int
    let adult : Bool?
    let popularity: Double?
    let vote_count : Int?
    let poster_path : String?
    let backdrop_path : String?
    let original_language : String?
    let genre_ids : [Int]?
    let vote_average: Double?
    let overview : String?
    let media_type : String?
    let first_air_date : String?
    let name : String?
    let origin_country: [String]?
    let original_name: String?
}
