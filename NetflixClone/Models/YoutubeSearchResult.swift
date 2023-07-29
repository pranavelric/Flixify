//
//  YoutubeSearchResult.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import Foundation



//{
//"error": {
//"code": 403,
//"message": "The request cannot be completed because you have exceeded your <a href=\"/youtube/v3/getting-started#quota\">quota</a>.",
//"errors": [
//{
//"message": "The request cannot be completed because you have exceeded your <a href=\"/youtube/v3/getting-started#quota\">quota</a>.",
//"domain": "youtube.quota",
//"reason": "quotaExceeded"
//}
//]
//}
//}


struct YouTubeSearchListResponse: Codable {
    let kind: String?
    let etag: String?
    let nextPageToken: String?
    let regionCode: String?
    let pageInfo: PageInfo?
    let items: [YouTubeVideoItem]?
    let error: YouTubeError?
}

struct YouTubeError: Codable {
    let code: Int
    let message: String
    let errors: [YouTubeErrorDetail]
}

struct YouTubeErrorDetail: Codable {
    let message: String
    let domain: String
    let reason: String
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct YouTubeVideoItem: Codable {
    let kind: String?
    let etag: String?
    let id: YouTubeVideoId
}

struct YouTubeVideoId: Codable {
    let kind: String?
    let videoId: String
}
