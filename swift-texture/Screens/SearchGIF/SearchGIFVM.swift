//
//  SearchGIFVM.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import RxSwift
import RxCocoa
import AsyncDisplayKit

final class SearchGIFVM {
    
    private let _giphyResponse = BehaviorRelay<GiphyResponse>(value: GiphyResponse())
    private let _searchQuery   = BehaviorRelay<String>(value: "")
    private let _isLoading     = BehaviorRelay<Bool>(value: false)
    private let disposeBag     = DisposeBag()
    
    private let defaultSearchQuery = "Cat"
    private let repository: GiphyRepositoryProtocol
    
    init(repository: GiphyRepositoryProtocol = GiphyRepository()) {
        self.repository = repository
    }
    
    func searchGIF(query: String, offset: Int = 0) -> Single<GiphyResponse> {
        _isLoading.accept(true)
        
        return repository.searchGIF(query: query, offset: offset)
            .do(onDispose: { [_isLoading] in
                _isLoading.accept(false)
            })
    }
    
    func bindGIFData(from searchQuery: Driver<String>) {
        searchQuery
            .drive(_searchQuery)
            .disposed(by: disposeBag)
        
        Observable.merge(
            searchGIF(query: defaultSearchQuery)
                .asObservable(),
            _searchQuery
                .skip(1)
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .flatMapLatest { [unowned self] query in
                    searchGIF(query: query.ifEmpty(defaultSearchQuery))
                }
        )
        .catchErrorJustReturn(GiphyResponse())
        .bind(to: _giphyResponse)
        .disposed(by: disposeBag)
    }
    
    func fetchNewBatch(with context: ASBatchContext) {
        repository.searchGIF(query: _searchQuery.value.ifEmpty(defaultSearchQuery),
                             offset: pagination.offset + pagination.count)
            .do(onDispose: {
                context.completeBatchFetching(true)
            })
            .subscribe(onSuccess: { response in
                var _response = self._giphyResponse.value
                _response.data.append(contentsOf: response.data)
                _response.pagination = response.pagination
                
                self._giphyResponse.accept(_response)
            })
            .disposed(by: disposeBag)
    }
    
    func gif(at indexPath: IndexPath) -> GIF {
        return _giphyResponse.value.data[indexPath.row]
    }
}

// MARK: - Getters
extension SearchGIFVM {
    
    var gifs: Driver<[GIF]> {
        _giphyResponse.map(\.data).asDriver(onErrorJustReturn: [])
    }
    
    var numberOfGIFs: Int {
        _giphyResponse.value.data.count
    }
    
    var isLoading: Driver<Bool> {
        _isLoading.asDriver()
    }
    
    var pagination: Pagination {
        _giphyResponse.value.pagination
    }
    
    var newIndexPaths: [IndexPath] {
        let indexRange = (numberOfGIFs - pagination.count)..<numberOfGIFs
        return indexRange.map { IndexPath(row: $0, section: 0) }
    }
}
