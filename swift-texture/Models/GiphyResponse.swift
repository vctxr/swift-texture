//
//  GiphyResponse.swift
//  DemoOperation
//
//  Created by Victor Samuel Cuaca on 07/02/21.
//

import Foundation

struct GiphyResponse: Decodable {
    let data: [GIF]
}

struct GIF: Decodable {
    let urlString: String
    let imageHeight: Int
    
    enum CodingKeys: String, CodingKey {
        case image = "images"
        case fixedWidth = "fixed_width"
        case urlString = "url"
        case height = "height"
    }
    
    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        let image         = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .image)
        let imageProperty = try image.nestedContainer(keyedBy: CodingKeys.self, forKey: .fixedWidth)
        let decodedUrl    = try imageProperty.decode(String.self, forKey: .urlString)
        urlString = decodedUrl
        imageHeight = Int(try imageProperty.decode(String.self, forKey: .height)) ?? 0
    }
}
