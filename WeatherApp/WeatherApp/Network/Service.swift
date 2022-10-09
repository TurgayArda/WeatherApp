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
    
    private let client: URLSession
    
    init(client: URLSession) {
        self.client = client
    }
    
    func fetch<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void) {

        client.dataTask(with: url) { (data,respone,error) in
            if error != nil || data == nil { return }

            do {
                let weatherdata = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(weatherdata))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}
