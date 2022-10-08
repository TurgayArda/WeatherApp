//
//  Service.swift
//  WeatherApp
//
//  Created by Arda Sisli on 8.10.2022.
//

import Foundation

enum HttpError: Error {
    case  errorDecodingData
}


protocol HttpClientProtocol {
    func fetch<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void)
}

class HttpClient: HttpClientProtocol {
    func fetch<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data,respone,error) in
            if error != nil || data == nil {
                return
            }

            do {
                let weatherdata = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(weatherdata))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
