//
//  ApiCaller.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation


struct Constants{
    static let API_KEY              = "9c8b6d11ed2c2ff1c474a2724a27e190"
    static let POSTER_PATH          = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    static let BACKDROP_PATH        = "https://image.tmdb.org/t/p/w533_and_h300_bestv2"
    static let ORIGINAL_BG_PATH     = "https://image.tmdb.org/t/p/original"
    static let PROFILE_PATH         = "https://image.tmdb.org/t/p/w600_and_h900_bestv2"
    static let BASE_IMG_URL         = "https://image.tmdb.org/t/p/"
    static let BASE_URL             = "https://api.themoviedb.org"
    static let YOUTUBE_URL          = " https://www.youtube.com/watch?v="
    static let SEARCH_Movie_DELAY   = 1000
    static let MOVIE_PAGE_SIZE      = 20
    
//    urls
    static let TRENDING_MOVIES                  = "/3/trending/movie/day"
    static let TRENDING_TV                      = "/3/trending/tv/day"
    static let UPCOMING_MOVIES                  = "/3/movie/upcoming"
    static let POPULAR_MOVIES                   = "/3/movie/popular"
    static let TOP_RATED_MOVIES                 = "/3/movie/top_rated"
    static let NOW_PLAYING_MOVIES               = "/3/movie/now_playing"
    static let MOVIE_DETAILS                    = "/3/movie/"
    static let SIMILLAR_MOVIES                  = "/3/movie/{movie_id}/similar"
    static let MOVIE_CREDITS                    = "/3/movie/{movie_id}/credits"
    static let MOVIE_RECOMMENDATIONS            = "/3/movie/{movie_id}/recommendations"
    static let DICOVER_MOVIES                   = "/3/discover/movie"
    static let GENRE_LIST_FOR_MOVIES            = "/3/genre/movie/list"
    static let TRENDING_MOVIES_FOR_GIVEN_TIME   = "/3/trending/movie/{time_window}"
    static let SEARCH_MOVIE                     = "/3/search/movie"
    static let MOVIE_VIDEOS                     = "/3/movie/{id}/videos"
    static let PERSON_DETAILS                   = "/3/person/{person_id}"

    
}

enum APIError : Error {
    case failedToGetData
}

class ApiCaller{
    static let shared = ApiCaller()
    
    func fetchData<T: Decodable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)\(endpoint)?api_key=\(Constants.API_KEY)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
