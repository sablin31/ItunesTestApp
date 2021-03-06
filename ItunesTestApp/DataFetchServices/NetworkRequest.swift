//
//  NetworkRequest.swift
//  ItunesTestApp
//
//  Created by Алексей Саблин on 08.02.2022.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func requestData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
