//
//  YoutubeSearchResult.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 26/07/23.
//

import Foundation


struct YouTubeSearchListResponse: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    let items: [YouTubeVideoItem]
}

struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

struct YouTubeVideoItem: Codable {
    let kind: String
    let etag: String
    let id: YouTubeVideoId
}

struct YouTubeVideoId: Codable {
    let kind: String
    let videoId: String
}
