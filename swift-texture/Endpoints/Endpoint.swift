//
//  Endpoint.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
    
    var urlCompononents: URLComponents {
        var urlCompononents = URLComponents(string: baseUrl)
        urlCompononents?.path = path
        urlCompononents?.queryItems = urlParameters
        return urlCompononents!
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: urlCompononents.url!)
    }
}
