//
//  SearchGIFVC.swift
//  swift-texture
//
//  Created by Victor Samuel Cuaca on 23/04/21.
//

import AsyncDisplayKit
import RxSwift

final class SearchGIFVC: ASDKViewController<SearchGIFNode> {
    
    private let viewModel: SearchGIFVM
    private let disposeBag = DisposeBag()
    private let dataSource: SearchGIFDataSource
    private let activityIndicator = UIActivityIndicatorView()
    
    init(viewModel: SearchGIFVM = SearchGIFVM()) {
        self.viewModel = viewModel
        self.dataSource = SearchGIFDataSource(viewModel: viewModel)
        
        super.init(node: SearchGIFNode())
        node.collectionNode.dataSource = dataSource
        node.collectionNodeLayout?.delegate = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureRx()
    }
}

// MARK: - Configurations
extension SearchGIFVC {
    
    private func configureRx() {
        viewModel.searchQuery = navigationItem.searchController?.searchBar.rx.text.orEmpty.asDriver() ?? .just("")

        Observable.merge(
            viewModel.searchGIF(query: "Cat")
                .asObservable(),
            viewModel.searchQuery
                .skip(1)
                .debounce(.milliseconds(1000))
                .distinctUntilChanged()
                .map { $0.ifEmpty("Cat") }
                .asObservable()
                .flatMapLatest { [viewModel] in
                    viewModel.searchGIF(query: $0)
                }
        )
        .observeOn(MainScheduler.instance)
        .bind(to: viewModel.gifs)
        .disposed(by: disposeBag)
                
        viewModel.gifs
            .skip(1)
            .subscribe(onNext: { [node] gifs in
                node?.searchNotFoundNode.isHidden = !gifs.isEmpty
                node?.collectionNode.invalidateCalculatedLayout()
                node?.collectionNode.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        node.backgroundColor = .systemBackground
        navigationItem.title = "Hello Texture!"
        
        // Search bar
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search GIFs"
        navigationItem.searchController = searchController
        
        // Activity indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = .systemBackground
        node.view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
