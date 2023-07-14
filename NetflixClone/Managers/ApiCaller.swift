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
}

enum APIError : Error {
    case failedToGetData
}

class ApiCaller{
    static let shared = ApiCaller()
    
    func getTredingMovies(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
            
        }
        
        let task     = URLSession.shared.dataTask(with: URLRequest(url: url)){data,_,error in
            guard let data = data, error==nil else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(error))
            }
            
            
        }
        task.resume()
        
    }
    
    func getTredingTV(completion: @escaping (Result<[Tv],Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
            
        }
        
        let task     = URLSession.shared.dataTask(with: URLRequest(url: url)){data,_,error in
            guard let data = data, error==nil else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingTv.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(error))
            }
            
            
        }
        task.resume()
        
    }
    
    
    func getUpcomingMovies(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string: "\(Constants.BASE_URL)/3/movie/upcoming?api_key=\(Constants.API_KEY)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
            
        }
        
        let task     = URLSession.shared.dataTask(with: URLRequest(url: url)){data,_,error in
            guard let data = data, error==nil else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            do{
                let results = try JSONDecoder().decode(TrendingMovieResponse.self, from: data)
                completion(.success(results.results))
            } catch{
                completion(.failure(error))
            }
            
            
        }
        task.resume()
        
    }
    
    
    
    
    
    func fetchData<T: Decodable>(from endpoint: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/3\(endpoint)?api_key=\(Constants.API_KEY)") else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                let error = NSError(domain: "No data received", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    
//    @GET("movie/popular")
//       suspend fun getPopularMovies(@Query("page") page: Int): Response<MovieResponse>
//
//       @GET("movie/upcoming")
//       suspend fun getUpComingMovies(@Query("page") page: Int): Response<MovieResponse>
//
//       @GET("movie/now_playing")
//       suspend fun getNowPlayingMovies(
//           @Query("page") page: Int,
//
//           ): Response<MovieResponse>
//
//       @GET("movie/{movie_id}")
//       suspend fun getMovieDetail(@Path("movie_id") movieId: Int): Response<MovieDetailResponse>
//
//       @GET("movie/{movie_id}/similar")
//       suspend fun getSimilarMovies(@Path("movie_id") movieId: Int): Response<MovieResponse>
//
//       @GET("movie/{movie_id}/credits")
//       suspend fun getMovieCredits(@Path("movie_id") movieId: Int): Response<CastResponse>
//
//       @GET("movie/{movie_id}/recommendations")
//       suspend fun getRecommendationMovies(@Path("movie_id") movieId: Int): Response<MovieResponse>
//
//       @GET("discover/movie")
//       suspend fun discoverMoviesByGenre(
//           @Query("with_genres") with_genres: Int,
//           @Query("page") page: Int,
//           @Query("sort_by") sort_by: String = "popularity.desc"
//
//       ): Response<MovieResponse>
//
//       @GET("genre/movie/list")
//       suspend fun getGenres(): Response<GenreResponse>
//
//       @GET("trending/movie/{time_window}")
//       suspend fun trendingMovie(
//           @Path("time_window") time: String,
//           @QueryMap params: Map<String, String>
//       ): Response<MovieResponse>
//
//       @GET("search/movie")
//       suspend fun searchMovie(
//           @Query("query") query: String,
//           @Query("page") page: Int
//       ): Response<MovieResponse>
//
//       @GET("trending/movie/day")
//       suspend fun getTrendingMovies(@Query("page") page: Int): Response<MovieResponse>
//
//       @GET("movie/top_rated")
//       suspend fun getTopRatedMovies(
//           @Query("page") page: Int
//       ): Response<MovieResponse>
//
//       @GET("movie/{id}/videos")
//       suspend fun findTrailersById(
//           @Path("id") movieId: Int,
//       ): Response<TrailerResponse>
//
//       @GET("person/{person_id}")
//       suspend fun findPersonById(
//           @Path("person_id") person_id: Int
//       ): Response<Person>

    
    
}
