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
        
    private var footerNode: LoadingCellNode? {
        node.collectionNode.view.supplementaryNode(forElementKind: UICollectionView.elementKindSectionFooter,
                                                   at: IndexPath(item: 0, section: 0)) as? LoadingCellNode
    }
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.initialScrollOffset = -(UIDevice.current.safeAreaTopHeight + (navigationController?.navigationBar.frame.height ?? 0) + node.collectionNode.contentInset.top)
    }
}

// MARK: - Configurations
extension SearchGIFVC {
    
    private func configureRx() {
        // Bind GIF data
        viewModel.bindGIFData(from: searchController.searchBar.rx.text.orEmpty.asDriver())
             
        // Collection data
        viewModel.gifs
            .drive(onNext: { [unowned self] gifs in
                node?.searchNotFoundNode.isHidden = !gifs.isEmpty
                updateCollectionNodeData(for: viewModel.newIndexPaths)
            })
            .disposed(by: disposeBag)
        
        // Right bar button
        navigationItem.rightBarButtonItem?.rx.tap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .flatMap { [unowned self] in
                presentAlertWithField(title: "Enter your Giphy API Key 🔑",
                                      text: viewModel.apiKey,
                                      placeholder: "Giphy API Key")
            }
            .subscribe(onNext: { [unowned self] apiKey in
                viewModel.saveAPIKey(apiKey: apiKey)
            })
            .disposed(by: disposeBag)
        
        // Loading state
        viewModel.isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // Footer loading state
        viewModel.shouldFetchMore
            .drive(onNext: { [unowned self] shouldFetchMore in
                footerNode?.isHidden = !shouldFetchMore
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "Hello Texture!"
        node.backgroundColor = .systemBackground
        configureSearchBar()
        configureBarButtonItems()
        configureActivityIndicator()
    }
}

// MARK: - Private Implementations
extension SearchGIFVC {
    
    private func updateCollectionNodeData(for newIndexPaths: [IndexPath]) {
        if newIndexPaths.first?.row == 0 {
            node.collectionNode.invalidateCalculatedLayout()
            node.collectionNode.reloadData()
            node.collectionNode.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        } else {
            node.collectionNode.insertItems(at: newIndexPaths)
        }
    }
    
    private func configureSearchBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search GIFs"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureBarButtonItems() {
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "key.fill"),
                                             style: .done,
                                             target: nil,
                                             action: nil)
        rightBarButton.tintColor = .systemIndigo
        navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    private func configureActivityIndicator() {
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
