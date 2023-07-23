//
//  ApiCaller.swift
//  NetflixClone
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
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
