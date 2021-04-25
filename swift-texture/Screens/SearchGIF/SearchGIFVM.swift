//
//  SearchGIFVM.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import RxSwift
import RxCocoa

final class SearchGIFVM {
    
    private let _isLoading     = BehaviorRelay<Bool>(value: false)
    private let _giphyResponse = BehaviorRelay<GiphyResponse>(value: GiphyResponse())
    private let _searchQuery   = BehaviorRelay<String>(value: "")
    private let disposeBag     = DisposeBag()
    
    private let defaultSearchQuery = "Cat"
    private let repository: GiphyRepositoryProtocol
    
    init(repository: GiphyRepositoryProtocol = GiphyRepository()) {
        self.repository = repository
    }
    
    func bindGIFData(from searchQuery: ControlProperty<String>) {
        searchQuery
            .bind(to: _searchQuery)
            .disposed(by: disposeBag)
        
        Observable.merge(
            searchGIF(query: defaultSearchQuery)
                .asObservable()
                .catchErrorJustReturn(GiphyResponse()),
            _searchQuery
                .map { [defaultSearchQuery] query in
                    query.ifEmpty(defaultSearchQuery)
                }
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .skip(1)
                .flatMapLatest { [unowned self] query in
                    searchGIF(query: query)
                        .catchErrorJustReturn(GiphyResponse())
                }
        )
        .bind(to: _giphyResponse)
        .disposed(by: disposeBag)
    }
    
    func fetchNewBatch(completion: @escaping () -> Void) {
        repository.searchGIF(query: _searchQuery.value.ifEmpty(defaultSearchQuery),
                             offset: paginationValue.offset + paginationValue.count)
            .do(onDispose: {
                completion()
            })
            .map { [unowned self] response in
                createNewBatchResponse(newResponse: response) }
            .subscribe(onSuccess: { [_giphyResponse] newBatchResponse in
                _giphyResponse.accept(newBatchResponse)
            })
            .disposed(by: disposeBag)
    }
    
    func gif(at indexPath: IndexPath) -> GIF {
        return _giphyResponse.value.data[indexPath.row]
    }
    
    func saveAPIKey(apiKey: String) {
        let data = Data(apiKey.utf8)
        Keychain.save(key: .apiKey, data: data)
    }
}

// MARK: - Getters
extension SearchGIFVM {
    
    var isLoading: Driver<Bool> {
        _isLoading.asDriver()
    }
    
    var gifs: Driver<[GIF]> {
        _giphyResponse.map(\.data)
            .asDriver(onErrorJustReturn: [])
    }
    
    var shouldFetchMore: Driver<Bool> {
        _giphyResponse
            .map { $0.pagination.offset < $0.pagination.totalCount }
            .asDriver(onErrorJustReturn: true)
    }
    
    var numberOfGIFs: Int {
        _giphyResponse.value.data.count
    }
    
    var paginationValue: Pagination {
        _giphyResponse.value.pagination
    }
    
    var isLoadingValue: Bool {
        _isLoading.value
    }
    
    var shouldFetchMoreValue: Bool {
        paginationValue.offset < paginationValue.totalCount
    }
    
    var newIndexPaths: [IndexPath] {
        let indexRange = (numberOfGIFs - paginationValue.count)..<numberOfGIFs
        return indexRange
            .filter { $0 >= 0 }
            .map { IndexPath(row: $0, section: 0) }
    }
    
    var apiKey: String? {
        guard let data = Keychain.load(key: .apiKey) else { return nil }
        return String(decoding: data, as: UTF8.self)
    }
}

// MARK: - Private Implementations
extension SearchGIFVM {
    
    private func searchGIF(query: String, offset: Int = 0) -> Single<GiphyResponse> {
        _isLoading.accept(true)
        
        return repository.searchGIF(query: query, offset: offset)
            .retry(3)
            .do(onDispose: { [_isLoading] in
                _isLoading.accept(false)
            })
    }
    
    private func createNewBatchResponse(newResponse: GiphyResponse) -> GiphyResponse {
        var response = _giphyResponse.value
        response.data.append(contentsOf: newResponse.data)
        response.pagination = newResponse.pagination
        response.pagination.count = newResponse.data.count
        return response
    }
}
