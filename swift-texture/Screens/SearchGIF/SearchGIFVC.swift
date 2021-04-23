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
    private let searchController = UISearchController()
    
    init(viewModel: SearchGIFVM = SearchGIFVM()) {
        self.viewModel = viewModel
        self.dataSource = SearchGIFDataSource(viewModel: viewModel)
        
        super.init(node: SearchGIFNode())
        node.collectionNode.dataSource = dataSource
        node.collectionNode.delegate = dataSource
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
        viewModel.bindGIFData(from: searchController.searchBar.rx.text.orEmpty.asDriver())
                
        viewModel.gifs
            .drive(onNext: { [unowned self] gifs in
                node?.searchNotFoundNode.isHidden = !gifs.isEmpty
                
                if viewModel.newIndexPaths.first?.row == 0 {
                    node.collectionNode.invalidateCalculatedLayout()
                    node.collectionNode.reloadData()
                } else {
                    node.collectionNode.insertItems(at: viewModel.newIndexPaths)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        node.backgroundColor = .systemBackground
        navigationItem.title = "Hello Texture!"
        
        // Search bar
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
