//
//  GiphyResponse.swift
//  DemoOperation
//
//  Created by Victor Samuel Cuaca on 07/02/21.
//

import Foundation

struct GiphyResponse: Decodable {
    var data: [GIF] = []
    var pagination: Pagination = Pagination()
}

struct GIF: Decodable {
    let urlString: String
    @Clamping(50...300) var imageHeight: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case images
        case imageProperty = "fixed_width"
        case urlString = "url"
        case height
    }
    
    init(from decoder: Decoder) throws {
        let container     = try decoder.container(keyedBy: CodingKeys.self)
        let image         = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .images)
        let imageProperty = try image.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageProperty)
        let decodedUrl    = try imageProperty.decode(String.self, forKey: .urlString)
        urlString = decodedUrl
        imageHeight = Int(try imageProperty.decode(String.self, forKey: .height)) ?? 0
    }
}

struct Pagination: Decodable {
    var offset: Int = 0
    var totalCount: Int = 0
    var count: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case offset
        case totalCount = "total_count"
        case count
    }
}
