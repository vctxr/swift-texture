//
//  NetworkManager.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import Foundation

final class NetworkManager: Networking {
    
    static let shared = NetworkManager()
    var urlSession: URLSession = URLSession.shared
    
    private init() {}
    
    func request<T: Decodable>(with request: URLRequest,
                               isDecoded: Bool = true,
                               completion: @escaping (Result<T, RequestError>) -> Void) {
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                return completion(.failure(.noResponse))
            }
            
            guard (0..<300).contains(statusCode) else {
                return completion(.failure(.badResponse(statusCode: statusCode)))
            }
            
            if let error = error {
                return completion(.failure(.underlying(error: error, statusCode: statusCode)))
            }
            
            guard let data = data else {
                return completion(.failure(.badData(statusCode: statusCode)))
            }
            
            guard isDecoded else {
                return data is T ? completion(.success(data as! T)) :
                                   completion(.failure(.failedToDecode(statusCode: statusCode)))
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.failedToDecode(statusCode: statusCode)))
            }
        }
        task.resume()
    }
    
    func cancel() {
        urlSession.getTasksWithCompletionHandler { (dataTasks, _, _) in
            dataTasks.forEach { $0.cancel() }
        }
    }
}
