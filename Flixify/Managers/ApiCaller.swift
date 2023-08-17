//
//  ApiCaller.swift
//  Flixify
//
//  Created by Pranav Choudhary on 14/07/23.
//

import Foundation




enum APIError : Error {
    case failedToGetData
}

class ApiCaller{
    static let shared = ApiCaller()
    
    func fetchData<T: Decodable>(from endpoint: String,with extraQueryParams: String? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.BASE_URL)\(endpoint)?api_key=\(Constants.API_KEY)\(extraQueryParams != nil && !extraQueryParams!.isEmpty ? "&\(extraQueryParams ?? "")" : "")") else {
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
            } catch let err{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    
//
//    GET https://youtube.googleapis.com/youtube/v3/search?key=[YOUR_API_KEY] HTTP/1.1
//
//    Authorization: Bearer [YOUR_ACCESS_TOKEN]
//    Accept: application/json

    
    
    func getMoviesFromYoutube<T: Decodable>(with query: String? = nil, completion: @escaping (Result<T, Error>) -> Void){
        guard let query = query?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return}
        guard let url = URL(string: "\(Constants.YOUTUBE_BASE_URL)q=\(query)&key=\(Constants.YOUTUBE_API_KEY)") else{
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
            } catch let error{
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
