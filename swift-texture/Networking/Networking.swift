//
//  NetworkManager.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import Foundation

enum RequestError: Error {
    case noResponse
    case badData(statusCode: Int)
    case failedToDecode(statusCode: Int)
    case underlying(error: Error, statusCode: Int)
    case badResponse(statusCode: Int)
}

protocol Networking {
    var urlSession: URLSession { get set }
    func request<T: Decodable>(with request: URLRequest,
                               isDecoded: Bool,
                               completion: @escaping (Result<T, RequestError>) -> Void)
    func cancel()
}
