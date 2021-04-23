//
//  SearchGIFVM.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import RxSwift
import RxCocoa

final class SearchGIFVM {
    
    var searchQuery = Driver<String>.just("")
    let gifs = BehaviorRelay<[GIF]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
        
    private let repository: GiphyRepositoryProtocol
    
    init(repository: GiphyRepositoryProtocol = GiphyRepository()) {
        self.repository = repository
    }
    
    func searchGIF(query: String) -> Single<[GIF]> {
        self.isLoading.accept(true)
        
        return repository.searchGIF(query: query)
            .map(\.data)
            .do(
                onError: { error in
                    print(error)
                },
                onDispose: { [isLoading] in
                    isLoading.accept(false)
                }
            )
            .catchErrorJustReturn([])
    }
}
