//
//  GiphyEndpoint.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import Foundation

enum GiphyEndpoint: Endpoint {
    case searchGIFs(query: String, offset: Int)
}

extension GiphyEndpoint {
    
    var baseUrl: String {
        return "https://api.giphy.com"
    }
    
    var path: String {
        switch self {
        case .searchGIFs:
            return "/v1/gifs/search"
        }
    }
    
    var urlParameters: [URLQueryItem] {
        guard let data = Keychain.load(key: .apiKey) else { return [] }
        let apiKey = String(decoding: data, as: UTF8.self)
        var urlQueryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        switch self {
        case .searchGIFs(query: let query, offset: let offset):
            urlQueryItems.append(URLQueryItem(name: "q", value: query))
            urlQueryItems.append(URLQueryItem(name: "offset", value: "\(offset)"))
            return urlQueryItems
        }
    }
}
