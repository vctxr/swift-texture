//
//  GiphyRepositoryProtocol.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import RxSwift

protocol GiphyRepositoryProtocol {
    func searchGIF(query: String, offset: Int) -> Single<GiphyResponse>
}
