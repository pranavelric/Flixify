//
//  credit.swift
//  Flixify
//
//  Created by Pranav Choudhary on 01/08/23.
//
struct Credits: Codable {
    let id: Int
    let cast: [Cast]?
    let crew: [Crew]?
}

struct Cast: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let known_for_department: String?
    let name: String?
    let original_name: String?
    let popularity: Double?
    let profile_path: String?
    let cast_id: Int?
    let character: String?
    let credit_id: String?
    let order: Int?
}

struct Crew: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let known_for_department: String?
    let name: String?
    let original_name: String?
    let popularity: Double?
    let profile_path: String?
    let credit_id: String?
    let department: String?
    let job: String?
}
