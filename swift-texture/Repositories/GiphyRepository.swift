//
//  GiphyRepository.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import RxSwift

struct GiphyRepository: GiphyRepositoryProtocol {
    
    private let networkManager: Networking
    
    init(networkManager: Networking = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func searchGIF(query: String, offset: Int) -> Single<GiphyResponse> {
        return Single.create { single in
            let request = GiphyEndpoint.searchGIFs(query: query, offset: offset).urlRequest
            
            networkManager.request(with: request, isDecoded: true) { (result: Result<GiphyResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    single(.error(error))
                case .success(let response):
                    single(.success(response))
                }
            }
            
           return Disposables.create()
        }
    }
}
